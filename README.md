# PersiaFava SMS SDKs

کیت‌های توسعه نرم‌افزار (SDK) رسمی برای وب‌سرویس REST پیامک پرشیا فاوا.

این مخزن مستقیماً از روی مستندات فنی کامل API (`persia_fava_docs.html`) تولید شده تا هیچ متد یا پارامتری از قلم نیفتد و هر تغییر در API به‌سادگی در هر سه زبان همگام بماند.

## زبان‌های موجود

| پوشه | زبان | نصب |
|---|---|---|
| [`persiafava-php/`](./persiafava-php) | PHP 7.2+ | `composer require persiafava/sms-sdk` |
| [`persiafava-node/`](./persiafava-node) | Node.js | `npm install persiafava-sms-sdk` |
| [`persiafava-python/`](./persiafava-python) | Python 3.6+ | `pip install persiafava-sms-sdk` |

هر سه SDK پوشش کامل ۱۶ متد REST را دارند: ارسال پیامک، وضعیت دلیوری، دریافتی‌ها، اطلاعات کاربر، مدیریت دفترچه تلفن (گروه‌ها و شماره‌ها)، کلمات کلیدی/لیبل، و لینک ورود یکبار‌مصرف.

## احراز هویت

هر سه کلاینت از دو روش پشتیبانی می‌کنند:
1. `Client(username, password)`
2. `Client(api_key)` — پیشنهادی؛ از پنل کاربری یک API Key بسازید و فقط همان را بدهید.

## خطاها

الگوی یکسان در هر سه زبان (مشابه SDKهای معتبر صنعت):
- **ApiException** — درخواست به سرور رسید اما خود API خطا برگرداند (اعتبار ناکافی، پارامتر نامعتبر...)
- **HttpException** — اصلاً امکان برقراری ارتباط با سرور نبود (قطعی شبکه، تایم‌اوت...)

## نقشه راه (زبان‌های بعدی)

C#/.NET، Java، Go، Laravel/Yii2 wrapperهای اختصاصی و Delphi در دستور کار بعدی هستند — این سه SDK (PHP/Node/Python) پرکاربردترین‌ها بودند و اول تحویل داده شدند تا در دسترس تیم توسعه قرار بگیرند.

## لایسنس

MIT — © PersiaFava
