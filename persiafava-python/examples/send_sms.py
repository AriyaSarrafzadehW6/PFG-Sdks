from persiafava import Client, ApiException, HttpException

# روش اول: نام کاربری و رمز عبور
client = Client('USERNAME', 'PASSWORD')

# روش دوم (پیشنهادی): فقط با API Key از پنل
# client = Client('YOUR_API_KEY')

try:
    result = client.send(
        receiver_number='09123456789',
        sender_number='3000569999',
        note_arr='سلام! این یک پیام آزمایشی از SDK پرشیا فاواست.',
    )
    print(result)
except ApiException as e:
    print('خطای API:', e)
except HttpException as e:
    print('خطای شبکه:', e)
