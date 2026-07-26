class ApiException extends Error {
  // پرتاب می‌شود وقتی سرور پاسخ می‌دهد اما result برابر false است
  constructor(message) {
    super(message);
    this.name = 'ApiException';
  }
}

class HttpException extends Error {
  // پرتاب می‌شود وقتی اصلاً ارتباط با سرور برقرار نشود
  constructor(message) {
    super(message);
    this.name = 'HttpException';
  }
}

module.exports = { ApiException, HttpException };
