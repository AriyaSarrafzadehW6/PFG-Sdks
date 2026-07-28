<?php

// در فایل .env این مقادیر را تنظیم کنید:
// PERSIAFAVA_API_KEY=your_api_key          (روش پیشنهادی)
// یا
// PERSIAFAVA_USERNAME=your_username
// PERSIAFAVA_PASSWORD=your_password

return [
    'api_key'  => env('PERSIAFAVA_API_KEY'),
    'username' => env('PERSIAFAVA_USERNAME'),
    'password' => env('PERSIAFAVA_PASSWORD'),
];
