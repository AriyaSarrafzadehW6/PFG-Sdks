<?php

namespace App\Http\Controllers;

use PersiaFava\Laravel\Facades\PersiaFava;
// یا با dependency injection: use PersiaFava\Client;

class SendSmsController extends Controller
{
    public function send()
    {
        // با Facade
        $result = PersiaFava::send(
            receiver_number: '09123456789',
            sender_number: '3000569999',
            note_arr: 'سلام! این یک پیام آزمایشی از بسته لاراول پرشیا فاواست.'
        );

        return response()->json($result);
    }
}
