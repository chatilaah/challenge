abstract class BaseResponse<T> {
  abstract int code;
  abstract String message;
  abstract T data;
  bool offline = false;

  Map<String, dynamic> toJson();

  /// Camel-case
  static Map<String, dynamic> toParseErrorV1() => {
        'responseCode': 'Error',
        'responseMessage':
            'Parsing failed because of the retrieved data not being formatted as needed by the application.\nTo resolve this issue, please report the incidence to the server team.',
        'responseData': null
      };

  /// Capitalized initials
  static Map<String, dynamic> toParseError() => {
        'ResponseCode': 'Error',
        'ResponseMessage':
            'Parsing failed because of the retrieved data not being formatted as needed by the application.\nTo resolve this issue, please report the incidence to the server team.',
        'ResponseData': null
      };
}
