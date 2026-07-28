# کلاینت رسمی Ruby برای وب‌سرویس REST پیامک پرشیا فاوا.
# مستندات کامل: persia_fava_docs.html (بخش وب‌سرویس REST)
#
# نکته: به‌جای username/password می‌توانید فقط یک API Key از پنل بسازید
# و همان را به‌عنوان تنها آرگومان به سازنده‌ی کلاس بدهید.

require 'net/http'
require 'uri'
require 'json'
require_relative 'errors'

module PersiaFava
  class Client
    BASE_URL = 'https://sms.persiafava.com/webservice/rest/'

    # دو روش احراز هویت (فقط یکی، نه هر دو باهم): Client.new(user, pass) یا Client.new(api_key)
    def initialize(username_or_api_key, password = nil)
      if password.nil?
        @api_key = username_or_api_key
      else
        @username = username_or_api_key
        @password = password
      end
    end

    # روش ساده‌ی ارسال پیامک: لیست گیرندگان، فرستنده و متن پیام.
    def send_sms(to: [], sender: nil, text: nil)
      request('POST', 'sms_send', {
                'receiver_number' => to.join(','),
                'sender_number' => sender,
                'note_arr[]' => text
              })
    end

    private

    def auth_params
      return { 'api_key' => @api_key } if @api_key

      { 'login_username' => @username, 'login_password' => @password }
    end

    def request(verb, endpoint, params)
      all_params = auth_params.merge(params.reject { |_, v| v.nil? })
      uri = URI.parse(BASE_URL + endpoint)

      begin
        if verb == 'GET'
          uri.query = URI.encode_www_form(all_params)
          response = Net::HTTP.get_response(uri)
        else
          response = Net::HTTP.post_form(uri, all_params)
        end
      rescue StandardError => e
        raise HttpException, "خطای ارتباط با سرور: #{e.message}"
      end

      begin
        data = JSON.parse(response.body)
      rescue JSON::ParserError
        raise HttpException, "پاسخ سرور JSON معتبر نبود: #{response.body.to_s[0, 200]}"
      end

      raise ApiException, (data['error'] || 'unknown_error') if data.is_a?(Hash) && data['result'] == false

      data
    end

    public

    # از این متد برای دریافت اطلاعات کاربری و شماره های اختصاصی و میزان شارژ استفاده می‌شود.
    def user_info
      params = {}
      request('GET', 'user_info', params)
    end

    # از این متد برای ارسال پیامک از طریق معماری رست استفاده می شود. اطلاعات میتوانند توسط متد POST ارسال شوند.
    def send(receiver_number: nil, sender_number: nil, note_arr: nil, date: nil, clientids: nil, show_faktor: nil)
      params = {}
      params['receiver_number'] = receiver_number unless receiver_number.nil?
      params['sender_number'] = sender_number unless sender_number.nil?
      params['note_arr[]'] = note_arr unless note_arr.nil?
      params['date'] = date unless date.nil?
      params['clientids'] = clientids unless clientids.nil?
      params['show_faktor'] = show_faktor unless show_faktor.nil?
      request('POST', 'sms_send', params)
    end

    # از این متد برای اطلاع از وضعیت پیامک های ارسال شده استفاده می شود.
    def delivery_status(dargah: nil, smsid: nil)
      params = {}
      params['dargah'] = dargah unless dargah.nil?
      params['smsid[]'] = smsid unless smsid.nil?
      request('GET', 'sms_deliver', params)
    end

    # از این متد برای لیست پیامک های دریافتی استفاده می شود.
    def received_list(read: nil, number: nil, fromid: nil, labelid: nil, count: nil)
      params = {}
      params['read'] = read unless read.nil?
      params['number'] = number unless number.nil?
      params['fromid'] = fromid unless fromid.nil?
      params['labelid'] = labelid unless labelid.nil?
      params['count'] = count unless count.nil?
      request('GET', 'sms_receive_list', params)
    end

    # از این متد برای ایجاد گروه جدید در دفترتلفن استفاده می شود.
    def phonebook_group_add(title: nil)
      params = {}
      params['title'] = title unless title.nil?
      request('GET', 'user_cat_add', params)
    end

    # از این متد برای دریافت لیست گروه های دفتر تلفن استفاده می شود.
    def phonebook_group_list(page_number: nil, perpage: nil)
      params = {}
      params['page_number'] = page_number unless page_number.nil?
      params['perpage'] = perpage unless perpage.nil?
      request('GET', 'user_cat_list', params)
    end

    # از این متد برای دریافت مشخصات یک گروه از دفتر تلفن استفاده می شود.
    def phonebook_group_info(id: nil)
      params = {}
      params['id'] = id unless id.nil?
      request('GET', 'user_cat_info', params)
    end

    # از این متد برای اضافه کردن شماره ی جدید به دفترتلفن استفاده می شود.
    def phonebook_number_add(catid: nil, number: nil, fullname: nil, repeat: nil, gender: nil, fullname_en: nil, blacklist_no_check: nil, gender_en: nil)
      params = {}
      params['catid'] = catid unless catid.nil?
      params['number'] = number unless number.nil?
      params['fullname'] = fullname unless fullname.nil?
      params['repeat'] = repeat unless repeat.nil?
      params['gender'] = gender unless gender.nil?
      params['fullname_en'] = fullname_en unless fullname_en.nil?
      params['blacklist_no_check'] = blacklist_no_check unless blacklist_no_check.nil?
      params['gender_en'] = gender_en unless gender_en.nil?
      request('GET', 'sms_number_add', params)
    end

    # از این متد برای دریافت لیست شماره های دفتر تلفن استفاده می شود.
    def phonebook_number_list(catid: nil)
      params = {}
      params['catid'] = catid unless catid.nil?
      request('GET', 'sms_number_list', params)
    end

    # از این متد برای به روز کردن تعداد شماره های گروه های دفتر تلفن استفاده می شود.
    def phonebook_number_update(catid: nil)
      params = {}
      params['catid'] = catid unless catid.nil?
      request('GET', 'sms_number_update', params)
    end

    # از این متد برای تغییر وضعیت خوانده شدن پیام های دریافتی استفاده می شود.
    def received_mark_as_read(id: nil, read: nil)
      params = {}
      params['id[]'] = id unless id.nil?
      params['read'] = read unless read.nil?
      request('GET', 'sms_receive_change_read', params)
    end

    # از این متد برای دریافت لیست کلمات کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود.
    def label_list(kind: nil)
      params = {}
      params['kind'] = kind unless kind.nil?
      request('GET', 'label_list', params)
    end

    # از این متد برای ایجاد کلمه کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود.
    def label_add(title: nil, label: nil, note: nil, time_limit: nil, date_start: nil, date_end: nil, catid: nil, reply: nil)
      params = {}
      params['title'] = title unless title.nil?
      params['label'] = label unless label.nil?
      params['note'] = note unless note.nil?
      params['time_limit'] = time_limit unless time_limit.nil?
      params['date_start'] = date_start unless date_start.nil?
      params['date_end'] = date_end unless date_end.nil?
      params['catid'] = catid unless catid.nil?
      params['reply'] = reply unless reply.nil?
      request('GET', 'label_new', params)
    end

    # از این متد برای ویرایش کلمات کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود.
    def label_edit(id: nil, title: nil, note: nil)
      params = {}
      params['id'] = id unless id.nil?
      params['title'] = title unless title.nil?
      params['note'] = note unless note.nil?
      request('GET', 'label_edit', params)
    end

    # از این متد برای حذف کلمه ی کلیدی استفاده می شود.
    def label_delete(id: nil)
      params = {}
      params['id'] = id unless id.nil?
      request('GET', 'label_remove', params)
    end

    # از این متد برای ایجاد لینک ورود مدت دار یک بار مصرف استفاده می شود.
    def once_login_link(expire: nil)
      params = {}
      params['expire'] = expire unless expire.nil?
      request('GET', 'user_once_login', params)
    end
  end
end
