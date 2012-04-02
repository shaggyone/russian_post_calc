# RussianPostCalc

Calculates delivery price for russian post.

## Installation

Add this line to your application's Gemfile:

    gem 'russian_post_calc'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install russian_post_calc

## Usage

Create your calculator class
    $ class YourClass
    $   include RussianPostCalc
    $ end

Calculate using:
    $ YourClass.calculate_delivery_price "<FROM_INDEX>", "<TO_INDEX>", <WEIGHT>
or
    $ YourClass.calculate_delivery_price "<FROM_INDEX>", "<TO_INDEX>", <WEIGHT>, <DECLARED_VALUE>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
