# PersiaFava SMS SDK — Yii2

پوسته‌ی نازک Yii2 Component روی [`persiafava/sms-sdk`](../persiafava-php) (که باید به‌عنوان وابستگی نصب شود).

## نصب

```bash
composer require persiafava/yii2-sms-sdk
```

در `config/web.php` (یا `console.php`):

```php
'components' => [
    'persiafava' => [
        'class' => \persiafava\yii2\PersiaFavaComponent::class,
        'apiKey' => 'YOUR_API_KEY',
    ],
],
```

## استفاده سریع

```php
$result = Yii::$app->persiafava->send([
    'receiver_number' => '09123456789',
    'sender_number'   => '3000569999',
    'note_arr[]'      => 'سلام دنیا!',
]);
```

تمام ۱۶ متد REST همان‌طور که در [PHP SDK](../persiafava-php/README.md) مستند شده، از طریق `Yii::$app->persiafava->METHOD_NAME()` در دسترس‌اند.

## لایسنس

MIT
