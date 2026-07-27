# PersiaFava SMS SDKs

کیت‌های توسعه نرم‌افزار (SDK) رسمی برای وب‌سرویس REST پیامک پرشیا فاوا.

این مخزن مستقیماً و به‌صورت خودکار از روی مستندات فنی کامل API (`persia_fava_docs.html`) تولید شده تا هیچ متد یا پارامتری از قلم نیفتد و هر تغییر در API به‌سادگی در همه‌ی زبان‌ها هم‌زمان به‌روزرسانی شود.

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

## وضعیت اعتبارسنجی کد

- PHP: بررسی تعادل ساختار دستی (بدون php-cli در محیط تولید)
- Node.js: `node --check` ✅ گذرانده شد
- Python: `python -m py_compile` ✅ گذرانده شد + تست عملکردی instantiation
- C# / Java / Go / Ruby: بدون کامپایلر در محیط تولید، فقط بررسی تعادل ساختاری دستی انجام شد — **پیشنهاد می‌شود پیش از انتشار در پروژه واقعی، یک بار در محیط build خودتان کامپایل/اجرا شوند**

## نقشه راه (فریم‌ورک‌های بعدی)

Laravel و Yii2 wrapper (پوسته‌ی نازک روی همین PHP SDK با service provider / component اختصاصی هر فریم‌ورک) و Delphi در دستور کار بعدی هستند.

## لایسنس

MIT — © PersiaFava
