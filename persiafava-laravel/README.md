# PersiaFava SMS SDK — Laravel

پوسته‌ی نازک Laravel (Service Provider + Facade) روی [`persiafava/sms-sdk`](../persiafava-php) (که باید به‌عنوان وابستگی نصب شود).

## نصب

```bash
composer require persiafava/laravel-sms-sdk
php artisan vendor:publish --tag=config
```

در `.env`:

```
PERSIAFAVA_API_KEY=your_api_key
```

## استفاده سریع

```php
use PersiaFava\Laravel\Facades\PersiaFava;

$result = PersiaFava::send(
    receiver_number: '09123456789',
    sender_number: '3000569999',
    note_arr: 'سلام دنیا!'
);
```

یا از طریق Dependency Injection مستقیم کلاس `PersiaFava\Client`.

تمام ۱۶ متد REST همان‌طور که در [PHP SDK](../persiafava-php/README.md) مستند شده در دسترس‌اند.

## لایسنس

MIT
