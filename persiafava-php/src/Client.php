<?php

namespace PersiaFava;

use PersiaFava\Exceptions\ApiException;
use PersiaFava\Exceptions\HttpException;

/**
 * کلاینت رسمی PHP برای وب‌سرویس REST پرشیا فاوا.
 * مستندات کامل: persia_fava_docs.html (بخش وب‌سرویس REST)
 *
 * نکته: به‌جای usernam/password می‌توانید فقط یک API Key بسازید و همان را
 * به‌عنوان آرگومان دوم constructor بدهید؛ کلاینت به‌صورت خودکار از api_key
 * به‌جای login_username/login_password استفاده می‌کند.
 */
class Client
{
    const BASE_URL = 'https://sms.persiafava.com/webservice/rest/';

    private $username;
    private $password;
    private $apiKey;

    /**
     * @param string|null $usernameOrApiKey نام کاربری، یا در صورت استفاده از حالت API Key، مقدار خود کلید
     * @param string|null $password رمز عبور (در صورت استفاده از حالت username/password)
     */
    public function __construct($usernameOrApiKey, $password = null)
    {
        if ($password === null) {
            $this->apiKey = $usernameOrApiKey;
        } else {
            $this->username = $usernameOrApiKey;
            $this->password = $password;
        }
    }

    private function authParams()
    {
        if ($this->apiKey !== null) {
            return ['api_key' => $this->apiKey];
        }
        return ['login_username' => $this->username, 'login_password' => $this->password];
    }

    private function get($endpoint, $params)
    {
        return $this->request('GET', $endpoint, $params);
    }

    private function post($endpoint, $params)
    {
        return $this->request('POST', $endpoint, $params);
    }

    private function request($verb, $endpoint, $params)
    {
        $params = array_merge($this->authParams(), array_filter($params, function ($v) {
            return $v !== null;
        }));
        $url = self::BASE_URL . $endpoint;

        $ch = curl_init();
        if ($verb === 'GET') {
            curl_setopt($ch, CURLOPT_URL, $url . '?' . http_build_query($params));
        } else {
            curl_setopt($ch, CURLOPT_URL, $url);
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($params));
        }
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_TIMEOUT, 20);

        $response = curl_exec($ch);
        $errno = curl_errno($ch);
        $error = curl_error($ch);
        curl_close($ch);

        if ($errno) {
            throw new HttpException("خطای ارتباط با سرور: {$error}", $errno);
        }

        $data = json_decode($response, true);
        if ($data === null) {
            throw new HttpException('پاسخ سرور JSON معتبر نبود: ' . substr($response, 0, 200));
        }
        if (isset($data['result']) && $data['result'] === false) {
            $message = isset($data['error']) ? $data['error'] : 'unknown_error';
            throw new ApiException($message);
        }
        return $data;
    }

    /**
     * از این متد برای دریافت اطلاعات کاربری و شماره های اختصاصی و میزان شارژ استفاده می‌شود.
     * @return array پاسخ JSON سرور به‌صورت آرایه انجمنی
     * @throws \PersiaFava\Exceptions\ApiException
     * @throws \PersiaFava\Exceptions\HttpException
     */
    public function UserInfo()
    {
        $params = [];

        return $this->get('user_info', $params);
    }

    /**
     * از این متد برای ارسال پیامک از طریق معماری رست استفاده می شود. اطلاعات میتوانند توسط متد POST ارسال شوند.
     * @param string|null $receiver_number 
     * @param string|null $sender_number 
     * @param string|null $note_arr 
     * @param string|null $date 
     * @param string|null $clientids 
     * @param string|null $show_faktor 
     * @return array پاسخ JSON سرور به‌صورت آرایه انجمنی
     * @throws \PersiaFava\Exceptions\ApiException
     * @throws \PersiaFava\Exceptions\HttpException
     */
    public function Send($receiver_number = null, $sender_number = null, $note_arr = null, $date = null, $clientids = null, $show_faktor = null)
    {
        $params = [];
        if ($receiver_number !== null) { $params['receiver_number'] = $receiver_number; }
        if ($sender_number !== null) { $params['sender_number'] = $sender_number; }
        if ($note_arr !== null) { $params['note_arr[]'] = $note_arr; }
        if ($date !== null) { $params['date'] = $date; }
        if ($clientids !== null) { $params['clientids'] = $clientids; }
        if ($show_faktor !== null) { $params['show_faktor'] = $show_faktor; }
        return $this->post('sms_send', $params);
    }

    /**
     * از این متد برای اطلاع از وضعیت پیامک های ارسال شده استفاده می شود.
     * @param string|null $dargah 
     * @param string|null $smsid 
     * @return array پاسخ JSON سرور به‌صورت آرایه انجمنی
     * @throws \PersiaFava\Exceptions\ApiException
     * @throws \PersiaFava\Exceptions\HttpException
     */
    public function DeliveryStatus($dargah = null, $smsid = null)
    {
        $params = [];
        if ($dargah !== null) { $params['dargah'] = $dargah; }
        if ($smsid !== null) { $params['smsid[]'] = $smsid; }
        return $this->get('sms_deliver', $params);
    }

    /**
     * از این متد برای لیست پیامک های دریافتی استفاده می شود.
     * @param string|null $read 
     * @param string|null $number 
     * @param string|null $fromid 
     * @param string|null $labelid 
     * @param string|null $count 
     * @return array پاسخ JSON سرور به‌صورت آرایه انجمنی
     * @throws \PersiaFava\Exceptions\ApiException
     * @throws \PersiaFava\Exceptions\HttpException
     */
    public function ReceivedList($read = null, $number = null, $fromid = null, $labelid = null, $count = null)
    {
        $params = [];
        if ($read !== null) { $params['read'] = $read; }
        if ($number !== null) { $params['number'] = $number; }
        if ($fromid !== null) { $params['fromid'] = $fromid; }
        if ($labelid !== null) { $params['labelid'] = $labelid; }
        if ($count !== null) { $params['count'] = $count; }
        return $this->get('sms_receive_list', $params);
    }

    /**
     * از این متد برای ایجاد گروه جدید در دفترتلفن استفاده می شود.
     * @param string|null $title 
     * @return array پاسخ JSON سرور به‌صورت آرایه انجمنی
     * @throws \PersiaFava\Exceptions\ApiException
     * @throws \PersiaFava\Exceptions\HttpException
     */
    public function PhonebookGroupAdd($title = null)
    {
        $params = [];
        if ($title !== null) { $params['title'] = $title; }
        return $this->get('user_cat_add', $params);
    }

    /**
     * از این متد برای دریافت لیست گروه های دفتر تلفن استفاده می شود.
     * @param string|null $page_number 
     * @param string|null $perpage 
     * @return array پاسخ JSON سرور به‌صورت آرایه انجمنی
     * @throws \PersiaFava\Exceptions\ApiException
     * @throws \PersiaFava\Exceptions\HttpException
     */
    public function PhonebookGroupList($page_number = null, $perpage = null)
    {
        $params = [];
        if ($page_number !== null) { $params['page_number'] = $page_number; }
        if ($perpage !== null) { $params['perpage'] = $perpage; }
        return $this->get('user_cat_list', $params);
    }

    /**
     * از این متد برای دریافت مشخصات یک گروه از دفتر تلفن استفاده می شود.
     * @param string|null $id 
     * @return array پاسخ JSON سرور به‌صورت آرایه انجمنی
     * @throws \PersiaFava\Exceptions\ApiException
     * @throws \PersiaFava\Exceptions\HttpException
     */
    public function PhonebookGroupInfo($id = null)
    {
        $params = [];
        if ($id !== null) { $params['id'] = $id; }
        return $this->get('user_cat_info', $params);
    }

    /**
     * از این متد برای اضافه کردن شماره ی جدید به دفترتلفن استفاده می شود.
     * @param string|null $catid 
     * @param string|null $number 
     * @param string|null $fullname 
     * @param string|null $repeat 
     * @param string|null $gender 
     * @param string|null $fullname_en 
     * @param string|null $blacklist_no_check 
     * @param string|null $gender_en 
     * @return array پاسخ JSON سرور به‌صورت آرایه انجمنی
     * @throws \PersiaFava\Exceptions\ApiException
     * @throws \PersiaFava\Exceptions\HttpException
     */
    public function PhonebookNumberAdd($catid = null, $number = null, $fullname = null, $repeat = null, $gender = null, $fullname_en = null, $blacklist_no_check = null, $gender_en = null)
    {
        $params = [];
        if ($catid !== null) { $params['catid'] = $catid; }
        if ($number !== null) { $params['number'] = $number; }
        if ($fullname !== null) { $params['fullname'] = $fullname; }
        if ($repeat !== null) { $params['repeat'] = $repeat; }
        if ($gender !== null) { $params['gender'] = $gender; }
        if ($fullname_en !== null) { $params['fullname_en'] = $fullname_en; }
        if ($blacklist_no_check !== null) { $params['blacklist_no_check'] = $blacklist_no_check; }
        if ($gender_en !== null) { $params['gender_en'] = $gender_en; }
        return $this->get('sms_number_add', $params);
    }

    /**
     * از این متد برای دریافت لیست شماره های دفتر تلفن استفاده می شود.
     * @param string|null $catid 
     * @return array پاسخ JSON سرور به‌صورت آرایه انجمنی
     * @throws \PersiaFava\Exceptions\ApiException
     * @throws \PersiaFava\Exceptions\HttpException
     */
    public function PhonebookNumberList($catid = null)
    {
        $params = [];
        if ($catid !== null) { $params['catid'] = $catid; }
        return $this->get('sms_number_list', $params);
    }

    /**
     * از این متد برای به روز کردن تعداد شماره های گروه های دفتر تلفن استفاده می شود.
     * @param string|null $catid 
     * @return array پاسخ JSON سرور به‌صورت آرایه انجمنی
     * @throws \PersiaFava\Exceptions\ApiException
     * @throws \PersiaFava\Exceptions\HttpException
     */
    public function PhonebookNumberUpdate($catid = null)
    {
        $params = [];
        if ($catid !== null) { $params['catid'] = $catid; }
        return $this->get('sms_number_update', $params);
    }

    /**
     * از این متد برای تغییر وضعیت خوانده شدن پیام های دریافتی استفاده می شود.
     * @param string|null $id 
     * @param string|null $read 
     * @return array پاسخ JSON سرور به‌صورت آرایه انجمنی
     * @throws \PersiaFava\Exceptions\ApiException
     * @throws \PersiaFava\Exceptions\HttpException
     */
    public function ReceivedMarkAsRead($id = null, $read = null)
    {
        $params = [];
        if ($id !== null) { $params['id[]'] = $id; }
        if ($read !== null) { $params['read'] = $read; }
        return $this->get('sms_receive_change_read', $params);
    }

    /**
     * از این متد برای دریافت لیست کلمات کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود.
     * @param string|null $kind 
     * @return array پاسخ JSON سرور به‌صورت آرایه انجمنی
     * @throws \PersiaFava\Exceptions\ApiException
     * @throws \PersiaFava\Exceptions\HttpException
     */
    public function LabelList($kind = null)
    {
        $params = [];
        if ($kind !== null) { $params['kind'] = $kind; }
        return $this->get('label_list', $params);
    }

    /**
     * از این متد برای ایجاد کلمه کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود.
     * @param string|null $title 
     * @param string|null $label 
     * @param string|null $note 
     * @param string|null $time_limit 
     * @param string|null $date_start 
     * @param string|null $date_end 
     * @param string|null $catid 
     * @param string|null $reply 
     * @return array پاسخ JSON سرور به‌صورت آرایه انجمنی
     * @throws \PersiaFava\Exceptions\ApiException
     * @throws \PersiaFava\Exceptions\HttpException
     */
    public function LabelAdd($title = null, $label = null, $note = null, $time_limit = null, $date_start = null, $date_end = null, $catid = null, $reply = null)
    {
        $params = [];
        if ($title !== null) { $params['title'] = $title; }
        if ($label !== null) { $params['label'] = $label; }
        if ($note !== null) { $params['note'] = $note; }
        if ($time_limit !== null) { $params['time_limit'] = $time_limit; }
        if ($date_start !== null) { $params['date_start'] = $date_start; }
        if ($date_end !== null) { $params['date_end'] = $date_end; }
        if ($catid !== null) { $params['catid'] = $catid; }
        if ($reply !== null) { $params['reply'] = $reply; }
        return $this->get('label_new', $params);
    }

    /**
     * از این متد برای ویرایش کلمات کلیدی مورد استفاده در منشی پیامک و مسابقه و نظرسنجی استفاده می شود.
     * @param string|null $id 
     * @param string|null $title 
     * @param string|null $note 
     * @return array پاسخ JSON سرور به‌صورت آرایه انجمنی
     * @throws \PersiaFava\Exceptions\ApiException
     * @throws \PersiaFava\Exceptions\HttpException
     */
    public function LabelEdit($id = null, $title = null, $note = null)
    {
        $params = [];
        if ($id !== null) { $params['id'] = $id; }
        if ($title !== null) { $params['title'] = $title; }
        if ($note !== null) { $params['note'] = $note; }
        return $this->get('label_edit', $params);
    }

    /**
     * از این متد برای حذف کلمه ی کلیدی استفاده می شود.
     * @param string|null $id 
     * @return array پاسخ JSON سرور به‌صورت آرایه انجمنی
     * @throws \PersiaFava\Exceptions\ApiException
     * @throws \PersiaFava\Exceptions\HttpException
     */
    public function LabelDelete($id = null)
    {
        $params = [];
        if ($id !== null) { $params['id'] = $id; }
        return $this->get('label_remove', $params);
    }

    /**
     * از این متد برای ایجاد لینک ورود مدت دار یک بار مصرف استفاده می شود.
     * @param string|null $expire 
     * @return array پاسخ JSON سرور به‌صورت آرایه انجمنی
     * @throws \PersiaFava\Exceptions\ApiException
     * @throws \PersiaFava\Exceptions\HttpException
     */
    public function OnceLoginLink($expire = null)
    {
        $params = [];
        if ($expire !== null) { $params['expire'] = $expire; }
        return $this->get('user_once_login', $params);
    }
}
