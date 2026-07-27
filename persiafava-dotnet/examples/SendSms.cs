using System;
using System.Threading.Tasks;
using PersiaFava;

class Program
{
    static async Task Main()
    {
        // روش اول: نام کاربری و رمز عبور
        var client = new Client("USERNAME", "PASSWORD");

        // روش دوم (پیشنهادی): فقط با API Key از پنل
        // var client = new Client("YOUR_API_KEY");

        try
        {
            var result = await client.Send(
                receiver_number: "09123456789",
                sender_number: "3000569999",
                note_arr: "سلام! این یک پیام آزمایشی از SDK پرشیا فاواست."
            );
            Console.WriteLine(result);
        }
        catch (ApiException e) { Console.WriteLine("خطای API: " + e.Message); }
        catch (HttpRequestFailedException e) { Console.WriteLine("خطای شبکه: " + e.Message); }
    }
}
