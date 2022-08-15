enum ErrorType {
  /// The error is unknown.
  unknown,

  /// A response error has occurred.
  response,

  /// A network-related error.
  socket,

  /// A parsing error due to bad data format.
  parse;

  @override
  String toString() {
    switch (this) {
      case ErrorType.unknown:
        return 'Unknown Error';
      case ErrorType.socket:
        return 'Network Error';
      case ErrorType.parse:
        return 'Parsing Error';
      case ErrorType.response:
        return 'Server Error';
    }
  }

  String toDescription({int? code}) {
    switch (this) {
      case ErrorType.unknown:
        return 'An undefined error was raised.';
      case ErrorType.socket:
        return 'A network-related error has occurred, please check your internet connection and try again.';
      case ErrorType.parse:
        return 'Failed to parse data retrieved from the server.';
      case ErrorType.response:
        return 'The server responded with error ($code)';
    }
  }
}
