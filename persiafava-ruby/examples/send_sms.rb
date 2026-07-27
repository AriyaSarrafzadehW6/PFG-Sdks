require_relative '../lib/persiafava/client'

# روش اول: نام کاربری و رمز عبور
client = PersiaFava::Client.new('USERNAME', 'PASSWORD')

# روش دوم (پیشنهادی): فقط با API Key از پنل
# client = PersiaFava::Client.new('YOUR_API_KEY')

begin
  result = client.send(
    receiver_number: '09123456789',
    sender_number: '3000569999',
    note_arr: 'سلام! این یک پیام آزمایشی از SDK پرشیا فاواست.'
  )
  puts result
rescue PersiaFava::ApiException => e
  puts "خطای API: #{e.message}"
rescue PersiaFava::HttpException => e
  puts "خطای شبکه: #{e.message}"
end
