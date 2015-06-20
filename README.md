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

### States

Find all states using

```ruby
Nayyar::State.all
```

Find states using MIMU's pcodes:

```ruby
Nayyar::State.find_by_pcode("MMR013")
# => <Nayyar::State:0x007fd05cc79e60 @data={:iso=>"MM-06", :pcode=>"MMR013", :alpha3=>"YGN", :name=>"Yangon"}>
```

Find states using ISO3166-2:MM:

```ruby
Nayyar::State.find_by_iso("MM-01")
# => #<Nayyar::State:0x007fd05cc7a040 @data={:iso=>"MM-01", :pcode=>"MMR005", :alpha3=>"SGG", :name=>"Sagaing"}>
```


Find states using alpha3

```ruby
Nayyar::State.find_by_alpha3("SHN")
# => #<Nayyar::State:0x007fd05cc79e38     @data={:iso=>"MM-17", :pcode=>"MMR222", :alpha3=>"SHN", :name=>"Shan"}>
```

Or you can use a generic finder with an index

```ruby
Nayyar::State.find_by(pcode: "MMR013") #or iso: or alpha3:
```

Use any of the `find_by` or `find_by_**index_name**` with a bang `!` to trigger `Nayyar::StateNotFound` error.

### Districts

Find all districts using
```ruby
Nayyar::District.all
```

Find districts under a certain state using
```ruby
shan_state = Nayyar::State.find_by_alpha3("SHN")
# get an array of all districts under Shan state using
shan_state.districts
# or
Nayyar::District.of_state(shan_state)
```

Find a district using pcode
```ruby
Nayyar::District.find_by_pcode("MMR001D001")
# or
Nayyar::District.find_by(pcode:"MMR001D001")

# => #<Nayyar::District:0x007f9bf5361418 @data={:pcode=>"MMR001D001", :name=>"Myitkyina", :state=>"MMR001"}>
```

Find the state that a district belongs to using
```ruby
Nayyar::District.find_by(pcode:"MMR001D001").state

# => <Nayyar::State:0x007f9bf532fc60 @data={:iso=>"MM-11", :pcode=>"MMR001", :alpha3=>"KCN", :name=>"Kachin"}>
```

Use any of the `find_by` or `find_by_**index_name**` with a bang `!` to trigger `Nayyar::DistrictNotFound` error.

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