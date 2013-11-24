module Mattheus
  class Parser
    def initialize(path)
      @path = path
      @directories = {}
    end
    
    class ParserDirectory
      def initialize(path, key)
        @path, @key = path, key
        @files = {}
      end
      
      def [](file)
        full_path = File.join(@path, @key.to_s, "#{file}.txt")
        return nil unless File.exists? full_path
        @files[file] ||= ParserFile.new(@path, @key, file)
      end
      
      def each(&block)
        i = 1
        while !self[i].nil?
          if block.arity == 2
            yield i, self[i]
          else
            yield self[i]
          end
          
          i += 1
        end
      end
    end
    
    class ParserFile
      def initialize(path, key, file)
        @path, @key, @file = path, key, file
      end
      
      def [](line)
        lines[line-1]
      end
      
      def lines
        @lines ||= File.read(File.join(@path, @key.to_s, "#{@file}.txt")).split("\n\n").map{|line| line.split("\n")}
      end
      
      def each(&block)
        i = 1
        while !self[i].nil?
          if block.arity == 2
            yield i, self[i]
          else
            yield self[i]
          end
          
          i += 1
        end
      end
    end
    
    def method_missing(meth, *args, &block)
      full_path = File.join(@path, meth.to_s)
      return super unless File.directory? full_path
      
      @directories[meth] ||= ParserDirectory.new @path, meth
    end
  end
end
