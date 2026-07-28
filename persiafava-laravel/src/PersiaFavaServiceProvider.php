<?php

namespace PersiaFava\Laravel;

use Illuminate\Support\ServiceProvider;
use PersiaFava\Client;

class PersiaFavaServiceProvider extends ServiceProvider
{
    public function register()
    {
        $this->mergeConfigFrom(__DIR__ . '/../config/persiafava.php', 'persiafava');

        $this->app->singleton(Client::class, function ($app) {
            $config = $app['config']['persiafava'];
            if (!empty($config['api_key'])) {
                return new Client($config['api_key']);
            }
            return new Client($config['username'], $config['password']);
        });

        $this->app->alias(Client::class, 'persiafava');
    }

    public function boot()
    {
        $this->publishes([
            __DIR__ . '/../config/persiafava.php' => config_path('persiafava.php'),
        ], 'config');
    }
}
