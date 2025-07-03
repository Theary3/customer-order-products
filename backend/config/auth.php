<?php

return [
    'defaults' => [
        'guard' => 'web',
        'passwords' => 'users',
    ],

    'guards' => [
        'web' => [
            'driver' => 'session',
            'provider' => 'customers', // Changed to customers
        ],

        'api' => [
            'driver' => 'sanctum',
            'provider' => 'customers', // Changed to customers
        ],
    ],

    'providers' => [
        'customers' => [ // Changed from 'users' to 'customers'
            'driver' => 'eloquent',
            'model' => App\Models\Customer::class, // Use Customer model
        ],
    ],

    'passwords' => [
        'users' => [
            'provider' => 'customers', // Changed to customers
            'table' => 'password_resets',
            'expire' => 60,
            'throttle' => 60,
        ],
    ],

    'password_timeout' => 10800,
];