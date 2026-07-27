# PersiaFava SMS SDKs

کیت‌های توسعه نرم‌افزار (SDK) رسمی برای وب‌سرویس REST پیامک پرشیا فاوا.

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

هر ۷ SDK پوشش کامل ۱۶ متد REST را دارند: ارسال پیامک، وضعیت دلیوری، دریافتی‌ها، اطلاعات کاربر، مدیریت دفترچه تلفن (گروه‌ها و شماره‌ها)، کلمات کلیدی/لیبل، و لینک ورود یکبار‌مصرف.

## احراز هویت

هر ۷ کلاینت از دو روش پشتیبانی می‌کنند:
1. `Client(username, password)`
2. `Client(api_key)` — پیشنهادی؛ از پنل کاربری یک API Key بسازید و فقط همان را بدهید.

## خطاها

الگوی یکسان در همه‌ی زبان‌ها :
- **ApiException** — درخواست به سرور رسید اما خود API خطا برگرداند (اعتبار ناکافی، پارامتر نامعتبر...)
- **HttpException / HttpRequestException** — اصلاً امکان برقراری ارتباط با سرور نبود (قطعی شبکه، تایم‌اوت...)


## لایسنس

Aria.Sarrafzadeh — © PersiaFava
