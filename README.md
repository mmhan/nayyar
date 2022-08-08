# Nayyar / နေရာ
[![CircleCI](https://circleci.com/gh/mmhan/nayyar/tree/master.svg?style=svg)](https://circleci.com/gh/mmhan/nayyar/tree/master)

Nayyar is created with the intent of providing basic access to State/Regions, Districts or Townships of Myanmar, based on standards of Myanmar's country-wide census of 2014.

15 States are indexed by MIMU's pcode, ISO3166-2:MM and alpha3 codes used in plate numbers by transportation authority.
74 Districts and 413 Townships are indexed by MIMU's pcode.

The current version is [![Gem Version](https://badge.fury.io/rb/nayyar.svg)](http://badge.fury.io/rb/nayyar) and it uses [Semantic Versioning](http://semver.org/)

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

### Townships

Find all townships using

```ruby
Nayyar::Townships.all
```

Find townships under a certain state using

```ruby
ygn_east = Nayyar::District.find_by_pcode "MMR013D002"
# get an array of all districts under Shan state using
ygn_east.townships
# or
Nayyar::Township.of_district(ygn_east)
```

Find a township using pcode

```ruby
Nayyar::Township.find_by_pcode("MMR013017")
# or
Nayyar::Township.find_by(pcode:"MMR013017")

# => #<Nayyar::Township:0x007fb8a5b605e8 @data={:pcode=>"MMR013017", :name=>"Botahtaung", :district=>"MMR013D002"}>
```

Find the district that a township belongs to using

```ruby
Nayyar::Township.find_by(pcode:"MMR013017").district

# => <Nayyar::District:0x007fb8a5ad14d8 @data={:pcode=>"MMR013D002", :name=>"Yangon (East)", :state=>"MMR013"}>
```

Use any of the `find_by` or `find_by_**index_name**` with a bang `!` to trigger `Nayyar::TownshipNotFound` error.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.
 
All data-related files are in the lib/data directory. `locations.csv` file is the source of truth, which includes States, Districts, and Townships data. YAML files are generated 
by extracting the data from the `locations.csv` file. Do not update directly to YAML files. Any updates must be made in the `locations.csv` file and extracted to YAML files by running `bin/seed`.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

If you feel that I have missed out your use-case or find an issue with this gem [please submit an issue](https://github.com/mmhan/nayyar/issues/new).

## Contributing

1. Fork it ( https://github.com/mmhan/nayyar/fork )
2. Create your feature branch (`git checkout -b feature/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-new-feature`)
5. Create a new Pull Request


## Documentation

Since, this is a pretty small library, a documentation hasn't been created yet. Nonetheless, here's the rspec output with documentation format.

```
Nayyar
  has a version number

Nayyar::State
  class methods
    .all
      should be a kind of Array
      contains hashes of state data
    .find_by
      returns state when it finds it
      will return nil if state is not found
      will raise ArgumentError if no argument is provided
      will raise ArgumentError if wrong argument is provided
    .find_by!
      should be a kind of Nayyar::State
      will raise error if the state isn't found
    .find_by_**indices**
      returns state when it finds it
      returns nil when it can't be found
    .find_by_**indices**!
      returns state when it finds it
      raise error when it can't be found
  #initialize
    allows to create a state by providing hash data
  attributes
    allows its attributes to be accessed by methods
    allows its attributes to be accessed as keys
  #districts
    return a list of districts under given state

Nayyar::District
  class methods
    .all
      should return all districts
    .of_state
      return a list of districts under given state
    .find_by
      should be a kind of Nayyar::District
      returns nil if it's not found
    .find_by!
      should be a kind of Nayyar::District
      raise error if it's not found
    .find_by_**indices**
      returns state when it finds it
      returns nil when it can't be found
    .find_by_**indices**!
      returns state when it finds it
      raise error when it can't be found
  #initialize
    allows to create a district by providing hash data
  attributes
    allows its attributes to be accessed by methods
    allows its attributes to be accessed as keys
  #state
    should be a kind of Nayyar::State
    expect it to be a correct state
  .townships
    return a list of districts under given district

Nayyar::Township
  class methods
    .all
      should return all township
    .of_district
      return a list of districts under given district
    .find_by
      should be a kind of Nayyar::Township
      returns nil if it's not found
    .find_by!
      should be a kind of Nayyar::Township
      raise error if it's not found
    .find_by_**indices**
      returns state when it finds it
      returns nil when it can't be found
    .find_by_**indices**!
      returns state when it finds it
      raise error when it can't be found
  #initialize
    allows to create a township by providing hash data
  attributes
    allows its attributes to be accessed by methods
    allows its attributes to be accessed as keys
  #district
    should be a kind of Nayyar::District
    expect it to be a correct state

Finished in 0.1254 seconds (files took 0.1826 seconds to load)
48 examples, 0 failures
```