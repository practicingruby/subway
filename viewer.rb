$LOAD_PATH << "#{File.dirname(__FILE__)}/lib"
require "subway/parser"

subs = File.open(ARGV[0], "r:GB18030:UTF-8") { |f| f.read }
subs.gsub!("\r\n","\n")

data = Subway::Parser.parse(subs)

start_time = Time.now
range, text    = data.shift

loop do
  secs = Time.now - start_time

  if range.include?(secs)
    system "clear"
    puts text
    range, text = data.shift
  end
end
