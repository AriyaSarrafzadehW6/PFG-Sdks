from persiafava import Client, ApiException, HttpException

# روش اول: نام کاربری و رمز عبور
client = Client('YOUR_API_KEY')

try:
    result = client.send_sms(
        to=['09123456789'],
        sender='3000569999',
        text='سلام! این یک پیام آزمایشی از SDK پرشیا فاواست.',
    )
    print(result)
except ApiException as e:
    print('خطای API:', e)
except HttpException as e:
    print('خطای شبکه:', e)
