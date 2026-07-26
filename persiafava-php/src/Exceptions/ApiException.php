<?php

namespace PersiaFava\Exceptions;

/**
 * پرتاب می‌شود وقتی سرور پاسخ می‌دهد اما نتیجه (result) درخواست false است،
 * یعنی ارتباط برقرار شده ولی خود API خطایی گزارش کرده (مثلاً اعتبار ناکافی، پارامتر نامعتبر و ...).
 */
class ApiException extends \Exception
{
}
