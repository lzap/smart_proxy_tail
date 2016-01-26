module Proxy::Tail
  class Runner

    def initialize(pattern, files, logger, poll_sleep)
      @pattern = pattern
      @files = files
      @logger = logger
      @poll_sleep = poll_sleep
    end

    def start
      @thread = Thread.new(@pattern, @files, @logger, @poll_sleep) do |pattern, files, logger, poll_sleep|
        handles = {}
        pattern = Regexp.new(pattern)
        begin
          logger.debug "Started tail thread with " + files.collect{ |x| x[1]}.join(', ')
          files.each do |file_pair|
            fileid, filename = file_pair
            if File.exist?(filename)
              f = File.open(filename, "r")
              f.seek(0, IO::SEEK_END)
              handles[f] = fileid
            else
              logger.warn "Ignoring missing tail-file '#{filename}'"
            end
          end
          while true do
            handles.each do |f, id|
              while line = f.gets(2000) do
                logger.error "[#{id}] #{line.chomp}" if line =~ pattern
              end
            end
            sleep poll_sleep
          end
        rescue Exception => e
          logger.error "Error during file tail: #{e}"
          logger.debug e.backtrace.join("\n")
          logger.warn "File tail plugin is now disabled"
        ensure
          handles.keys.each { |h| h.close if h }
        end
      end
    end

    def stop
      @thread.terminate if @thread
    end

    def join
      @thread.join
    end
  end
end
