package com.persiafava.sms;

/** اصلاً امکان برقراری ارتباط با سرور پرشیا فاوا وجود نداشت. */
public class HttpRequestException extends Exception {
    public HttpRequestException(String message) {
        super(message);
    }
}
