using System;
using System.Threading.Tasks;
using PersiaFava;

class Program
{
    static async Task Main()
    {
        // روش اول: نام کاربری و رمز عبور
        var client = new Client("YOUR_API_KEY");

        try
        {
            var result = await client.SendSmsAsync(new List<string> { "09123456789" }, "3000569999", "سلام! این یک پیام آزمایشی از SDK پرشیا فاواست.");
            Console.WriteLine(result);
        }
        catch (ApiException e) { Console.WriteLine("خطای API: " + e.Message); }
        catch (HttpRequestFailedException e) { Console.WriteLine("خطای شبکه: " + e.Message); }
    }
}
