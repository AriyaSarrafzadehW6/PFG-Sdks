# PersiaFava SMS SDK — Delphi

کلاینت رسمی Delphi برای وب‌سرویس REST پیامک پرشیا فاوا. مبتنی بر کتابخانه Indy (`IdHTTP` + `IdSSLOpenSSL`) که به‌صورت پیش‌فرض همراه Delphi نصب است.

## نصب

فایل `PersiaFavaClient.pas` را به پروژه‌ی خود اضافه کنید (`uses PersiaFavaClient;`).

## استفاده سریع

```pascal
var
  Client: TPersiaFavaClient;
  Response: TStringList;
begin
  Client := TPersiaFavaClient.Create('USERNAME', 'PASSWORD');
  // یا: Client := TPersiaFavaClient.Create('YOUR_API_KEY');
  try
    Response := Client.Send('09123456789', '3000569999', 'سلام دنیا!');
    WriteLn(Response.Text);
    Response.Free;
  finally
    Client.Free;
  end;
end;
```

## متدهای موجود

| متد Delphi | معادل REST | توضیح |
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

- `EPersiaFavaApiException` — سرور پاسخ داد اما درخواست ناموفق بود
- `EPersiaFavaHttpException` — ارتباط با سرور برقرار نشد

## لایسنس

MIT
