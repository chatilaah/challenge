const int kVersion_1_00 = 1;

/// A helper class that assists the process of upgrade or downgrade of
/// an existing database whenever the application is upgraded.
///
abstract class MigrationHelper {
  Future<void> migrate();
}
