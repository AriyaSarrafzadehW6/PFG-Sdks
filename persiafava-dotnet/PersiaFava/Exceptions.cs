using System;

namespace PersiaFava
{
    /// <summary>سرور پاسخ داد اما نتیجه (result) درخواست false بود.</summary>
    public class ApiException : Exception
    {
        public ApiException(string message) : base(message) { }
    }

    /// <summary>اصلاً امکان برقراری ارتباط با سرور پرشیا فاوا وجود نداشت.</summary>
    public class HttpRequestFailedException : Exception
    {
        public HttpRequestFailedException(string message) : base(message) { }
    }
}
