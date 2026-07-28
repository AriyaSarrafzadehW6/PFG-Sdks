const PersiaFavaClient = require('../src/client');
const { ApiException, HttpException } = require('../src/errors');

// روش اول: نام کاربری و رمز عبور
const client = new PersiaFavaClient('YOUR_API_KEY');

client.sendSms(['09123456789'], '3000569999', 'سلام! این یک پیام آزمایشی از SDK پرشیا فاواست.')
  .then((result) => console.log(result))
  .catch((err) => {
    if (err instanceof ApiException) console.error('خطای API:', err.message);
    else if (err instanceof HttpException) console.error('خطای شبکه:', err.message);
    else throw err;
  });
