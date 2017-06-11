# Puppet-Debugger Graph Plugin
This plugin is currently in alpha phase, do not use!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'debugger-graph'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install debugger-graph

Install graphviz or use the provided docker container

### OS X
 `brew install graphviz`

## Usage

1. Start the puppet debugger or use the container `docker run -ti --rm -p 12000:12000 nwops/puppet-debugger-graph`
2. type `graph` to enable graph mode
3. Open a browser and goto http://localhost:12000
3. create some resources in the debugger
4. Add some more resources and watch the graph grow  (refreshes every 10 seconds)


This should make some example graphs

```ruby
  file{'/tmp/test': ensure => present}
  file{'/tmp/test2': ensure => present}
  service{'httpd': ensure => running }
  file{'/tmp/test3': ensure => present, notify => Service['httpd']}
  file{'/tmp/test4': ensure => present, require => File['/tmp/test2']}

```

### Demo in a container
1. Start the puppet debugger or use the container `docker run -ti --rm -p 12000:12000 nwops/puppet-debugger-graph`
2. type `play https://gist.github.com/logicminds/53523f427f208f6521716e4e5f93307e` inside the debugger
3. Open a browser and goto http://localhost:12000
4. Add some more resources and watch the graph grow  (refreshes every 10 seconds)


## Container
To run in a container use the following command

`docker run -ti --rm -p 12000:12000 nwops/puppet-debugger-graph`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/logicminds/debugger-graph. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
