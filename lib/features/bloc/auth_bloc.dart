import 'package:bloc/bloc.dart';
import 'package:firebase_application/features/data/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthRepository _authRepository;
  AuthRepository get authRepository => _authRepository;
  User? get currentUser => _authRepository.currentUser;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AuthStarted>((event, emit) {
      final user = _authRepository.currentUser;
      if (user != null) {
        emit(Authenticated(uid: user.uid));
      } else {
        emit(Unauthenticated());
      }
    });

    on<AuthGoogleSignInRequested>((event, emit) async {
      // print('current state: bloc :: $state');
      emit(AuthLoading());

      try {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) {
          // User canceled the sign-in, emit failure or initial state
          emit(AuthFailure("Sign-in aborted by user."));
          // return;
        }

        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        final userCredential = await FirebaseAuth.instance.signInWithCredential(
          credential,
        );
        final User? user = userCredential.user;

        if (user != null) {
          emit(Authenticated(uid: user.uid));
        } else {
          emit(AuthFailure("Google Sign-In aborted."));
        }
      } catch (e, stackTrace) {
        // Optionally log the error and stackTrace for debugging
        print("Error during Google Sign-In: $e");
        emit(AuthFailure(e.toString()));
      }
    });

    // catch (e) {
    //   emit(AuthFailure(e.toString()));
    // }
    // }

    on<AuthLoggedOut>((event, emit) async {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      await _authRepository.signOut();
      _authRepository = AuthRepository();
      emit(Unauthenticated());
    });
  }
}
