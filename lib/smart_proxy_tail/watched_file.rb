module Proxy::Tail
  class WatchedFile
    attr_accessor :id, :filename

    def initialize(id, filename)
      @id = id
      @filename = filename
      @inode = 0
    end

    def to_s
      "#{filename} (#{id}) \##{@inode}/\##{inode}"
    end

    def reopen(seek = true)
      close if @handle
      if File.exist?(@filename)
        @handle = File.open(@filename, "r")
        @handle.seek(0, IO::SEEK_END) if seek
        save_inode
      end
    end

    def inode
      File.stat(@filename).ino rescue 0
    end

    def check_inode
      return unless @handle
      inode = self.inode
      reopen(false) if @inode != inode && inode > 0
      save_inode
    end

    def save_inode
      @inode = inode
    end

    def bulk_read
      return unless @handle
      @handle.gets(2000)
    end

    def close
      @handle.close if @handle
      @handle = nil
    end
  end
end
