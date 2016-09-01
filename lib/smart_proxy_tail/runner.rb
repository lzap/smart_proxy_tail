require 'smart_proxy_tail/watched_file'

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
        watched_files = []
        pattern = Regexp.new(pattern)
        begin
          logger.debug "Started tail thread with " + files.collect{ |x| x[1]}.join(', ')
          files.each do |file_pair|
            file = WatchedFile.new(*file_pair)
            file.reopen
            watched_files << file
          end
          while true do
            watched_files.each do |file|
              file.check_inode
              while line = file.bulk_read do
                logger.error "[#{file.id}] #{line.chomp}" if line =~ pattern
              end
            end
            sleep poll_sleep
          end
        rescue Exception => e
          logger.error "Error during file tail: #{e}"
          logger.debug e.backtrace.join("\n")
          logger.warn "File tail plugin is now disabled"
        ensure
          watched_files.each(&:close)
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
