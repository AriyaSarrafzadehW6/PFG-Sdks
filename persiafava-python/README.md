# PersiaFava SMS SDK — Python

کلاینت رسمی Python برای وب‌سرویس REST پیامک پرشیا فاوا.

مستندات کامل API: فایل `persia_fava_docs.html` در مخزن مستندات.

## نصب

```bash
pip install persiafava-sms-sdk
```

## استفاده سریع

```python
from persiafava import Client

client = Client('USERNAME', 'PASSWORD')
# یا: client = Client('YOUR_API_KEY')

result = client.send(
    receiver_number='09123456789',
    sender_number='3000569999',
    note_arr='سلام دنیا!',
)
print(result)
```

## متدهای موجود

| متد پایتون | معادل REST | توضیح |
|---|---|---|
| `user_info()` | `user_info` | از این متد برای دریافت اطلاعات کاربری و شماره های اختصاصی و میزان شارژ استفاده می‌شود. |
| `send()` | `sms_send` | از این متد برای ارسال پیامک از طریق معماری رست استفاده می شود. اطلاعات میتوانند توسط متد POST ارسال شوند. |
| `delivery_status()` | `sms_deliver` | از این متد برای اطلاع از وضعیت پیامک های ارسال شده استفاده می شود. |
| `received_list()` | `sms_receive_list` | از این متد برای لیست پیامک های دریافتی استفاده می شود. |
| `phonebook_group_add()` | `user_cat_add` | از این متد برای ایجاد گروه جدید در دفترتلفن استفاده می شود. |
| `phonebook_group_list()` | `user_cat_list` | از این متد برای دریافت لیست گروه های دفتر تلفن استفاده می شود. |
| `phonebook_group_info()` | `user_cat_info` | از این متد برای دریافت مشخصات یک گروه از دفتر تلفن استفاده می شود. |
| `phonebook_number_add()` | `sms_number_add` | از این متد برای اضافه کردن شماره ی جدید به دفترتلفن استفاده می شود. |
| `phonebook_number_list()` | `sms_number_list` | از این متد برای دریافت لیست شماره های دفتر تلفن استفاده می شود. |
| `phonebook_number_update()` | `sms_number_update` | از این متد برای به روز کردن تعداد شماره های گروه های دفتر تلفن استفاده می شود. |
| `received_mark_as_read()` | `sms_receive_change_read` | از این متد برای تغییر وضعیت خوانده شدن پیام های دریافتی استفاده می شود. |
| `label_list()` | `label_list` | از این متد برای دریافت لیست کلمات کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود. |
| `label_add()` | `label_new` | از این متد برای ایجاد کلمه کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود. |
| `label_edit()` | `label_edit` | از این متد برای ویرایش کلمات کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود. |
| `label_delete()` | `label_remove` | از این متد برای حذف کلمه ی کلیدی استفاده می شود. |
| `once_login_link()` | `user_once_login` | از این متد برای ایجاد لینک ورود مدت دار یک بار مصرف استفاده می شود. |

## خطاها

- `ApiException` — سرور پاسخ داد اما درخواست ناموفق بود
- `HttpException` — ارتباط با سرور برقرار نشد

## لایسنس

MIT
