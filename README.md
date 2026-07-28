# PersiaFava SMS SDKs

کیت‌های توسعه نرم‌افزار رسمی برای وب‌سرویس REST پیامک پرشیا فاوا.

## زبان‌های موجود

| پوشه | زبان | نصب |
|---|---|---|
| [`persiafava-php/`](./persiafava-php) | PHP 7.2+ | `composer require persiafava/sms-sdk` |
| [`persiafava-node/`](./persiafava-node) | Node.js | `npm install persiafava-sms-sdk` |
| [`persiafava-python/`](./persiafava-python) | Python 3.6+ | `pip install persiafava-sms-sdk` |
| [`persiafava-dotnet/`](./persiafava-dotnet) | C# / .NET 6+ | `dotnet add package PersiaFava.Sms.Sdk` |
| [`persiafava-java/`](./persiafava-java) | Java 11+ | Maven (`pom.xml` شامل شده) |
| [`persiafava-go/`](./persiafava-go) | Go 1.20+ | `go get github.com/persiafava/persiafava-go` |
| [`persiafava-ruby/`](./persiafava-ruby) | Ruby 2.6+ | `gem install persiafava-sms-sdk` |
| [`persiafava-delphi/`](./persiafava-delphi) | Delphi (Indy) | افزودن دستی فایل واحد به پروژه |
| [`persiafava-laravel/`](./persiafava-laravel) | Laravel | `composer require persiafava/laravel-sms-sdk` |
| [`persiafava-yii2/`](./persiafava-yii2) | Yii2 | `composer require persiafava/yii2-sms-sdk` |

هر SDK پوشش کامل ۱۶ متد REST را دارد: ارسال پیامک، وضعیت دلیوری، دریافتی‌ها، اطلاعات کاربر، مدیریت دفترچه تلفن (گروه‌ها و شماره‌ها)، کلمات کلیدی/لیبل، و لینک ورود یکبار‌مصرف. مستندات کامل و دقیق هر پارامتر در `persia_fava_docs.html` است.

## احراز هویت

هر کلاینت از دو روش پشتیبانی می‌کند (در هر درخواست فقط یکی از این دو استفاده می‌شود، نه هر دو با هم):

1. `Client(username, password)`
2. `Client(api_key)`

## خطاها

الگوی یکسان در همه‌ی زبان‌ها:

- **ApiException** — درخواست به سرور رسید اما خود API خطا برگرداند (اعتبار ناکافی، پارامتر نامعتبر و غیره)
- **HttpException / HttpRequestException** — ارتباط با سرور برقرار نشد (قطعی شبکه، تایم‌اوت و غیره)

## پوشش API

این نسخه فقط پلتفرم **REST** را پوشش می‌دهد. پلتفرم‌های SOAP، ESB، ارسال با URL و VMS در این SDKها پیاده‌سازی نشده‌اند؛ برای این پلتفرم‌ها به مستندات `persia_fava_docs.html` مراجعه کنید.

## لایسنس

MIT
