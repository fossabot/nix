{ pkgs, ... }:

{
  services.mysql = {
    enable = true;
    package = pkgs.mysql;
    #initialScript = ''
    #  CREATE USER 'engelsystem'@'localhost' IDENTIFIED BY 'engelsystem';
    #  CREATE DATABASE engelsystem;
    #  GRANT ALL PRIVILEGES ON engelsystem . * TO 'engelsystem'@'localhost';
    #  FLUSH PRIVILEGES;
    #'';
  };


  services.engelsystem = {
    enable = true;
    domain = "punkte.kloenk.de";
    extraConfig = ''
      <?php
      
      // To change settings create a config.php
      
      return [
          // MySQL-Connection Settings
          'database'                => [
              'host'     => 'localhost',
              'database' => 'engelsystem',
              'username' => 'engelsystem',
              'password' => 'engelsystem',
          ],
      
          // For accessing stats
          'api_key'                 => ${"''"},
      
          // Enable maintenance mode (show a static page)
          'maintenance'             => false,
      
          // Application name (not the event name!)
          'app_name'                => env('APP_NAME', 'Engelsystem'),
      
          // Set to development to enable debugging messages
          'environment'             => env('ENVIRONMENT', 'production'),
      
          // Footer links
          'footer_items'            => [
              // URL to the angel faq and job description
              'FAQ'     => env('FAQ_URL', 'https://events.ccc.de/congress/2013/wiki/Static:Volunteers'),
      
              // Contact email address, linked on every page
              'Contact' => env('CONTACT_EMAIL', 'mailto:ticket@c3heaven.de'),
          ],
      
          // Link to documentation/help
          'documentation_url'       => 'https://engelsystem.de/doc/',
      
          // Email config
          'email'                   => [
              // Can be mail, smtp, sendmail or log
              'driver' => 'smtp',
              'from'   => [
                  // From address of all emails
                  'address' => 'noreply-punkte@kloenk.de', 
                  'name'    => 'Abi 2021 Punktesystem', 
              ],
      
              'host'       => 'localhost',
              'port'       => 587,
              // Transport encryption like tls (for starttls) or ssl
              'encryption' => 'tls',
              'username'   => 'noreply-punkte@kloenk.de',
              'password'   => 'QX}H.3S^cKa;dGv#zc>!mH~=*+35!%p}',
          ],
      
          // Default theme, 1=style1.css
          'theme'                   => 1,
      
          // Available themes
          'available_themes'        => [
			      	'12' => 'Engelsystem 36c3 (2919)',
              '10' => 'Engelsystem cccamp19 green (2019)',
              '9' => 'Engelsystem cccamp19 yellow (2019)',
              '8' => 'Engelsystem cccamp19 blue (2019)',
              '7' => 'Engelsystem 35c3 dark (2018)',
              '6' => 'Engelsystem 34c3 dark (2017)',
              '5' => 'Engelsystem 34c3 light (2017)',
              '4' => 'Engelsystem 33c3 (2016)',
              '3' => 'Engelsystem 32c3 (2015)',
              '2' => 'Engelsystem cccamp15',
              '11' => 'Engelsystem high contrast',
              '0' => 'Engelsystem light',
              '1' => 'Engelsystem dark',
          ],
      
          // Rewrite URLs with mod_rewrite
          'rewrite_urls'            => true,
      
          // Redirect to this site after logging in or when pressing the top-left button
          // Must be one of news, user_meetings, user_shifts, angeltypes, user_questions
          'home_site'               => 'news',
      
          // Number of News shown on one site
          'display_news'            => 10,
      
          // Users are able to sign up
          'registration_enabled'    => (bool)env('REGISTRATION_ENABLED', true),
      
          // Only arrived angels can sign up for shifts
          'signup_requires_arrival' => false,
      
          // Whether newly-registered user should automatically be marked as arrived
          'autoarrive'              => true,
      
          // Only allow shift signup this number of hours in advance
          // Setting this to 0 disables the feature
          'signup_advance_hours'    => 0,
      
          // Number of hours that an angel has to sign out own shifts
          'last_unsubscribe'        => 3,
      
          // Define the algorithm to use for `password_verify()`
          // If the user uses an old algorithm the password will be converted to the new format
          // See https://secure.php.net/manual/en/password.constants.php for a complete list
          'password_algorithm'      => PASSWORD_DEFAULT,
      
          // The minimum length for passwords
          'min_password_length'     => 6,
      
          // Whether the DECT field should be enabled
          'enable_dect'             => false,
      
          // Enables prename and lastname
          'enable_user_name'        => true,
      
          // Enable displaying the pronoun fields
          'enable_pronoun'          => false,
      
      
          // Enables the planned arrival/leave date
          'enable_planned_arrival'  => false,
      
          // Enables the T-Shirt configuration on signup and profile
          'enable_tshirt_size'      => true,
      
          // Number of shifts to freeload until angel is locked for shift signup.
          'max_freeloadable_shifts' => 5,
      
          // Local timezone
          'timezone'                => env('TIMEZONE', ini_get('date.timezone') ?: 'Europe/Berlin'),
      
          // Multiply 'night shifts' and freeloaded shifts (start or end between 2 and 6 exclusive) by 2
          'night_shifts'            => [
              'enabled'    => true, // Disable to weigh every shift the same
              'start'      => 2,
              'end'        => 6,
              'multiplier' => 2,
          ],
      
          // Voucher calculation
          'voucher_settings'        => [
              'initial_vouchers'   => 0,
              'shifts_per_voucher' => 1,
          ],
      
          // Available locales in /locale/
          'locales'                 => [
              'de_DE' => 'Deutsch',
              'en_US' => 'English',
          ],
      
          // The default locale to use
          'default_locale'          => 'de_DE',
      
          // Available T-Shirt sizes, set value to null if not available
          'tshirt_sizes'            => [
              'S'    => 'Small Straight-Cut',
              'S-G'  => 'Small Fitted-Cut',
              'M'    => 'Medium Straight-Cut',
              'M-G'  => 'Medium Fitted-Cut',
              'L'    => 'Large Straight-Cut',
              'L-G'  => 'Large Fitted-Cut',
              'XL'   => 'XLarge Straight-Cut',
              'XL-G' => 'XLarge Fitted-Cut',
              '2XL'  => '2XLarge Straight-Cut',
              '3XL'  => '3XLarge Straight-Cut',
              '4XL'  => '4XLarge Straight-Cut',
          ],
      
          // Session config
          'session'                 => [
              // Supported: pdo or native
              'driver' => env('SESSION_DRIVER', 'pdo'),
      
              // Cookie name
              'name'   => 'session',
          ],
      
          // IP addresses of reverse proxies that are trusted, can be an array or a comma separated list
          'trusted_proxies'         => [ '127.0.0.1/8', '::1/128' ],
      
          // Add additional headers
          'add_headers'             => (bool)env('ADD_HEADERS', true),
          'headers'                 => [
              'X-Content-Type-Options'  => 'nosniff',
              'X-Frame-Options'         => 'sameorigin',
              'Referrer-Policy'         => 'strict-origin-when-cross-origin',
      	'Content-Security-Policy' => 'default-src \'self\' \'unsafe-inline\' \'unsafe-eval\'${"'"},
      	//'Content-Security-Policy' => 'upgrade-insecure-requests',
              'X-XSS-Protection'        => '1; mode=block',
              'Feature-Policy'          => 'autoplay \'none\'${"'"},
              //'Strict-Transport-Security' => 'max-age=7776000',
              //'Expect-CT' => 'max-age=7776000,enforce,report-uri="[uri]"',
          ],
      
          // A list of credits
          'credits'                 => [
              'Contribution' => 'Please visit [engelsystem/engelsystem](https://github.com/engelsystem/engelsystem) if '
                  . 'you want to to contribute, have found any [bugs](https://github.com/engelsystem/engelsystem/issues) '
                  . 'or need help.'
          ]
      ];
    '';
  };
}