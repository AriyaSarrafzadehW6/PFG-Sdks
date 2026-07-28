package com.persiafava.sms;

import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.HashMap;
import java.util.stream.Collectors;

/**
 * کلاینت رسمی جاوا برای وب‌سرویس REST پیامک پرشیا فاوا.
 * مستندات کامل: persia_fava_docs.html (بخش وب‌سرویس REST)
 *
 * نکته: به‌جای username/password می‌توانید فقط یک API Key از پنل بسازید
 * و همان را به‌عنوان تنها آرگومان به سازنده‌ی کلاس بدهید.
 */
public class Client {

    private static final String BASE_URL = "https://sms.persiafava.com/webservice/rest/";
    private final HttpClient http = HttpClient.newHttpClient();
    private final String username;
    private final String password;
    private final String apiKey;

    // احراز هویت با API Key
    public Client(String apiKey) {
        this.apiKey = apiKey;
        this.username = null;
        this.password = null;
    }

    // احراز هویت با نام کاربری/رمز عبور (فقط یکی از دو سازنده استفاده شود، نه هر دو باهم)
    public Client(String username, String password) {
        this.username = username;
        this.password = password;
        this.apiKey = null;
    }

    private Map<String, String> authParams() {
        Map<String, String> m = new HashMap<>();
        if (apiKey != null) { m.put("api_key", apiKey); }
        else { m.put("login_username", username); m.put("login_password", password); }
        return m;
    }

    /** روش ساده‌ی ارسال پیامک: لیست گیرندگان، فرستنده و متن پیام (خروجی به‌صورت رشته). */
    public String sendSms(java.util.List<String> recipients, String sender, String message) throws ApiException, HttpRequestException {
        Map<String, String> params = new HashMap<>();
        params.put("receiver_number", String.join(",", recipients));
        params.put("sender_number", sender);
        params.put("note_arr[]", message);
        return request("POST", "sms_send", params).toString();
    }

    @SuppressWarnings("unchecked")
    private Map<String, Object> request(String verb, String endpoint, Map<String, String> params) throws ApiException, HttpRequestException {
        Map<String, String> all = new HashMap<>(authParams());
        params.forEach((k, v) -> { if (v != null) all.put(k, v); });
        String url = BASE_URL + endpoint;

        try {
            HttpRequest request;
            String encoded = all.entrySet().stream()
                    .map(e -> e.getKey() + "=" + URLEncoder.encode(e.getValue(), StandardCharsets.UTF_8))
                    .collect(Collectors.joining("&"));

            if (verb.equals("GET")) {
                request = HttpRequest.newBuilder(URI.create(url + "?" + encoded)).GET().build();
            } else {
                request = HttpRequest.newBuilder(URI.create(url))
                        .header("Content-Type", "application/x-www-form-urlencoded")
                        .POST(HttpRequest.BodyPublishers.ofString(encoded)).build();
            }

            HttpResponse<String> response = http.send(request, HttpResponse.BodyHandlers.ofString());
            com.google.gson.Gson gson = new com.google.gson.Gson();
            Map<String, Object> data = gson.fromJson(response.body(), Map.class);

            if (Boolean.FALSE.equals(data.get("result"))) {
                Object err = data.getOrDefault("error", "unknown_error");
                throw new ApiException(String.valueOf(err));
            }
            return data;
        } catch (java.io.IOException | InterruptedException e) {
            throw new HttpRequestException("خطای ارتباط با سرور: " + e.getMessage());
        }
    }

    /**
     * از این متد برای دریافت اطلاعات کاربری و شماره های اختصاصی و میزان شارژ استفاده می‌شود.
     */
    public java.util.Map<String, Object> userInfo() throws ApiException, HttpRequestException {
        java.util.Map<String, String> params = new java.util.HashMap<>();
        return request("GET", "user_info", params);
    }

    /**
     * از این متد برای ارسال پیامک از طریق معماری رست استفاده می شود. اطلاعات میتوانند توسط متد POST ارسال شوند.
     * @param receiver_number 
     * @param sender_number 
     * @param note_arr 
     * @param date 
     * @param clientids 
     * @param show_faktor 
     */
    public java.util.Map<String, Object> send(String receiver_number, String sender_number, String note_arr, String date, String clientids, String show_faktor) throws ApiException, HttpRequestException {
        java.util.Map<String, String> params = new java.util.HashMap<>();
        if (receiver_number != null) params.put("receiver_number", receiver_number);
        if (sender_number != null) params.put("sender_number", sender_number);
        if (note_arr != null) params.put("note_arr[]", note_arr);
        if (date != null) params.put("date", date);
        if (clientids != null) params.put("clientids", clientids);
        if (show_faktor != null) params.put("show_faktor", show_faktor);
        return request("POST", "sms_send", params);
    }

    /**
     * از این متد برای اطلاع از وضعیت پیامک های ارسال شده استفاده می شود.
     * @param dargah 
     * @param smsid 
     */
    public java.util.Map<String, Object> deliveryStatus(String dargah, String smsid) throws ApiException, HttpRequestException {
        java.util.Map<String, String> params = new java.util.HashMap<>();
        if (dargah != null) params.put("dargah", dargah);
        if (smsid != null) params.put("smsid[]", smsid);
        return request("GET", "sms_deliver", params);
    }

    /**
     * از این متد برای لیست پیامک های دریافتی استفاده می شود.
     * @param read 
     * @param number 
     * @param fromid 
     * @param labelid 
     * @param count 
     */
    public java.util.Map<String, Object> receivedList(String read, String number, String fromid, String labelid, String count) throws ApiException, HttpRequestException {
        java.util.Map<String, String> params = new java.util.HashMap<>();
        if (read != null) params.put("read", read);
        if (number != null) params.put("number", number);
        if (fromid != null) params.put("fromid", fromid);
        if (labelid != null) params.put("labelid", labelid);
        if (count != null) params.put("count", count);
        return request("GET", "sms_receive_list", params);
    }

    /**
     * از این متد برای ایجاد گروه جدید در دفترتلفن استفاده می شود.
     * @param title 
     */
    public java.util.Map<String, Object> phonebookGroupAdd(String title) throws ApiException, HttpRequestException {
        java.util.Map<String, String> params = new java.util.HashMap<>();
        if (title != null) params.put("title", title);
        return request("GET", "user_cat_add", params);
    }

    /**
     * از این متد برای دریافت لیست گروه های دفتر تلفن استفاده می شود.
     * @param page_number 
     * @param perpage 
     */
    public java.util.Map<String, Object> phonebookGroupList(String page_number, String perpage) throws ApiException, HttpRequestException {
        java.util.Map<String, String> params = new java.util.HashMap<>();
        if (page_number != null) params.put("page_number", page_number);
        if (perpage != null) params.put("perpage", perpage);
        return request("GET", "user_cat_list", params);
    }

    /**
     * از این متد برای دریافت مشخصات یک گروه از دفتر تلفن استفاده می شود.
     * @param id 
     */
    public java.util.Map<String, Object> phonebookGroupInfo(String id) throws ApiException, HttpRequestException {
        java.util.Map<String, String> params = new java.util.HashMap<>();
        if (id != null) params.put("id", id);
        return request("GET", "user_cat_info", params);
    }

    /**
     * از این متد برای اضافه کردن شماره ی جدید به دفترتلفن استفاده می شود.
     * @param catid 
     * @param number 
     * @param fullname 
     * @param repeat 
     * @param gender 
     * @param fullname_en 
     * @param blacklist_no_check 
     * @param gender_en 
     */
    public java.util.Map<String, Object> phonebookNumberAdd(String catid, String number, String fullname, String repeat, String gender, String fullname_en, String blacklist_no_check, String gender_en) throws ApiException, HttpRequestException {
        java.util.Map<String, String> params = new java.util.HashMap<>();
        if (catid != null) params.put("catid", catid);
        if (number != null) params.put("number", number);
        if (fullname != null) params.put("fullname", fullname);
        if (repeat != null) params.put("repeat", repeat);
        if (gender != null) params.put("gender", gender);
        if (fullname_en != null) params.put("fullname_en", fullname_en);
        if (blacklist_no_check != null) params.put("blacklist_no_check", blacklist_no_check);
        if (gender_en != null) params.put("gender_en", gender_en);
        return request("GET", "sms_number_add", params);
    }

    /**
     * از این متد برای دریافت لیست شماره های دفتر تلفن استفاده می شود.
     * @param catid 
     */
    public java.util.Map<String, Object> phonebookNumberList(String catid) throws ApiException, HttpRequestException {
        java.util.Map<String, String> params = new java.util.HashMap<>();
        if (catid != null) params.put("catid", catid);
        return request("GET", "sms_number_list", params);
    }

    /**
     * از این متد برای به روز کردن تعداد شماره های گروه های دفتر تلفن استفاده می شود.
     * @param catid 
     */
    public java.util.Map<String, Object> phonebookNumberUpdate(String catid) throws ApiException, HttpRequestException {
        java.util.Map<String, String> params = new java.util.HashMap<>();
        if (catid != null) params.put("catid", catid);
        return request("GET", "sms_number_update", params);
    }

    /**
     * از این متد برای تغییر وضعیت خوانده شدن پیام های دریافتی استفاده می شود.
     * @param id 
     * @param read 
     */
    public java.util.Map<String, Object> receivedMarkAsRead(String id, String read) throws ApiException, HttpRequestException {
        java.util.Map<String, String> params = new java.util.HashMap<>();
        if (id != null) params.put("id[]", id);
        if (read != null) params.put("read", read);
        return request("GET", "sms_receive_change_read", params);
    }

    /**
     * از این متد برای دریافت لیست کلمات کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود.
     * @param kind 
     */
    public java.util.Map<String, Object> labelList(String kind) throws ApiException, HttpRequestException {
        java.util.Map<String, String> params = new java.util.HashMap<>();
        if (kind != null) params.put("kind", kind);
        return request("GET", "label_list", params);
    }

    /**
     * از این متد برای ایجاد کلمه کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود.
     * @param title 
     * @param label 
     * @param note 
     * @param time_limit 
     * @param date_start 
     * @param date_end 
     * @param catid 
     * @param reply 
     */
    public java.util.Map<String, Object> labelAdd(String title, String label, String note, String time_limit, String date_start, String date_end, String catid, String reply) throws ApiException, HttpRequestException {
        java.util.Map<String, String> params = new java.util.HashMap<>();
        if (title != null) params.put("title", title);
        if (label != null) params.put("label", label);
        if (note != null) params.put("note", note);
        if (time_limit != null) params.put("time_limit", time_limit);
        if (date_start != null) params.put("date_start", date_start);
        if (date_end != null) params.put("date_end", date_end);
        if (catid != null) params.put("catid", catid);
        if (reply != null) params.put("reply", reply);
        return request("GET", "label_new", params);
    }

    /**
     * از این متد برای ویرایش کلمات کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود.
     * @param id 
     * @param title 
     * @param note 
     */
    public java.util.Map<String, Object> labelEdit(String id, String title, String note) throws ApiException, HttpRequestException {
        java.util.Map<String, String> params = new java.util.HashMap<>();
        if (id != null) params.put("id", id);
        if (title != null) params.put("title", title);
        if (note != null) params.put("note", note);
        return request("GET", "label_edit", params);
    }

    /**
     * از این متد برای حذف کلمه ی کلیدی استفاده می شود.
     * @param id 
     */
    public java.util.Map<String, Object> labelDelete(String id) throws ApiException, HttpRequestException {
        java.util.Map<String, String> params = new java.util.HashMap<>();
        if (id != null) params.put("id", id);
        return request("GET", "label_remove", params);
    }

    /**
     * از این متد برای ایجاد لینک ورود مدت دار یک بار مصرف استفاده می شود.
     * @param expire 
     */
    public java.util.Map<String, Object> onceLoginLink(String expire) throws ApiException, HttpRequestException {
        java.util.Map<String, String> params = new java.util.HashMap<>();
        if (expire != null) params.put("expire", expire);
        return request("GET", "user_once_login", params);
    }
}
