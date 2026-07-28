program SendSmsExample;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, PersiaFavaClient;

var
  Client: TPersiaFavaClient;
  Response: TStringList;
begin
  // روش اول: نام کاربری و رمز عبور
  Client := TPersiaFavaClient.Create('USERNAME', 'PASSWORD');

  // روش دوم (پیشنهادی): فقط با API Key از پنل
  // Client := TPersiaFavaClient.Create('YOUR_API_KEY');

  try
    try
      Response := Client.Send('09123456789', '3000569999', 'سلام! این یک پیام آزمایشی از SDK پرشیا فاواست.');
      try
        WriteLn(Response.Text);
      finally
        Response.Free;
      end;
    except
      on E: EPersiaFavaApiException do
        WriteLn('خطای API: ' + E.Message);
      on E: EPersiaFavaHttpException do
        WriteLn('خطای شبکه: ' + E.Message);
    end;
  finally
    Client.Free;
  end;
  ReadLn;
end.
