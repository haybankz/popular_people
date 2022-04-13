class Result<T> {
  Status? status;
  T? data;
  String message = "";

  Result({
    this.message = "Unknown error occurred",
    this.data,
    this.status,
  });
  Result.loading(this.message) : status = Status.loading;
  Result.completed(this.data) : status = Status.completed;
  Result.error(this.message) : status = Status.error;

  bool isInitialState() => !(status == Status.completed && data != null);

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status { loading, completed, error }
