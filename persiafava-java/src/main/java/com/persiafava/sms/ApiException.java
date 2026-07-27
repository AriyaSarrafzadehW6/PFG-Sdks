package com.persiafava.sms;

/** سرور پاسخ داد اما نتیجه (result) درخواست false بود. */
public class ApiException extends Exception {
    public ApiException(String message) {
        super(message);
    }
}
