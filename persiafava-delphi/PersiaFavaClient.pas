unit PersiaFavaClient;

{
  کلاینت رسمی Delphi برای وب‌سرویس REST پیامک پرشیا فاوا.
  مستندات کامل: persia_fava_docs.html (بخش وب‌سرویس REST)

  نکته: به‌جای Username/Password می‌توانید فقط یک API Key از پنل بسازید
  و همان را به‌عنوان تنها آرگومان به Create بدهید (پارامتر دوم را خالی بگذارید).

  وابستگی: IdHTTP، IdSSLOpenSSL (از پکیج Indy که همراه Delphi نصب است)
}

interface

uses
  System.SysUtils, System.Classes, IdHTTP, IdSSLOpenSSL, System.JSON;

type
  EPersiaFavaApiException = class(Exception);
  EPersiaFavaHttpException = class(Exception);

  TPersiaFavaClient = class
  private
    FUsername, FPassword, FApiKey: string;
    FHttp: TIdHTTP;
    FSSL: TIdSSLIOHandlerSocketOpenSSL;
    function AuthParams: TStringList;
    function DoRequest(const Verb, Endpoint: string; Params: TStringList): TStringList;
  public
    constructor Create(const AUsernameOrApiKey: string; const APassword: string = '');
    destructor Destroy; override;
    // از این متد برای دریافت اطلاعات کاربری و شماره های اختصاصی و میزان شارژ استفاده می‌شود.
    function UserInfo: TStringList;
    // از این متد برای ارسال پیامک از طریق معماری رست استفاده می شود. اطلاعات میتوانند توسط متد POST ارسال شوند.
    function Send(receiver_number: string = ''; sender_number: string = ''; note_arr: string = ''; date: string = ''; clientids: string = ''; show_faktor: string = ''): TStringList;
    // از این متد برای اطلاع از وضعیت پیامک های ارسال شده استفاده می شود.
    function DeliveryStatus(dargah: string = ''; smsid: string = ''): TStringList;
    // از این متد برای لیست پیامک های دریافتی استفاده می شود.
    function ReceivedList(read: string = ''; number: string = ''; fromid: string = ''; labelid: string = ''; count: string = ''): TStringList;
    // از این متد برای ایجاد گروه جدید در دفترتلفن استفاده می شود.
    function PhonebookGroupAdd(title: string = ''): TStringList;
    // از این متد برای دریافت لیست گروه های دفتر تلفن استفاده می شود.
    function PhonebookGroupList(page_number: string = ''; perpage: string = ''): TStringList;
    // از این متد برای دریافت مشخصات یک گروه از دفتر تلفن استفاده می شود.
    function PhonebookGroupInfo(id: string = ''): TStringList;
    // از این متد برای اضافه کردن شماره ی جدید به دفترتلفن استفاده می شود.
    function PhonebookNumberAdd(catid: string = ''; number: string = ''; fullname: string = ''; repeat: string = ''; gender: string = ''; fullname_en: string = ''; blacklist_no_check: string = ''; gender_en: string = ''): TStringList;
    // از این متد برای دریافت لیست شماره های دفتر تلفن استفاده می شود.
    function PhonebookNumberList(catid: string = ''): TStringList;
    // از این متد برای به روز کردن تعداد شماره های گروه های دفتر تلفن استفاده می شود.
    function PhonebookNumberUpdate(catid: string = ''): TStringList;
    // از این متد برای تغییر وضعیت خوانده شدن پیام های دریافتی استفاده می شود.
    function ReceivedMarkAsRead(id: string = ''; read: string = ''): TStringList;
    // از این متد برای دریافت لیست کلمات کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود.
    function LabelList(kind: string = ''): TStringList;
    // از این متد برای ایجاد کلمه کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود.
    function LabelAdd(title: string = ''; label: string = ''; note: string = ''; time_limit: string = ''; date_start: string = ''; date_end: string = ''; catid: string = ''; reply: string = ''): TStringList;
    // از این متد برای ویرایش کلمات کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود.
    function LabelEdit(id: string = ''; title: string = ''; note: string = ''): TStringList;
    // از این متد برای حذف کلمه ی کلیدی استفاده می شود.
    function LabelDelete(id: string = ''): TStringList;
    // از این متد برای ایجاد لینک ورود مدت دار یک بار مصرف استفاده می شود.
    function OnceLoginLink(expire: string = ''): TStringList;
  end;

implementation

const
  BASE_URL = 'https://sms.persiafava.com/webservice/rest/';

constructor TPersiaFavaClient.Create(const AUsernameOrApiKey: string; const APassword: string);
begin
  inherited Create;
  if APassword = '' then
    FApiKey := AUsernameOrApiKey
  else
  begin
    FUsername := AUsernameOrApiKey;
    FPassword := APassword;
  end;
  FHttp := TIdHTTP.Create(nil);
  FSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  FHttp.IOHandler := FSSL;
end;

destructor TPersiaFavaClient.Destroy;
begin
  FHttp.Free;
  FSSL.Free;
  inherited Destroy;
end;

function TPersiaFavaClient.AuthParams: TStringList;
begin
  Result := TStringList.Create;
  if FApiKey <> '' then
    Result.Values['api_key'] := FApiKey
  else
  begin
    Result.Values['login_username'] := FUsername;
    Result.Values['login_password'] := FPassword;
  end;
end;

function TPersiaFavaClient.DoRequest(const Verb, Endpoint: string; Params: TStringList): TStringList;
var
  Auth: TStringList;
  I: Integer;
  URL, ResponseStr: string;
  JsonValue: TJSONValue;
  JsonObj: TJSONObject;
  ResultField: TJSONValue;
begin
  Auth := AuthParams;
  try
    for I := 0 to Auth.Count - 1 do
      Params.Add(Auth[I]);

    URL := BASE_URL + Endpoint;
    try
      if Verb = 'GET' then
        ResponseStr := FHttp.Get(URL + '?' + Params.DelimitedText.Replace(',', '&'))
      else
        ResponseStr := FHttp.Post(URL, Params);
    except
      on E: Exception do
        raise EPersiaFavaHttpException.Create('خطای ارتباط با سرور: ' + E.Message);
    end;

    JsonValue := TJSONObject.ParseJSONValue(ResponseStr);
    try
      if not (JsonValue is TJSONObject) then
        raise EPersiaFavaHttpException.Create('پاسخ سرور JSON معتبر نبود: ' + Copy(ResponseStr, 1, 200));

      JsonObj := TJSONObject(JsonValue);
      if JsonObj.TryGetValue<TJSONValue>('result', ResultField) then
        if (ResultField is TJSONBool) and not TJSONBool(ResultField).AsBoolean then
          raise EPersiaFavaApiException.Create(JsonObj.GetValue<string>('error', 'unknown_error'));

      Result := TStringList.Create;
      Result.Text := JsonObj.ToJSON;
    finally
      JsonValue.Free;
    end;
  finally
    Auth.Free;
  end;
end;

function TPersiaFavaClient.UserInfo(): TStringList;
var
  Params: TStringList;
begin
      Params := TStringList.Create;
  try
    Result := DoRequest('GET', 'user_info', Params);
  finally
    Params.Free;
  end;
end;

function TPersiaFavaClient.Send(receiver_number: string = ''; sender_number: string = ''; note_arr: string = ''; date: string = ''; clientids: string = ''; show_faktor: string = ''): TStringList;
var
  Params: TStringList;
begin
      Params := TStringList.Create;
      if receiver_number <> '' then Params.Values['receiver_number'] := receiver_number;
      if sender_number <> '' then Params.Values['sender_number'] := sender_number;
      if note_arr <> '' then Params.Values['note_arr[]'] := note_arr;
      if date <> '' then Params.Values['date'] := date;
      if clientids <> '' then Params.Values['clientids'] := clientids;
      if show_faktor <> '' then Params.Values['show_faktor'] := show_faktor;
  try
    Result := DoRequest('POST', 'sms_send', Params);
  finally
    Params.Free;
  end;
end;

function TPersiaFavaClient.DeliveryStatus(dargah: string = ''; smsid: string = ''): TStringList;
var
  Params: TStringList;
begin
      Params := TStringList.Create;
      if dargah <> '' then Params.Values['dargah'] := dargah;
      if smsid <> '' then Params.Values['smsid[]'] := smsid;
  try
    Result := DoRequest('GET', 'sms_deliver', Params);
  finally
    Params.Free;
  end;
end;

function TPersiaFavaClient.ReceivedList(read: string = ''; number: string = ''; fromid: string = ''; labelid: string = ''; count: string = ''): TStringList;
var
  Params: TStringList;
begin
      Params := TStringList.Create;
      if read <> '' then Params.Values['read'] := read;
      if number <> '' then Params.Values['number'] := number;
      if fromid <> '' then Params.Values['fromid'] := fromid;
      if labelid <> '' then Params.Values['labelid'] := labelid;
      if count <> '' then Params.Values['count'] := count;
  try
    Result := DoRequest('GET', 'sms_receive_list', Params);
  finally
    Params.Free;
  end;
end;

function TPersiaFavaClient.PhonebookGroupAdd(title: string = ''): TStringList;
var
  Params: TStringList;
begin
      Params := TStringList.Create;
      if title <> '' then Params.Values['title'] := title;
  try
    Result := DoRequest('GET', 'user_cat_add', Params);
  finally
    Params.Free;
  end;
end;

function TPersiaFavaClient.PhonebookGroupList(page_number: string = ''; perpage: string = ''): TStringList;
var
  Params: TStringList;
begin
      Params := TStringList.Create;
      if page_number <> '' then Params.Values['page_number'] := page_number;
      if perpage <> '' then Params.Values['perpage'] := perpage;
  try
    Result := DoRequest('GET', 'user_cat_list', Params);
  finally
    Params.Free;
  end;
end;

function TPersiaFavaClient.PhonebookGroupInfo(id: string = ''): TStringList;
var
  Params: TStringList;
begin
      Params := TStringList.Create;
      if id <> '' then Params.Values['id'] := id;
  try
    Result := DoRequest('GET', 'user_cat_info', Params);
  finally
    Params.Free;
  end;
end;

function TPersiaFavaClient.PhonebookNumberAdd(catid: string = ''; number: string = ''; fullname: string = ''; repeat: string = ''; gender: string = ''; fullname_en: string = ''; blacklist_no_check: string = ''; gender_en: string = ''): TStringList;
var
  Params: TStringList;
begin
      Params := TStringList.Create;
      if catid <> '' then Params.Values['catid'] := catid;
      if number <> '' then Params.Values['number'] := number;
      if fullname <> '' then Params.Values['fullname'] := fullname;
      if repeat <> '' then Params.Values['repeat'] := repeat;
      if gender <> '' then Params.Values['gender'] := gender;
      if fullname_en <> '' then Params.Values['fullname_en'] := fullname_en;
      if blacklist_no_check <> '' then Params.Values['blacklist_no_check'] := blacklist_no_check;
      if gender_en <> '' then Params.Values['gender_en'] := gender_en;
  try
    Result := DoRequest('GET', 'sms_number_add', Params);
  finally
    Params.Free;
  end;
end;

function TPersiaFavaClient.PhonebookNumberList(catid: string = ''): TStringList;
var
  Params: TStringList;
begin
      Params := TStringList.Create;
      if catid <> '' then Params.Values['catid'] := catid;
  try
    Result := DoRequest('GET', 'sms_number_list', Params);
  finally
    Params.Free;
  end;
end;

function TPersiaFavaClient.PhonebookNumberUpdate(catid: string = ''): TStringList;
var
  Params: TStringList;
begin
      Params := TStringList.Create;
      if catid <> '' then Params.Values['catid'] := catid;
  try
    Result := DoRequest('GET', 'sms_number_update', Params);
  finally
    Params.Free;
  end;
end;

function TPersiaFavaClient.ReceivedMarkAsRead(id: string = ''; read: string = ''): TStringList;
var
  Params: TStringList;
begin
      Params := TStringList.Create;
      if id <> '' then Params.Values['id[]'] := id;
      if read <> '' then Params.Values['read'] := read;
  try
    Result := DoRequest('GET', 'sms_receive_change_read', Params);
  finally
    Params.Free;
  end;
end;

function TPersiaFavaClient.LabelList(kind: string = ''): TStringList;
var
  Params: TStringList;
begin
      Params := TStringList.Create;
      if kind <> '' then Params.Values['kind'] := kind;
  try
    Result := DoRequest('GET', 'label_list', Params);
  finally
    Params.Free;
  end;
end;

function TPersiaFavaClient.LabelAdd(title: string = ''; label: string = ''; note: string = ''; time_limit: string = ''; date_start: string = ''; date_end: string = ''; catid: string = ''; reply: string = ''): TStringList;
var
  Params: TStringList;
begin
      Params := TStringList.Create;
      if title <> '' then Params.Values['title'] := title;
      if label <> '' then Params.Values['label'] := label;
      if note <> '' then Params.Values['note'] := note;
      if time_limit <> '' then Params.Values['time_limit'] := time_limit;
      if date_start <> '' then Params.Values['date_start'] := date_start;
      if date_end <> '' then Params.Values['date_end'] := date_end;
      if catid <> '' then Params.Values['catid'] := catid;
      if reply <> '' then Params.Values['reply'] := reply;
  try
    Result := DoRequest('GET', 'label_new', Params);
  finally
    Params.Free;
  end;
end;

function TPersiaFavaClient.LabelEdit(id: string = ''; title: string = ''; note: string = ''): TStringList;
var
  Params: TStringList;
begin
      Params := TStringList.Create;
      if id <> '' then Params.Values['id'] := id;
      if title <> '' then Params.Values['title'] := title;
      if note <> '' then Params.Values['note'] := note;
  try
    Result := DoRequest('GET', 'label_edit', Params);
  finally
    Params.Free;
  end;
end;

function TPersiaFavaClient.LabelDelete(id: string = ''): TStringList;
var
  Params: TStringList;
begin
      Params := TStringList.Create;
      if id <> '' then Params.Values['id'] := id;
  try
    Result := DoRequest('GET', 'label_remove', Params);
  finally
    Params.Free;
  end;
end;

function TPersiaFavaClient.OnceLoginLink(expire: string = ''): TStringList;
var
  Params: TStringList;
begin
      Params := TStringList.Create;
      if expire <> '' then Params.Values['expire'] := expire;
  try
    Result := DoRequest('GET', 'user_once_login', Params);
  finally
    Params.Free;
  end;
end;

end.
