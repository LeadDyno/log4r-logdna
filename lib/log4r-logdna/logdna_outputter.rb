require 'logdna/client'
require 'log4r/outputter/outputter'

module Log4r

  class LogdnaOutputter < Log4r::Outputter

    def initialize(_name, hash={})
      super(_name, hash)

      logdna_key = hash['logdna_key'] || ENV['LOGDNA_KEY']
      opts = {}
      opts[:hostname] = hash['hostname'] if hash['hostname']
      opts[:ip] = hash['ip'] if hash['ip']
      opts[:mac] = hash['mac'] if hash['mac']
      opts[:env] = hash['env'] || ENV['RACK_ENV']

      @gdc_key = hash.has_key?('global_context_key') ? hash['global_context_key'] : "gdc"
      @ndc_prefix = hash.has_key?('nested_context_prefix') ? hash['nested_context_prefix'] : "ndc_"
      @mdc_prefix = hash.has_key?('mapped_context_prefix') ? hash['mapped_context_prefix'] : "mdc_"

      @client = ::Logdna::Ruby.new(logdna_key, opts)
    end

    def format_attribute(value)
      value
    end

    private

    def canonical_log(logevent)

      msg = {
          :level => Log4r::LNAMES[logevent.level],
          :logger => logevent.fullname
      }

      if logevent.data.respond_to?(:backtrace)
        trace = logevent.data.backtrace
        if trace
          msg["_exception"] = format_attribute(logevent.data.class)
          msg[:message] = "Caught #{logevent.data.class}: #{logevent.data.message}"
          msg[:full_message] = "Backtrace:\n" + trace.join("\n")
          msg[:file] = trace[0].split(":")[0]
          msg[:line] = trace[0].split(":")[1]
        end
      end

      if logevent.tracer
        trace = logevent.tracer.join("\n")
        msg[:full_message] = "#{msg[:full_message]}\nLog tracer:\n#{trace}"
        msg[:file] = logevent.tracer[0].split(":")[0]
        msg[:line] = logevent.tracer[0].split(":")[1]
      end

      gdc = Log4r::GDC.get
      if gdc && gdc != $0 && @gdc_key
        begin
          msg["#{@gdc_key}"] = format_attribute(gdc)
        rescue
        end
      end

      if Log4r::NDC.get_depth > 0 && @ndc_prefix
        Log4r::NDC.clone_stack.each_with_index do |x, i|
          begin
            msg["#{@ndc_prefix}#{i}"] = format_attribute(x)
          rescue
          end
        end
      end

      mdc = Log4r::MDC.get_context
      if mdc && mdc.size > 0 && @mdc_prefix
        mdc.each do |k, v|
          begin
            msg["#{@mdc_prefix}#{k}"] = format_attribute(v)
          rescue
          end
        end
      end

      # Extract any context values out of the logevent's data hash.
      if logevent.data.respond_to?(:has_key?)
        logevent.data.each do |key, value|
          if key.to_s =~ /^_/
            msg[key] = value
          end
        end

        msg[:message] = logevent.data[:message] if logevent.data.has_key?(:message)
      end

      msg[:message] = format(logevent) unless msg[:message]

      app = logevent.fullname.split(/::/)[0]

      @client.log(msg.to_json, {:app => app})
    rescue => err
      puts "LogDNA logger. Could not send message: " + err.message
      puts err.backtrace.join("\n") if err.backtrace
    end

  end

end
