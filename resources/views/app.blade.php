<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}" @class(['dark' => ($appearance ?? 'system') == 'dark'])>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title inertia>Minty Practical Case 2026</title>

    <link rel="icon" href="/favicon.ico" sizes="any">
    <link rel="icon" href="/favicon.svg" type="image/svg+xml">
    <link rel="apple-touch-icon" href="/apple-touch-icon.png">

    <link rel="preconnect" href="https://fonts.bunny.net">
    <link href="https://fonts.bunny.net/css?family=instrument-sans:400,500,600" rel="stylesheet" />

    <!-- Built assets for production -->
    <link rel="stylesheet" href="/build/assets/app-BaIqwqIy.css">
    <script type="module" src="/build/assets/app-Cby1b32m.js"></script>
    <script type="module" src="/build/assets/Welcome-C1Fl5obd.js"></script>
    @inertiaHead
</head>

<body class="font-sans antialiased">
    @inertia
</body>

</html>
