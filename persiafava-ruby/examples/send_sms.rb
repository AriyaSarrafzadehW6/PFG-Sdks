require_relative '../lib/persiafava/client'

# روش اول: نام کاربری و رمز عبور
client = PersiaFava::Client.new('YOUR_API_KEY')

begin
  result = client.send_sms(
    to: ['09123456789'],
    sender: '3000569999',
    text: 'سلام! این یک پیام آزمایشی از SDK پرشیا فاواست.'
  )
  puts result
rescue PersiaFava::ApiException => e
  puts "خطای API: #{e.message}"
rescue PersiaFava::HttpException => e
  puts "خطای شبکه: #{e.message}"
end
