<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>{{ config('app.name', 'Pterodactyl') }}</title>
        <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
        <meta name="csrf-token" content="{{ csrf_token() }}">

        @section('scripts')
            {!! Assets::css() !!}
        @show

        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="/themes/neon.css">

        @yield('css')

        <script>
            window.SiteConfiguration = {!! json_encode([
                'csrfToken' => csrf_token(),
                'siteTitle' => config('app.name', 'Pterodactyl'),
            ]) !!};
        </script>
    </head>
    <body class="{{ $css['body'] ?? 'pt-body' }}">
        @section('content')
            @yield('above-container')
            <div class="{{ $css['container'] ?? 'container-fluid' }}">
                <div class="row">
                    @yield('container')
                </div>
            </div>
            @yield('below-container')
        @show
        @section('scripts')
            {!! Assets::js() !!}
        @show
        @yield('footer-scripts')
    </body>
</html>
