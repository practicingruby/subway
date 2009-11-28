# coding: UTF-8

module Subway
  module Parser
    extend self

    def parse(text)
      text.split(/\n{2,}/).map do |record|
        caption(record)
      end
    end

    def caption(text)
      capt = text.lines.to_a[1..-1]

      range = time_range(capt.first)
      content = capt[1..-1].join

      [range, content]
    end

    def to_seconds(time_str)
      data = time_str.match(/(\d{2}):(\d{2}):(\d{2}),(\d{3})/).captures

      hrs, mins, secs, ms = data.map { |e| e.to_i }

      3600 * hrs + 60*mins + secs + ms/1000.0
    end

    def time_range(time_str)
      d = time_str.split(" --> ").map { |e| to_seconds(e) }
      (d.first .. d.last)
    end
  end
end


if __FILE__ == $PROGRAM_NAME
  require "test/unit"

  class TestSubway < Test::Unit::TestCase

    include Subway::Parser

    def test_time_str_to_seconds
      assert_equal 30.894,  to_seconds("00:00:30,894")
      assert_equal 77.544,  to_seconds("00:01:17,544")
      assert_equal 4761.06, to_seconds("01:19:21,060")
    end

    def test_time_range
      actual = time_range("00:00:30,894 --> 00:00:50,190")
      assert_equal (30.894 .. 50.190), actual
    end

    def test_caption_parser
      text = "1\n00:00:30,894 --> 00:00:50,190\n本字幕由Livingston@CHD根据自己"+
             "看片需要自行修订\n并不对应CHD论坛任何影片\n本字幕仅供学习交流，"+
             "严禁用于商业用途"

      expected = [(30.894 .. 50.190), "本字幕由Livingston@CHD根据自己"+
             "看片需要自行修订\n并不对应CHD论坛任何影片\n本字幕仅供学习交流，"+
             "严禁用于商业用途"]

      assert_equal expected, caption(text)    
    end

    def test_parse
      actual = parse(DATA.read)
      assert 6, actual.length

      actual.each do |range, content|
        assert_kind_of Range, range
        assert_kind_of String, content
      end
    end

  end

end




__END__
1
00:00:30,894 --> 00:00:50,190
本字幕由Livingston@CHD根据自己看片需要自行修订
并不对应CHD论坛任何影片
本字幕仅供学习交流，严禁用于商业用途

2
00:00:53,000 --> 00:01:05,000
修订：Livingston

3
00:01:17,544 --> 00:01:19,739
自从到这以后  这是我们所见过的最好的地方

4
00:01:19,813 --> 00:01:21,110
是的

5
00:01:21,181 --> 00:01:22,910
好样的 伙计 兄弟

6
00:01:22,982 --> 00:01:26,281
你们会回我那吗？好的 我们走
