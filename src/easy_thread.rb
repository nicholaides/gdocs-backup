require 'thread'

def thread(*args, &block)
  Thread.start do
    begin
      yield(*args)
    rescue => e
      STDERR.puts e
      STDERR.puts e.backtrace
    end
  end
end