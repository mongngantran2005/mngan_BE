<?php

return [

    // Áp dụng cho API + Sanctum
    'paths' => ['api/*', 'sanctum/csrf-cookie'],

    // Cho phép tất cả phương thức HTTP
    'allowed_methods' => ['*'],

    // FE đang chạy ở localhost và Netlify
    'allowed_origins' => [
        'http://localhost:5173',
        'http://127.0.0.1:5173',
        'https://mngan-fe.netlify.app', // 👈 thêm domain FE chính thức
    ],

    'allowed_origins_patterns' => [],

    // Cho phép mọi header
    'allowed_headers' => ['*'],

    'exposed_headers' => [],

    'max_age' => 0,

    // Quan trọng: bật cookie / csrf
    'supports_credentials' => true,
];
