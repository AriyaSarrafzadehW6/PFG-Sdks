<?php

namespace PersiaFava\Laravel\Facades;

use Illuminate\Support\Facades\Facade;

/**
 * @method static array send(string $receiver_number = null, string $sender_number = null, string $note_arr = null, string $date = null, string $clientids = null, string $show_faktor = null)
 * @method static array deliveryStatus(...$args)
 * @method static array receivedList(...$args)
 * @method static array userInfo(...$args)
 *
 * فهرست کامل متدها در persia_fava_docs.html (بخش وب‌سرویس REST) موجود است.
 */
class PersiaFava extends Facade
{
    protected static function getFacadeAccessor()
    {
        return 'persiafava';
    }
}
