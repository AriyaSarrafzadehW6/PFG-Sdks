# PersiaFava SMS SDK — PHP

کلاینت رسمی PHP برای وب‌سرویس REST پیامک پرشیا فاوا. این پکیج تمام متدهای اصلی و حرفه‌ای REST (ارسال، دریافت، دفترچه تلفن، کلمات کلیدی و ...) را به‌صورت متدهای ساده PHP در اختیار شما می‌گذارد.

مستندات کامل API: فایل `persia_fava_docs.html` در مخزن مستندات.

## نصب

```bash
composer require persiafava/sms-sdk
```

## استفاده سریع

```php
use PersiaFava\Client;

$client = new Client('USERNAME', 'PASSWORD');
// یا: $client = new Client('YOUR_API_KEY');

$result = $client->send([
    'receiver_number' => '09123456789',
    'sender_number'   => '3000569999',
    'note_arr[]'      => 'سلام دنیا!',
]);
print_r($result);
```

## احراز هویت

دو روش پشتیبانی می‌شود:
- `new Client($username, $password)`
- `new Client($apiKey)` — پیشنهادی، فقط یک آرگومان بدهید

## متدهای موجود

| متد PHP | معادل REST | توضیح |
|---|---|---|
| `UserInfo()` | `user_info` | از این متد برای دریافت اطلاعات کاربری و شماره های اختصاصی و میزان شارژ استفاده می‌شود. |
| `Send()` | `sms_send` | از این متد برای ارسال پیامک از طریق معماری رست استفاده می شود. اطلاعات میتوانند توسط متد POST ارسال شوند. |
| `DeliveryStatus()` | `sms_deliver` | از این متد برای اطلاع از وضعیت پیامک های ارسال شده استفاده می شود. |
| `ReceivedList()` | `sms_receive_list` | از این متد برای لیست پیامک های دریافتی استفاده می شود. |
| `PhonebookGroupAdd()` | `user_cat_add` | از این متد برای ایجاد گروه جدید در دفترتلفن استفاده می شود. |
| `PhonebookGroupList()` | `user_cat_list` | از این متد برای دریافت لیست گروه های دفتر تلفن استفاده می شود. |
| `PhonebookGroupInfo()` | `user_cat_info` | از این متد برای دریافت مشخصات یک گروه از دفتر تلفن استفاده می شود. |
| `PhonebookNumberAdd()` | `sms_number_add` | از این متد برای اضافه کردن شماره ی جدید به دفترتلفن استفاده می شود. |
| `PhonebookNumberList()` | `sms_number_list` | از این متد برای دریافت لیست شماره های دفتر تلفن استفاده می شود. |
| `PhonebookNumberUpdate()` | `sms_number_update` | از این متد برای به روز کردن تعداد شماره های گروه های دفتر تلفن استفاده می شود. |
| `ReceivedMarkAsRead()` | `sms_receive_change_read` | از این متد برای تغییر وضعیت خوانده شدن پیام های دریافتی استفاده می شود. |
| `LabelList()` | `label_list` | از این متد برای دریافت لیست کلمات کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود. |
| `LabelAdd()` | `label_new` | از این متد برای ایجاد کلمه کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود. |
| `LabelEdit()` | `label_edit` | از این متد برای ویرایش کلمات کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود. |
| `LabelDelete()` | `label_remove` | از این متد برای حذف کلمه ی کلیدی استفاده می شود. |
| `OnceLoginLink()` | `user_once_login` | از این متد برای ایجاد لینک ورود مدت دار یک بار مصرف استفاده می شود. |

## خطاها

- `PersiaFava\Exceptions\ApiException` — سرور پاسخ داد اما درخواست ناموفق بود (اعتبار ناکافی، پارامتر نامعتبر و ...)
- `PersiaFava\Exceptions\HttpException` — ارتباط با سرور اصلاً برقرار نشد

## لایسنس

MIT
