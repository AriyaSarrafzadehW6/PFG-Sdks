import com.persiafava.sms.Client;
import com.persiafava.sms.ApiException;
import com.persiafava.sms.HttpRequestException;

public class SendSms {
    public static void main(String[] args) {
        // روش اول: نام کاربری و رمز عبور
        Client client = new Client("YOUR_API_KEY");

        try {
            var result = client.sendSms(java.util.List.of("09123456789"), "3000569999", "سلام! این یک پیام آزمایشی از SDK پرشیا فاواست.");
            System.out.println(result);
        } catch (ApiException e) {
            System.out.println("خطای API: " + e.getMessage());
        } catch (HttpRequestException e) {
            System.out.println("خطای شبکه: " + e.getMessage());
        }
    }
}
