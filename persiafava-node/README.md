# PersiaFava SMS SDK — Node.js

کلاینت رسمی Node.js (JavaScript) برای وب‌سرویس REST پیامک پرشیا فاوا.

مستندات کامل API: فایل `persia_fava_docs.html` در مخزن مستندات.

## نصب

```bash
npm install persiafava-sms-sdk
```

## استفاده سریع

```js
const PersiaFavaClient = require('persiafava-sms-sdk');

const client = new PersiaFavaClient('YOUR_API_KEY');

client.sendSms(['09123456789'], '3000569999', 'سلام دنیا!').then(console.log).catch(console.error);
```

## متدهای موجود

| متد JS | معادل REST | توضیح |
|---|---|---|
| `userInfo()` | `user_info` | از این متد برای دریافت اطلاعات کاربری و شماره های اختصاصی و میزان شارژ استفاده می‌شود. |
| `send()` | `sms_send` | از این متد برای ارسال پیامک از طریق معماری رست استفاده می شود. اطلاعات میتوانند توسط متد POST ارسال شوند. |
| `deliveryStatus()` | `sms_deliver` | از این متد برای اطلاع از وضعیت پیامک های ارسال شده استفاده می شود. |
| `receivedList()` | `sms_receive_list` | از این متد برای لیست پیامک های دریافتی استفاده می شود. |
| `phonebookGroupAdd()` | `user_cat_add` | از این متد برای ایجاد گروه جدید در دفترتلفن استفاده می شود. |
| `phonebookGroupList()` | `user_cat_list` | از این متد برای دریافت لیست گروه های دفتر تلفن استفاده می شود. |
| `phonebookGroupInfo()` | `user_cat_info` | از این متد برای دریافت مشخصات یک گروه از دفتر تلفن استفاده می شود. |
| `phonebookNumberAdd()` | `sms_number_add` | از این متد برای اضافه کردن شماره ی جدید به دفترتلفن استفاده می شود. |
| `phonebookNumberList()` | `sms_number_list` | از این متد برای دریافت لیست شماره های دفتر تلفن استفاده می شود. |
| `phonebookNumberUpdate()` | `sms_number_update` | از این متد برای به روز کردن تعداد شماره های گروه های دفتر تلفن استفاده می شود. |
| `receivedMarkAsRead()` | `sms_receive_change_read` | از این متد برای تغییر وضعیت خوانده شدن پیام های دریافتی استفاده می شود. |
| `labelList()` | `label_list` | از این متد برای دریافت لیست کلمات کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود. |
| `labelAdd()` | `label_new` | از این متد برای ایجاد کلمه کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود. |
| `labelEdit()` | `label_edit` | از این متد برای ویرایش کلمات کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود. |
| `labelDelete()` | `label_remove` | از این متد برای حذف کلمه ی کلیدی استفاده می شود. |
| `onceLoginLink()` | `user_once_login` | از این متد برای ایجاد لینک ورود مدت دار یک بار مصرف استفاده می شود. |

## خطاها

- `ApiException` — سرور پاسخ داد اما درخواست ناموفق بود
- `HttpException` — ارتباط با سرور برقرار نشد

## لایسنس

MIT
