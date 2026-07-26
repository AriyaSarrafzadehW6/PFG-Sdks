<?php

namespace PersiaFava\Exceptions;

/**
 * پرتاب می‌شود وقتی اصلاً امکان برقراری ارتباط با سرور پرشیا فاوا وجود نداشته باشد
 * (قطعی شبکه، تایم‌اوت، خطای DNS و مواردی از این دست).
 */
class HttpException extends \Exception
{
}
