# Log4r::Logdna

Log4r appender that outputs to LogDNA service. Sends all the Log4r logging context data as LogDNA data
via the JSON API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'log4r-logdna'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install log4r-logdna

## Usage

Add the LogdnaOutputter to your log4r configuration:


```
  outputters:
    - type: LogdnaOutputter
      name: logdna_output
```

By default, the `env` is detected using the `RACK_ENV` environment variable but can be changed via the Outputter
configuration options.

The `app` field is set to the name of the Log4r logger. 

Since LogDNA shows the app name and log level outside of the message, an optimization is to use the `PatternFormatter`
to drop the logger name and log level, such as:

```
  outputters:
    - type: LogdnaOutputter
      name: logdna_output
      formatter   :
        pattern     : '%m'
        type        : PatternFormatter
```

Supported optional Outputter options:

```
hostname: Override auto-detected hostname 
ip: Send IP information to LogDNA
mac: Send MAC information to LogDNA
env: Override auto-detected RACK_ENV value
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/LeadDyno/log4r-logdna.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
