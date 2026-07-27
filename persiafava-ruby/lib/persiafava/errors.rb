module PersiaFava
  # سرور پاسخ داد اما نتیجه (result) درخواست false بود.
  class ApiException < StandardError; end

  # اصلاً امکان برقراری ارتباط با سرور پرشیا فاوا وجود نداشت.
  class HttpException < StandardError; end
end
