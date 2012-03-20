# Given a word, find other words that are commonly listed with it.

%w(rubygems wordnik).each {|lib| require lib }

Wordnik.configure do |config|
  config.api_key = ENV['WORDNIK_API_KEY']
  config.host = "api.wordnik.com"
  config.base_path = "/v4"
end

# Get all the lists containing the given word
all_words = Hash.new(0)
lists = Wordnik.word.get_listed_in('persimmon', :limit => 1000)

# For each list containing the word..
lists.each do |list|
  puts list['name']
  listed_words = Wordnik.word_list.get_word_list_words(list['permalink'], :limit => 2000).map {|w| w['word'] }
  listed_words.each do |listed_word|
    all_words[listed_word['word']] += 1
  end
end

winners = all_words.sort_by { |k,v| v }.reverse.take(20)

winners.each do |winner|
  word, count = winner
  spacing = 30 - word.size
  puts "#{word}#{' ' * spacing}#{count}"
end

=begin

# Sample output:

narwhal             24
---------------------
giraffe             4
phoenix             4
axolotl             4
alpaca              3
wombat              3
llama               3
hedgehog            3
pangolin            3
onager              3
armadillo           3
vapid               3
ebb                 3
wanderlust          3
leviathan           3
dolphin             3
rorqual             3
starfish            3
gemsbok             3
vicuña              3

php                 7
---------------------
blog                4
wordpress           3
firefox             3
python              3
javascript          3
cms                 2
bistro              2
jovial              2
perl                2
cat                 2
java                2
html                2
xhtml               2
code                2
mhra                2
llc                 2
drupal              2
ajax                2
berserk             2

persimmon           59
----------------------
pomegranate         13
pumpkin             11
tangerine           11
plum                11
peach               11
cerulean            11
apricot             11
amber               10
periwinkle          9
azure               9
lime                8
rose                8
cinnabar            8
wisteria            8
carmine             8
russet              8
thistle             8
umber               8
crimson             8

=end