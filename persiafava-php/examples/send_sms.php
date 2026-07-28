<?php
require __DIR__ . '/../vendor/autoload.php';

use PersiaFava\Client;
use PersiaFava\Exceptions\ApiException;
use PersiaFava\Exceptions\HttpException;

$client = new Client('YOUR_API_KEY');

try {
    $result = $client->sendSms(['09123456789'], '3000569999', 'سلام! این یک پیام آزمایشی از SDK پرشیا فاواست.');
    print_r($result);
} catch (ApiException $e) {
    echo "خطای API: " . $e->getMessage();
} catch (HttpException $e) {
    echo "خطای شبکه: " . $e->getMessage();
}
