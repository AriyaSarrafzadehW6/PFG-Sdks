/**
 * کلاینت رسمی Node.js برای وب‌سرویس REST پیامک پرشیا فاوا.
 * مستندات کامل: persia_fava_docs.html (بخش وب‌سرویس REST)
 *
 * نکته: به‌جای username/password می‌توانید فقط یک API Key از پنل بسازید
 * و همان را به‌عنوان تنها آرگومان به constructor بدهید.
 */
const axios = require('axios');
const qs = require('querystring');
const { ApiException, HttpException } = require('./errors');

const BASE_URL = 'https://sms.persiafava.com/webservice/rest/';

class PersiaFavaClient {
  /**
   * @param {string} usernameOrApiKey نام کاربری یا API Key
   * @param {string} [password] رمز عبور (در صورت استفاده از حالت username/password)
   */
  constructor(usernameOrApiKey, password) {
    if (password === undefined) {
      this.apiKey = usernameOrApiKey;
    } else {
      this.username = usernameOrApiKey;
      this.password = password;
    }
  }

  _authParams() {
    if (this.apiKey) return { api_key: this.apiKey };
    return { login_username: this.username, login_password: this.password };
  }

  async _request(verb, endpoint, params) {
    const allParams = Object.assign({}, this._authParams(), params);
    Object.keys(allParams).forEach((k) => (allParams[k] === undefined || allParams[k] === null) && delete allParams[k]);
    const url = BASE_URL + endpoint;

    let response;
    try {
      if (verb === 'GET') {
        response = await axios.get(url, { params: allParams, timeout: 20000 });
      } else {
        response = await axios.post(url, qs.stringify(allParams), { timeout: 20000 });
      }
    } catch (err) {
      throw new HttpException('خطای ارتباط با سرور: ' + err.message);
    }

    const data = response.data;
    if (data && data.result === false) {
      throw new ApiException(data.error || 'unknown_error');
    }
    return data;
  }

  /**
   * از این متد برای دریافت اطلاعات کاربری و شماره های اختصاصی و میزان شارژ استفاده می‌شود.
   * @param {Object} params (بدون پارامتر ورودی)
   * @returns {Promise<Object>}
   */
  userInfo() {
    return this._request('GET', 'user_info', params);
  }

  /**
   * از این متد برای ارسال پیامک از طریق معماری رست استفاده می شود. اطلاعات میتوانند توسط متد POST ارسال شوند.
   * @param {Object} params receiver_number, sender_number, note_arr, date, clientids, show_faktor
   * @returns {Promise<Object>}
   */
  send(params = {}) {
    return this._request('POST', 'sms_send', params);
  }

  /**
   * از این متد برای اطلاع از وضعیت پیامک های ارسال شده استفاده می شود.
   * @param {Object} params dargah, smsid
   * @returns {Promise<Object>}
   */
  deliveryStatus(params = {}) {
    return this._request('GET', 'sms_deliver', params);
  }

  /**
   * از این متد برای لیست پیامک های دریافتی استفاده می شود.
   * @param {Object} params read, number, fromid, labelid, count
   * @returns {Promise<Object>}
   */
  receivedList(params = {}) {
    return this._request('GET', 'sms_receive_list', params);
  }

  /**
   * از این متد برای ایجاد گروه جدید در دفترتلفن استفاده می شود.
   * @param {Object} params title
   * @returns {Promise<Object>}
   */
  phonebookGroupAdd(params = {}) {
    return this._request('GET', 'user_cat_add', params);
  }

  /**
   * از این متد برای دریافت لیست گروه های دفتر تلفن استفاده می شود.
   * @param {Object} params page_number, perpage
   * @returns {Promise<Object>}
   */
  phonebookGroupList(params = {}) {
    return this._request('GET', 'user_cat_list', params);
  }

  /**
   * از این متد برای دریافت مشخصات یک گروه از دفتر تلفن استفاده می شود.
   * @param {Object} params id
   * @returns {Promise<Object>}
   */
  phonebookGroupInfo(params = {}) {
    return this._request('GET', 'user_cat_info', params);
  }

  /**
   * از این متد برای اضافه کردن شماره ی جدید به دفترتلفن استفاده می شود.
   * @param {Object} params catid, number, fullname, repeat, gender, fullname_en, blacklist_no_check, gender_en
   * @returns {Promise<Object>}
   */
  phonebookNumberAdd(params = {}) {
    return this._request('GET', 'sms_number_add', params);
  }

  /**
   * از این متد برای دریافت لیست شماره های دفتر تلفن استفاده می شود.
   * @param {Object} params catid
   * @returns {Promise<Object>}
   */
  phonebookNumberList(params = {}) {
    return this._request('GET', 'sms_number_list', params);
  }

  /**
   * از این متد برای به روز کردن تعداد شماره های گروه های دفتر تلفن استفاده می شود.
   * @param {Object} params catid
   * @returns {Promise<Object>}
   */
  phonebookNumberUpdate(params = {}) {
    return this._request('GET', 'sms_number_update', params);
  }

  /**
   * از این متد برای تغییر وضعیت خوانده شدن پیام های دریافتی استفاده می شود.
   * @param {Object} params id, read
   * @returns {Promise<Object>}
   */
  receivedMarkAsRead(params = {}) {
    return this._request('GET', 'sms_receive_change_read', params);
  }

  /**
   * از این متد برای دریافت لیست کلمات کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود.
   * @param {Object} params kind
   * @returns {Promise<Object>}
   */
  labelList(params = {}) {
    return this._request('GET', 'label_list', params);
  }

  /**
   * از این متد برای ایجاد کلمه کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود.
   * @param {Object} params title, label, note, time_limit, date_start, date_end, catid, reply
   * @returns {Promise<Object>}
   */
  labelAdd(params = {}) {
    return this._request('GET', 'label_new', params);
  }

  /**
   * از این متد برای ویرایش کلمات کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود.
   * @param {Object} params id, title, note
   * @returns {Promise<Object>}
   */
  labelEdit(params = {}) {
    return this._request('GET', 'label_edit', params);
  }

  /**
   * از این متد برای حذف کلمه ی کلیدی استفاده می شود.
   * @param {Object} params id
   * @returns {Promise<Object>}
   */
  labelDelete(params = {}) {
    return this._request('GET', 'label_remove', params);
  }

  /**
   * از این متد برای ایجاد لینک ورود مدت دار یک بار مصرف استفاده می شود.
   * @param {Object} params expire
   * @returns {Promise<Object>}
   */
  onceLoginLink(params = {}) {
    return this._request('GET', 'user_once_login', params);
  }
}

module.exports = PersiaFavaClient;
