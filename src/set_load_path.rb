#__DIR__ = File.dirname(__FILE__)
#__GEMS_DIR__ = "#{__DIR__}/../lib/ruby/gems"
#$LOAD_PATH << __DIR__
#$LOAD_PATH << __DIR__ + '/../lib/ruby'
#$LOAD_PATH << __DIR__ + '/../lib/java'
#
#Dir.chdir(__GEMS_DIR__) do
#  Dir['*'].each do |f|
#    $LOAD_PATH << "#{__GEMS_DIR__}/#{f}/lib"
#  end
#end

#Dir.glob(File.expand_path(File.dirname(__FILE__) + '/**/*').gsub('%20', ' ')).each do |directory|
#  next if directory =~ /\/gems\// 
#  $LOAD_PATH << directory unless directory =~ /\.\w+$/ #File.directory? is broken in current JRuby for dirs inside jars
#end
#