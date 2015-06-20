# Nayyar

** THIS GEM IS STILL A WORK IN PROGRESS.**

Nayyar is created with the intent of providing basic access to State/Regions, Districts or Townships of Myanmar, based on standards of Myanmar's country-wide census of 2014.

15 States are indexed by MIMU's pcode, ISO3166-2:MM and alpha3 codes used in plate numbers by transportation authority.
74 Districts and 413 Townships are indexed by MIMU's pcode.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nayyar'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nayyar

## Usage

Find all states using ``Nayyar::State.all``.

Find states using MIMU's pcodes:


    Nayyar::State.find_by_pcode("MMR013")
    
    # => <Nayyar::State:0x007fd05cc79e60 @data={:iso=>"MM-06", :pcode=>"MMR013", :alpha3=>"YGN", :name=>"Yangon"}>


Find states using ISO3166-2:MM:


    Nayyar::State.find_by_iso("MM-01")
    
    # => #<Nayyar::State:0x007fd05cc7a040 @data={:iso=>"MM-01", :pcode=>"MMR005", :alpha3=>"SGG", :name=>"Sagaing"}>


Find states using alpha3


    Nayyar::State.find_by_alpha3("SHN")
    
    # => #<Nayyar::State:0x007fd05cc79e38     @data={:iso=>"MM-17", :pcode=>"MMR222", :alpha3=>"SHN", :name=>"Shan"}>

Or you can use a generic finder with an index

    Nayyar::State.find_by(pcode: "MMR013") #or iso: or alpha3:


<!--
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/nayyar/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
-->