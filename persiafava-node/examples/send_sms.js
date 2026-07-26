const PersiaFavaClient = require('../src/client');
const { ApiException, HttpException } = require('../src/errors');

// روش اول: نام کاربری و رمز عبور
const client = new PersiaFavaClient('USERNAME', 'PASSWORD');

// روش دوم (پیشنهادی): فقط با API Key از پنل
// const client = new PersiaFavaClient('YOUR_API_KEY');

client.send({
  receiver_number: '09123456789',
  sender_number: '3000569999',
  'note_arr[]': 'سلام! این یک پیام آزمایشی از SDK پرشیا فاواست.',
})
  .then((result) => console.log(result))
  .catch((err) => {
    if (err instanceof ApiException) console.error('خطای API:', err.message);
    else if (err instanceof HttpException) console.error('خطای شبکه:', err.message);
    else throw err;
  });
