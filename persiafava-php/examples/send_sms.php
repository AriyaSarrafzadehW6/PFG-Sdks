<?php
require __DIR__ . '/../vendor/autoload.php';

use PersiaFava\Client;
use PersiaFava\Exceptions\ApiException;
use PersiaFava\Exceptions\HttpException;

// روش اول: نام کاربری و رمز عبور
$client = new Client('USERNAME', 'PASSWORD');

// روش دوم (پیشنهادی): فقط با API Key از پنل
// $client = new Client('YOUR_API_KEY');

try {
    $result = $client->send([
        'receiver_number' => '09123456789',
        'sender_number'   => '3000569999',
        'note_arr[]'      => 'سلام! این یک پیام آزمایشی از SDK پرشیا فاواست.',
    ]);
    print_r($result);
} catch (ApiException $e) {
    echo "خطای API: " . $e->getMessage();
} catch (HttpException $e) {
    echo "خطای شبکه: " . $e->getMessage();
}
