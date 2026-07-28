<?php

namespace app\controllers;

use Yii;
use yii\web\Controller;

class SiteController extends Controller
{
    public function actionSendSms()
    {
        $result = Yii::$app->persiafava->send(
            receiver_number: '09123456789',
            sender_number: '3000569999',
            note_arr: 'سلام! این یک پیام آزمایشی از کامپوننت Yii2 پرشیا فاواست.'
        );

        return $this->asJson($result);
    }
}
