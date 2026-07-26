"""
کلاینت رسمی Python برای وب‌سرویس REST پیامک پرشیا فاوا.
مستندات کامل: persia_fava_docs.html (بخش وب‌سرویس REST)

نکته: به‌جای username/password می‌توانید فقط یک API Key از پنل بسازید
و همان را به‌عنوان تنها آرگومان به سازنده‌ی کلاس بدهید.
"""
import requests

from .errors import ApiException, HttpException

BASE_URL = 'https://sms.persiafava.com/webservice/rest/'


class Client:
    def __init__(self, username_or_api_key, password=None):
        if password is None:
            self.api_key = username_or_api_key
            self.username = None
            self.password = None
        else:
            self.api_key = None
            self.username = username_or_api_key
            self.password = password

    def _auth_params(self):
        if self.api_key:
            return {'api_key': self.api_key}
        return {'login_username': self.username, 'login_password': self.password}

    def _request(self, verb, endpoint, params):
        all_params = dict(self._auth_params())
        all_params.update({k: v for k, v in params.items() if v is not None})
        url = BASE_URL + endpoint

        try:
            if verb == 'GET':
                response = requests.get(url, params=all_params, timeout=20)
            else:
                response = requests.post(url, data=all_params, timeout=20)
        except requests.RequestException as e:
            raise HttpException(f'خطای ارتباط با سرور: {e}')

        try:
            data = response.json()
        except ValueError:
            raise HttpException(f'پاسخ سرور JSON معتبر نبود: {response.text[:200]}')

        if isinstance(data, dict) and data.get('result') is False:
            raise ApiException(data.get('error', 'unknown_error'))
        return data

    def user_info(self):
        """از این متد برای دریافت اطلاعات کاربری و شماره های اختصاصی و میزان شارژ استفاده می‌شود."""
        params = {}
        return self._request('GET', 'user_info', params)

    def send(self, receiver_number=None, sender_number=None, note_arr=None, date=None, clientids=None, show_faktor=None):
        """از این متد برای ارسال پیامک از طریق معماری رست استفاده می شود. اطلاعات میتوانند توسط متد POST ارسال شوند."""
        params = {}
        if receiver_number is not None:
            params['receiver_number'] = receiver_number
        if sender_number is not None:
            params['sender_number'] = sender_number
        if note_arr is not None:
            params['note_arr[]'] = note_arr
        if date is not None:
            params['date'] = date
        if clientids is not None:
            params['clientids'] = clientids
        if show_faktor is not None:
            params['show_faktor'] = show_faktor
        return self._request('POST', 'sms_send', params)

    def delivery_status(self, dargah=None, smsid=None):
        """از این متد برای اطلاع از وضعیت پیامک های ارسال شده استفاده می شود."""
        params = {}
        if dargah is not None:
            params['dargah'] = dargah
        if smsid is not None:
            params['smsid[]'] = smsid
        return self._request('GET', 'sms_deliver', params)

    def received_list(self, read=None, number=None, fromid=None, labelid=None, count=None):
        """از این متد برای لیست پیامک های دریافتی استفاده می شود."""
        params = {}
        if read is not None:
            params['read'] = read
        if number is not None:
            params['number'] = number
        if fromid is not None:
            params['fromid'] = fromid
        if labelid is not None:
            params['labelid'] = labelid
        if count is not None:
            params['count'] = count
        return self._request('GET', 'sms_receive_list', params)

    def phonebook_group_add(self, title=None):
        """از این متد برای ایجاد گروه جدید در دفترتلفن استفاده می شود."""
        params = {}
        if title is not None:
            params['title'] = title
        return self._request('GET', 'user_cat_add', params)

    def phonebook_group_list(self, page_number=None, perpage=None):
        """از این متد برای دریافت لیست گروه های دفتر تلفن استفاده می شود."""
        params = {}
        if page_number is not None:
            params['page_number'] = page_number
        if perpage is not None:
            params['perpage'] = perpage
        return self._request('GET', 'user_cat_list', params)

    def phonebook_group_info(self, id=None):
        """از این متد برای دریافت مشخصات یک گروه از دفتر تلفن استفاده می شود."""
        params = {}
        if id is not None:
            params['id'] = id
        return self._request('GET', 'user_cat_info', params)

    def phonebook_number_add(self, catid=None, number=None, fullname=None, repeat=None, gender=None, fullname_en=None, blacklist_no_check=None, gender_en=None):
        """از این متد برای اضافه کردن شماره ی جدید به دفترتلفن استفاده می شود."""
        params = {}
        if catid is not None:
            params['catid'] = catid
        if number is not None:
            params['number'] = number
        if fullname is not None:
            params['fullname'] = fullname
        if repeat is not None:
            params['repeat'] = repeat
        if gender is not None:
            params['gender'] = gender
        if fullname_en is not None:
            params['fullname_en'] = fullname_en
        if blacklist_no_check is not None:
            params['blacklist_no_check'] = blacklist_no_check
        if gender_en is not None:
            params['gender_en'] = gender_en
        return self._request('GET', 'sms_number_add', params)

    def phonebook_number_list(self, catid=None):
        """از این متد برای دریافت لیست شماره های دفتر تلفن استفاده می شود."""
        params = {}
        if catid is not None:
            params['catid'] = catid
        return self._request('GET', 'sms_number_list', params)

    def phonebook_number_update(self, catid=None):
        """از این متد برای به روز کردن تعداد شماره های گروه های دفتر تلفن استفاده می شود."""
        params = {}
        if catid is not None:
            params['catid'] = catid
        return self._request('GET', 'sms_number_update', params)

    def received_mark_as_read(self, id=None, read=None):
        """از این متد برای تغییر وضعیت خوانده شدن پیام های دریافتی استفاده می شود."""
        params = {}
        if id is not None:
            params['id[]'] = id
        if read is not None:
            params['read'] = read
        return self._request('GET', 'sms_receive_change_read', params)

    def label_list(self, kind=None):
        """از این متد برای دریافت لیست کلمات کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود."""
        params = {}
        if kind is not None:
            params['kind'] = kind
        return self._request('GET', 'label_list', params)

    def label_add(self, title=None, label=None, note=None, time_limit=None, date_start=None, date_end=None, catid=None, reply=None):
        """از این متد برای ایجاد کلمه کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود."""
        params = {}
        if title is not None:
            params['title'] = title
        if label is not None:
            params['label'] = label
        if note is not None:
            params['note'] = note
        if time_limit is not None:
            params['time_limit'] = time_limit
        if date_start is not None:
            params['date_start'] = date_start
        if date_end is not None:
            params['date_end'] = date_end
        if catid is not None:
            params['catid'] = catid
        if reply is not None:
            params['reply'] = reply
        return self._request('GET', 'label_new', params)

    def label_edit(self, id=None, title=None, note=None):
        """از این متد برای ویرایش کلمات کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود."""
        params = {}
        if id is not None:
            params['id'] = id
        if title is not None:
            params['title'] = title
        if note is not None:
            params['note'] = note
        return self._request('GET', 'label_edit', params)

    def label_delete(self, id=None):
        """از این متد برای حذف کلمه ی کلیدی استفاده می شود."""
        params = {}
        if id is not None:
            params['id'] = id
        return self._request('GET', 'label_remove', params)

    def once_login_link(self, expire=None):
        """از این متد برای ایجاد لینک ورود مدت دار یک بار مصرف استفاده می شود."""
        params = {}
        if expire is not None:
            params['expire'] = expire
        return self._request('GET', 'user_once_login', params)
