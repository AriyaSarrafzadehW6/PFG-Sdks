<?php

namespace persiafava\yii2;

use yii\base\Component;
use PersiaFava\Client;

/**
 * کامپوننت Yii2 برای وب‌سرویس REST پیامک پرشیا فاوا.
 *
 * پیکربندی در config/web.php یا config/console.php:
 *
 * 'components' => [
 *     'persiafava' => [
 *         'class' => \persiafava\yii2\PersiaFavaComponent::class,
 *         'apiKey' => 'YOUR_API_KEY', // یا username/password
 *     ],
 * ],
 *
 * استفاده: Yii::$app->persiafava->send([...]);
 */
class PersiaFavaComponent extends Component
{
    public $apiKey;
    public $username;
    public $password;

    /** @var Client */
    private $_client;

    public function init()
    {
        parent::init();
        $this->_client = $this->apiKey
            ? new Client($this->apiKey)
            : new Client($this->username, $this->password);
    }

    public function __call($name, $params)
    {
        if (method_exists($this->_client, $name)) {
            return call_user_func_array([$this->_client, $name], $params);
        }
        return parent::__call($name, $params);
    }

    /** @return Client دسترسی مستقیم به کلاینت اصلی در صورت نیاز */
    public function getClient()
    {
        return $this->_client;
    }
}
