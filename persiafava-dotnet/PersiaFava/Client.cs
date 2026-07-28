using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Text.Json;
using System.Threading.Tasks;

namespace PersiaFava
{
    /// <summary>
    /// کلاینت رسمی C#/.NET برای وب‌سرویس REST پیامک پرشیا فاوا.
    /// مستندات کامل: persia_fava_docs.html (بخش وب‌سرویس REST)
    ///
    /// نکته: به‌جای username/password می‌توانید فقط یک API Key از پنل بسازید
    /// و همان را به‌عنوان تنها آرگومان به سازنده‌ی کلاس بدهید.
    /// </summary>
    public class Client
    {
        private const string BaseUrl = "https://sms.persiafava.com/webservice/rest/";
        private static readonly HttpClient Http = new HttpClient();

        private readonly string _username;
        private readonly string _password;
        private readonly string _apiKey;

        // دو روش احراز هویت (فقط یکی، نه هر دو باهم): new Client(user, pass) یا new Client(apiKey)
        public Client(string usernameOrApiKey, string password = null)
        {
            if (password == null) { _apiKey = usernameOrApiKey; }
            else { _username = usernameOrApiKey; _password = password; }
        }

        private Dictionary<string, string> AuthParams()
        {
            if (_apiKey != null) return new Dictionary<string, string> { ["api_key"] = _apiKey };
            return new Dictionary<string, string> { ["login_username"] = _username, ["login_password"] = _password };
        }

        /// <summary>روش ساده‌ی ارسال پیامک: لیست گیرندگان، فرستنده و متن پیام.</summary>
        public async Task<Dictionary<string, object>> SendSmsAsync(List<string> recipients, string sender, string message)
        {
            var parameters = new Dictionary<string, string>
            {
                ["receiver_number"] = string.Join(",", recipients),
                ["sender_number"] = sender,
                ["note_arr[]"] = message,
            };
            return await RequestAsync("POST", "sms_send", parameters);
        }

        private async Task<Dictionary<string, object>> RequestAsync(string verb, string endpoint, Dictionary<string, string> parameters)
        {
            foreach (var kv in AuthParams()) parameters[kv.Key] = kv.Value;
            var url = BaseUrl + endpoint;

            HttpResponseMessage response;
            try
            {
                if (verb == "GET")
                {
                    var parts = new List<string>();
                    foreach (var kv in parameters) parts.Add($"{kv.Key}={Uri.EscapeDataString(kv.Value)}");
                    var qs = string.Join("&", parts);
                    response = await Http.GetAsync($"{url}?{qs}");
                }
                else
                {
                    response = await Http.PostAsync(url, new FormUrlEncodedContent(parameters));
                }
            }
            catch (Exception e)
            {
                throw new HttpRequestFailedException("خطای ارتباط با سرور: " + e.Message);
            }

            var json = await response.Content.ReadAsStringAsync();
            Dictionary<string, object> data;
            try
            {
                data = JsonSerializer.Deserialize<Dictionary<string, object>>(json);
            }
            catch (JsonException)
            {
                throw new HttpRequestFailedException("پاسخ سرور JSON معتبر نبود: " + json.Substring(0, Math.Min(200, json.Length)));
            }

            if (data.TryGetValue("result", out var resultVal) && resultVal is JsonElement je && je.ValueKind == JsonValueKind.False)
            {
                var msg = data.TryGetValue("error", out var e2) ? e2.ToString() : "unknown_error";
                throw new ApiException(msg);
            }
            return data;
        }

        /// <summary>از این متد برای دریافت اطلاعات کاربری و شماره های اختصاصی و میزان شارژ استفاده می‌شود.</summary>
        public async Task<Dictionary<string, object>> UserInfo()
        {
            var parameters = new Dictionary<string, string>();
            return await RequestAsync("GET", "user_info", parameters);
        }

        /// <summary>از این متد برای ارسال پیامک از طریق معماری رست استفاده می شود. اطلاعات میتوانند توسط متد POST ارسال شوند.</summary>
        public async Task<Dictionary<string, object>> Send(string receiver_number = null, string sender_number = null, string note_arr = null, string date = null, string clientids = null, string show_faktor = null)
        {
            var parameters = new Dictionary<string, string>();
            if (receiver_number != null) parameters["receiver_number"] = receiver_number;
            if (sender_number != null) parameters["sender_number"] = sender_number;
            if (note_arr != null) parameters["note_arr[]"] = note_arr;
            if (date != null) parameters["date"] = date;
            if (clientids != null) parameters["clientids"] = clientids;
            if (show_faktor != null) parameters["show_faktor"] = show_faktor;
            return await RequestAsync("POST", "sms_send", parameters);
        }

        /// <summary>از این متد برای اطلاع از وضعیت پیامک های ارسال شده استفاده می شود.</summary>
        public async Task<Dictionary<string, object>> DeliveryStatus(string dargah = null, string smsid = null)
        {
            var parameters = new Dictionary<string, string>();
            if (dargah != null) parameters["dargah"] = dargah;
            if (smsid != null) parameters["smsid[]"] = smsid;
            return await RequestAsync("GET", "sms_deliver", parameters);
        }

        /// <summary>از این متد برای لیست پیامک های دریافتی استفاده می شود.</summary>
        public async Task<Dictionary<string, object>> ReceivedList(string read = null, string number = null, string fromid = null, string labelid = null, string count = null)
        {
            var parameters = new Dictionary<string, string>();
            if (read != null) parameters["read"] = read;
            if (number != null) parameters["number"] = number;
            if (fromid != null) parameters["fromid"] = fromid;
            if (labelid != null) parameters["labelid"] = labelid;
            if (count != null) parameters["count"] = count;
            return await RequestAsync("GET", "sms_receive_list", parameters);
        }

        /// <summary>از این متد برای ایجاد گروه جدید در دفترتلفن استفاده می شود.</summary>
        public async Task<Dictionary<string, object>> PhonebookGroupAdd(string title = null)
        {
            var parameters = new Dictionary<string, string>();
            if (title != null) parameters["title"] = title;
            return await RequestAsync("GET", "user_cat_add", parameters);
        }

        /// <summary>از این متد برای دریافت لیست گروه های دفتر تلفن استفاده می شود.</summary>
        public async Task<Dictionary<string, object>> PhonebookGroupList(string page_number = null, string perpage = null)
        {
            var parameters = new Dictionary<string, string>();
            if (page_number != null) parameters["page_number"] = page_number;
            if (perpage != null) parameters["perpage"] = perpage;
            return await RequestAsync("GET", "user_cat_list", parameters);
        }

        /// <summary>از این متد برای دریافت مشخصات یک گروه از دفتر تلفن استفاده می شود.</summary>
        public async Task<Dictionary<string, object>> PhonebookGroupInfo(string id = null)
        {
            var parameters = new Dictionary<string, string>();
            if (id != null) parameters["id"] = id;
            return await RequestAsync("GET", "user_cat_info", parameters);
        }

        /// <summary>از این متد برای اضافه کردن شماره ی جدید به دفترتلفن استفاده می شود.</summary>
        public async Task<Dictionary<string, object>> PhonebookNumberAdd(string catid = null, string number = null, string fullname = null, string repeat = null, string gender = null, string fullname_en = null, string blacklist_no_check = null, string gender_en = null)
        {
            var parameters = new Dictionary<string, string>();
            if (catid != null) parameters["catid"] = catid;
            if (number != null) parameters["number"] = number;
            if (fullname != null) parameters["fullname"] = fullname;
            if (repeat != null) parameters["repeat"] = repeat;
            if (gender != null) parameters["gender"] = gender;
            if (fullname_en != null) parameters["fullname_en"] = fullname_en;
            if (blacklist_no_check != null) parameters["blacklist_no_check"] = blacklist_no_check;
            if (gender_en != null) parameters["gender_en"] = gender_en;
            return await RequestAsync("GET", "sms_number_add", parameters);
        }

        /// <summary>از این متد برای دریافت لیست شماره های دفتر تلفن استفاده می شود.</summary>
        public async Task<Dictionary<string, object>> PhonebookNumberList(string catid = null)
        {
            var parameters = new Dictionary<string, string>();
            if (catid != null) parameters["catid"] = catid;
            return await RequestAsync("GET", "sms_number_list", parameters);
        }

        /// <summary>از این متد برای به روز کردن تعداد شماره های گروه های دفتر تلفن استفاده می شود.</summary>
        public async Task<Dictionary<string, object>> PhonebookNumberUpdate(string catid = null)
        {
            var parameters = new Dictionary<string, string>();
            if (catid != null) parameters["catid"] = catid;
            return await RequestAsync("GET", "sms_number_update", parameters);
        }

        /// <summary>از این متد برای تغییر وضعیت خوانده شدن پیام های دریافتی استفاده می شود.</summary>
        public async Task<Dictionary<string, object>> ReceivedMarkAsRead(string id = null, string read = null)
        {
            var parameters = new Dictionary<string, string>();
            if (id != null) parameters["id[]"] = id;
            if (read != null) parameters["read"] = read;
            return await RequestAsync("GET", "sms_receive_change_read", parameters);
        }

        /// <summary>از این متد برای دریافت لیست کلمات کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود.</summary>
        public async Task<Dictionary<string, object>> LabelList(string kind = null)
        {
            var parameters = new Dictionary<string, string>();
            if (kind != null) parameters["kind"] = kind;
            return await RequestAsync("GET", "label_list", parameters);
        }

        /// <summary>از این متد برای ایجاد کلمه کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود.</summary>
        public async Task<Dictionary<string, object>> LabelAdd(string title = null, string label = null, string note = null, string time_limit = null, string date_start = null, string date_end = null, string catid = null, string reply = null)
        {
            var parameters = new Dictionary<string, string>();
            if (title != null) parameters["title"] = title;
            if (label != null) parameters["label"] = label;
            if (note != null) parameters["note"] = note;
            if (time_limit != null) parameters["time_limit"] = time_limit;
            if (date_start != null) parameters["date_start"] = date_start;
            if (date_end != null) parameters["date_end"] = date_end;
            if (catid != null) parameters["catid"] = catid;
            if (reply != null) parameters["reply"] = reply;
            return await RequestAsync("GET", "label_new", parameters);
        }

        /// <summary>از این متد برای ویرایش کلمات کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود.</summary>
        public async Task<Dictionary<string, object>> LabelEdit(string id = null, string title = null, string note = null)
        {
            var parameters = new Dictionary<string, string>();
            if (id != null) parameters["id"] = id;
            if (title != null) parameters["title"] = title;
            if (note != null) parameters["note"] = note;
            return await RequestAsync("GET", "label_edit", parameters);
        }

        /// <summary>از این متد برای حذف کلمه ی کلیدی استفاده می شود.</summary>
        public async Task<Dictionary<string, object>> LabelDelete(string id = null)
        {
            var parameters = new Dictionary<string, string>();
            if (id != null) parameters["id"] = id;
            return await RequestAsync("GET", "label_remove", parameters);
        }

        /// <summary>از این متد برای ایجاد لینک ورود مدت دار یک بار مصرف استفاده می شود.</summary>
        public async Task<Dictionary<string, object>> OnceLoginLink(string expire = null)
        {
            var parameters = new Dictionary<string, string>();
            if (expire != null) parameters["expire"] = expire;
            return await RequestAsync("GET", "user_once_login", parameters);
        }
    }
}
