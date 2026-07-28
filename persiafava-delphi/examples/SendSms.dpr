program SendSms;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  PersiaFavaClient in '..\PersiaFavaClient.pas';

var
  Client: TPersiaFavaClient;
begin
  // روش اول: نام کاربری و رمز عبور
  Client := TPersiaFavaClient.Create('USERNAME', 'PASSWORD');

  // روش دوم (پیشنهادی): فقط با API Key از پنل
  // Client := TPersiaFavaClient.Create('YOUR_API_KEY');

  try
    try
      WriteLn(Client.Send('09123456789', '3000569999',
        'سلام! این یک پیام آزمایشی از SDK پرشیا فاواست.'));
    except
      on E: Exception do
        WriteLn('خطا: ', E.Message);
    end;
  finally
    Client.Free;
  end;
  ReadLn;
end.
