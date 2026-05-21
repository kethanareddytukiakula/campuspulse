/// Auth repository contract for CampusPulse.
///
/// Define auth domain logic and repository interfaces.
abstract class AuthRepository {
  Future<bool> login(String email, String password);
}
