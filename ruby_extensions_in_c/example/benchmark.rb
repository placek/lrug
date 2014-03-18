#!/usr/bin/env ruby
require "benchmark"

# some massive sample of text
lipsum = %w(lorem ipsum dolor sit amet consectetur adipiscing elit nullam tortor magna ultricies et lorem at suscipit iaculis libero nulla volutpat sodales sem non porttitor leo rhoncus nec aliquam tempus dolor sit amet mollis luctus purus sapien commodo nibh eu elementum sapien ipsum quis dui proin sit amet iaculis purus cras tortor erat tristique id massa sit amet viverra euismod velit sed at libero pellentesque molestie nunc in cursus arcu nunc in enim ut nulla luctus iaculis aenean non est eu orci dapibus tincidunt vestibulum quis felis odio nunc pulvinar eros eu pharetra sollicitudin ut libero neque sollicitudin eget odio ut vehicula pharetra leoin rhoncus consequat lectus ac mollis ante congue et nunc dignissim dui sit amet enim viverra fermentum ultrices enim porta integer semper ultricies condimentum maecenas sagittis magna vitae varius ultricies ligula urna varius urna id sagittis augue nibh et leo sed dictum mattis tellus sed sollicitudin quisque id feugiat mi praesent molestie ut urna a blandit nullam eget urna id diam accumsan laoreet vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nullam nec commodo mauris id aliquam tellus in a ligula tortor in hac habitasse platea dictumst nunc pellentesque erat sed urna gravida ac convallis massa ultricies nunc dictum massa ut volutpat dapibus justo mi tincidunt felis eget laoreet metus mi eu sempraesent convallis risus vitae nisl pretium consequat nullam in risus non eros dignissim accumsan maecenas vulputate sapien sit amet enim vulputate euismod in hac habitasse platea dictumst praesent ut condimentum libero proin luctus vehicula nulla auctor aliquam leo consectetur id mauris dictum justo sed erat pulvinar et blandit nisl euismod sed vel nunc id magna ornare hendrerit eu in purus cras feugiat dictum metus sit amet placerat diam semper a vestibulum rutrum sapien in mauris tincidunt pulvinar nunc nisl donec fringilla mi nec massa volutpat faucibus donec hendrerit eros nec euismod lobortis quisque auctor sollicitudin tincidunt aliquam tristique elit sed posuere mollis nam sagittis nulla tortor ac sagittis risus facilisis id aenean non malesuada elit ut a tincidunt metussuspendisse at ornare tellus vestibulum aliquet dictum pulvinar suspendisse et tellus condimentum commodo risus nec elementum turpis fusce eu ipsum porttitor sodales quam ac pulvinar eros nunc semper mi et convallis aliquet est tortor faucibus enim in suscipit purus augue sit amet orci sed fermentum iaculis nunc eu vulputate massa tempor et integer mattis dui vitae pretium viverra urna nulla mollis fortune plango vulnerabilitis rex sedet in nunc non congue nunc velit in risus integer rhoncus viverra est pellentesque in elementum urna et lacinia massa nunc libero tortor porttitor sed sagittis vel feugiat ac velit nullam consectetur commodo imperdiet vivamus hendrerit sem quis odio consequat sed rhoncus nisi pellentesque pellentesque vulputate purus ipsum lobortis venenatis lorem viverra sed maecenas aliquam nisi a nisi eleifend nec faucibus ipsum condimentum aliquam adipiscing suscipit ultricies proin euismod dapibus erat id variussuspendisse pulvinar tincidunt quam ut volutpat justo aliquam et morbi condimentum pretium suscipit suspendisse luctus id arcu dictum cursus cras feugiat aliquam mi eu convallis odio sodales id aenean enim sapien placerat id venenatis vel porttitor et libero morbi quis euismod erat nulla quis placerat felis nam ac molestie nulla fusce condimentum condimentum cursus fusce viverra fermentum turpis lacinia aliquet nunc sed imperdiet dolor ut placerat dui in tristique ante sit amet quam cursus laoreetvivamus consequat enim sed purus semper a mollis metus posuere phasellus vel turpis vulputate laoreet risus eleifend placerat libero mauris in enim interdum sem pharetra placerat nunc ut eleifend odio nunc eu odio blandit laoreet nisi ac lobortis diam praesent tempor auctor nulla nec blandit fusce feugiat convallis augue eget bibendum aliquam non leo fermentum condimentum lectus sit amet volutpat velitduis egestas tortor sed ipsum convallis varius sed volutpat risus nisl sit amet viverra odio dapibus sit amet nulla commodo mauris eget magna rutrum commodo integer vel turpis et orci ullamcorper pretium id a lorem morbi semper diam felis non interdum est vestibulum sit amet fusce interdum metus at eros adipiscing eget ultricies justo cursus suspendisse fermentum a orci id volutpat proin posuere dui non accumsan cursus in mi erat bibendum quis scelerisque non congue non augue maecenas nunc libero sagittis quis orci elementum facilisis volutpat eros donec scelerisque tincidunt feugiat curabitur)

# arguments parsing
if ARGV.first == "--c"
  require_relative "version02/levenstein.rb"
elsif ARGV.first == "--ruby"
  require_relative "version01/levenstein.rb"
else
  puts "usage:\n  #{$0} OPTIONS\n\nOPTIONS:\n  --ruby\trun benchmark with pure Ruby code\n  --c   \trun benchmark with C extension"
  exit(0)
end

# small stats
count = lipsum.count
puts "Levenstein distance benchmark"
puts "  avg word length: #{lipsum.map(&:length).reduce(:+).to_f / count}"

# benchmark incrementing amount of words to compare
Benchmark.benchmark do |bm|
  1.upto(count / 100) do |n|
    sample = lipsum[0, n * 100]
    pairs = sample.combination(2).to_a
    bm.report("  attempt: #{n}, words: #{sample.count}, combinations: #{pairs.count}\n\t") do
      pairs.map { |pair| pair.first.levenstein_distance(pair.last) }
    end
  end
end
