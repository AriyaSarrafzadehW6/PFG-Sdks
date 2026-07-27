// Package persiafava کلاینت رسمی Go برای وب‌سرویس REST پیامک پرشیا فاوا.
// مستندات کامل: persia_fava_docs.html (بخش وب‌سرویس REST)
//
// نکته: به‌جای Username/Password می‌توانید فقط یک API Key از پنل بسازید
// و همان را با NewClientWithApiKey استفاده کنید.
package persiafava

import (
	"encoding/json"
	"io"
	"net/http"
	"net/url"
	"strings"
	"time"
)

const baseURL = "https://sms.persiafava.com/webservice/rest/"

// ApiException یعنی سرور پاسخ داد اما نتیجه (result) درخواست false بود.
type ApiException struct{ Message string }

func (e *ApiException) Error() string { return e.Message }

// HttpRequestException یعنی اصلاً امکان برقراری ارتباط با سرور وجود نداشت.
type HttpRequestException struct{ Message string }

func (e *HttpRequestException) Error() string { return e.Message }

type Client struct {
	username string
	password string
	apiKey   string
	http     *http.Client
}

// NewClient یک کلاینت با نام کاربری و رمز عبور می‌سازد.
func NewClient(username, password string) *Client {
	return &Client{username: username, password: password, http: &http.Client{Timeout: 20 * time.Second}}
}

// NewClientWithApiKey یک کلاینت با API Key می‌سازد (روش پیشنهادی).
func NewClientWithApiKey(apiKey string) *Client {
	return &Client{apiKey: apiKey, http: &http.Client{Timeout: 20 * time.Second}}
}

func (c *Client) authParams() map[string]string {
	if c.apiKey != "" {
		return map[string]string{"api_key": c.apiKey}
	}
	return map[string]string{"login_username": c.username, "login_password": c.password}
}

func (c *Client) request(verb, endpoint string, params map[string]string) (map[string]interface{}, error) {
	all := c.authParams()
	for k, v := range params {
		if v != "" {
			all[k] = v
		}
	}
	values := url.Values{}
	for k, v := range all {
		values.Set(k, v)
	}

	var resp *http.Response
	var err error
	if verb == "GET" {
		resp, err = c.http.Get(baseURL + endpoint + "?" + values.Encode())
	} else {
		resp, err = c.http.Post(baseURL+endpoint, "application/x-www-form-urlencoded", strings.NewReader(values.Encode()))
	}
	if err != nil {
		return nil, &HttpRequestException{Message: "خطای ارتباط با سرور: " + err.Error()}
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, &HttpRequestException{Message: "خطا در خواندن پاسخ سرور: " + err.Error()}
	}

	var data map[string]interface{}
	if err := json.Unmarshal(body, &data); err != nil {
		return nil, &HttpRequestException{Message: "پاسخ سرور JSON معتبر نبود"}
	}

	if result, ok := data["result"]; ok {
		if b, ok := result.(bool); ok && !b {
			msg := "unknown_error"
			if e, ok := data["error"].(string); ok {
				msg = e
			}
			return nil, &ApiException{Message: msg}
		}
	}
	return data, nil
}

// از این متد برای دریافت اطلاعات کاربری و شماره های اختصاصی و میزان شارژ استفاده می‌شود.
func (c *Client) UserInfo() (map[string]interface{}, error) {
	params := map[string]string{}
	return c.request("GET", "user_info", params)
}

// از این متد برای ارسال پیامک از طریق معماری رست استفاده می شود. اطلاعات میتوانند توسط متد POST ارسال شوند.
func (c *Client) Send(receiver_number string, sender_number string, note_arr string, date string, clientids string, show_faktor string) (map[string]interface{}, error) {
	params := map[string]string{}
	if receiver_number != "" {
		params["receiver_number"] = receiver_number
	}
	if sender_number != "" {
		params["sender_number"] = sender_number
	}
	if note_arr != "" {
		params["note_arr[]"] = note_arr
	}
	if date != "" {
		params["date"] = date
	}
	if clientids != "" {
		params["clientids"] = clientids
	}
	if show_faktor != "" {
		params["show_faktor"] = show_faktor
	}
	return c.request("POST", "sms_send", params)
}

// از این متد برای اطلاع از وضعیت پیامک های ارسال شده استفاده می شود.
func (c *Client) DeliveryStatus(dargah string, smsid string) (map[string]interface{}, error) {
	params := map[string]string{}
	if dargah != "" {
		params["dargah"] = dargah
	}
	if smsid != "" {
		params["smsid[]"] = smsid
	}
	return c.request("GET", "sms_deliver", params)
}

// از این متد برای لیست پیامک های دریافتی استفاده می شود.
func (c *Client) ReceivedList(read string, number string, fromid string, labelid string, count string) (map[string]interface{}, error) {
	params := map[string]string{}
	if read != "" {
		params["read"] = read
	}
	if number != "" {
		params["number"] = number
	}
	if fromid != "" {
		params["fromid"] = fromid
	}
	if labelid != "" {
		params["labelid"] = labelid
	}
	if count != "" {
		params["count"] = count
	}
	return c.request("GET", "sms_receive_list", params)
}

// از این متد برای ایجاد گروه جدید در دفترتلفن استفاده می شود.
func (c *Client) PhonebookGroupAdd(title string) (map[string]interface{}, error) {
	params := map[string]string{}
	if title != "" {
		params["title"] = title
	}
	return c.request("GET", "user_cat_add", params)
}

// از این متد برای دریافت لیست گروه های دفتر تلفن استفاده می شود.
func (c *Client) PhonebookGroupList(page_number string, perpage string) (map[string]interface{}, error) {
	params := map[string]string{}
	if page_number != "" {
		params["page_number"] = page_number
	}
	if perpage != "" {
		params["perpage"] = perpage
	}
	return c.request("GET", "user_cat_list", params)
}

// از این متد برای دریافت مشخصات یک گروه از دفتر تلفن استفاده می شود.
func (c *Client) PhonebookGroupInfo(id string) (map[string]interface{}, error) {
	params := map[string]string{}
	if id != "" {
		params["id"] = id
	}
	return c.request("GET", "user_cat_info", params)
}

// از این متد برای اضافه کردن شماره ی جدید به دفترتلفن استفاده می شود.
func (c *Client) PhonebookNumberAdd(catid string, number string, fullname string, repeat string, gender string, fullname_en string, blacklist_no_check string, gender_en string) (map[string]interface{}, error) {
	params := map[string]string{}
	if catid != "" {
		params["catid"] = catid
	}
	if number != "" {
		params["number"] = number
	}
	if fullname != "" {
		params["fullname"] = fullname
	}
	if repeat != "" {
		params["repeat"] = repeat
	}
	if gender != "" {
		params["gender"] = gender
	}
	if fullname_en != "" {
		params["fullname_en"] = fullname_en
	}
	if blacklist_no_check != "" {
		params["blacklist_no_check"] = blacklist_no_check
	}
	if gender_en != "" {
		params["gender_en"] = gender_en
	}
	return c.request("GET", "sms_number_add", params)
}

// از این متد برای دریافت لیست شماره های دفتر تلفن استفاده می شود.
func (c *Client) PhonebookNumberList(catid string) (map[string]interface{}, error) {
	params := map[string]string{}
	if catid != "" {
		params["catid"] = catid
	}
	return c.request("GET", "sms_number_list", params)
}

// از این متد برای به روز کردن تعداد شماره های گروه های دفتر تلفن استفاده می شود.
func (c *Client) PhonebookNumberUpdate(catid string) (map[string]interface{}, error) {
	params := map[string]string{}
	if catid != "" {
		params["catid"] = catid
	}
	return c.request("GET", "sms_number_update", params)
}

// از این متد برای تغییر وضعیت خوانده شدن پیام های دریافتی استفاده می شود.
func (c *Client) ReceivedMarkAsRead(id string, read string) (map[string]interface{}, error) {
	params := map[string]string{}
	if id != "" {
		params["id[]"] = id
	}
	if read != "" {
		params["read"] = read
	}
	return c.request("GET", "sms_receive_change_read", params)
}

// از این متد برای دریافت لیست کلمات کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود.
func (c *Client) LabelList(kind string) (map[string]interface{}, error) {
	params := map[string]string{}
	if kind != "" {
		params["kind"] = kind
	}
	return c.request("GET", "label_list", params)
}

// از این متد برای ایجاد کلمه کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود.
func (c *Client) LabelAdd(title string, label string, note string, time_limit string, date_start string, date_end string, catid string, reply string) (map[string]interface{}, error) {
	params := map[string]string{}
	if title != "" {
		params["title"] = title
	}
	if label != "" {
		params["label"] = label
	}
	if note != "" {
		params["note"] = note
	}
	if time_limit != "" {
		params["time_limit"] = time_limit
	}
	if date_start != "" {
		params["date_start"] = date_start
	}
	if date_end != "" {
		params["date_end"] = date_end
	}
	if catid != "" {
		params["catid"] = catid
	}
	if reply != "" {
		params["reply"] = reply
	}
	return c.request("GET", "label_new", params)
}

// از این متد برای ویرایش کلمات کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود.
func (c *Client) LabelEdit(id string, title string, note string) (map[string]interface{}, error) {
	params := map[string]string{}
	if id != "" {
		params["id"] = id
	}
	if title != "" {
		params["title"] = title
	}
	if note != "" {
		params["note"] = note
	}
	return c.request("GET", "label_edit", params)
}

// از این متد برای حذف کلمه ی کلیدی استفاده می شود.
func (c *Client) LabelDelete(id string) (map[string]interface{}, error) {
	params := map[string]string{}
	if id != "" {
		params["id"] = id
	}
	return c.request("GET", "label_remove", params)
}

// از این متد برای ایجاد لینک ورود مدت دار یک بار مصرف استفاده می شود.
func (c *Client) OnceLoginLink(expire string) (map[string]interface{}, error) {
	params := map[string]string{}
	if expire != "" {
		params["expire"] = expire
	}
	return c.request("GET", "user_once_login", params)
}
