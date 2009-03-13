# Dynamically load all core libraries.

__DIR__ = File.dirname(__FILE__)
$LOAD_PATH << __DIR__.gsub('%20', ' ')
Dir["#{__DIR__}/facets/*".gsub('%20', ' ')].map{|f| File.basename(f) }.reject{|f| f == 'array' }.each{ |f| require "facets/facets/#{f}" }

