namespace 'fonts' do
  desc 'Update font types configuration based on contents of /.fonts'
  task :refresh do
    `find \`pwd\`/.fonts/* | perl lib/font_configuration_generator.pl -f - > config/available_fonts.xml`
  end

  desc 'Configure local ImageMagick to use our fonts in /.fonts (Mac-only)'
  task :mac_install do
    # Tell ImageMagick where to find our available fonts configuration
    `mkdir -p ~/.magick`
    `ln -sf \`pwd\`/config/available_fonts.xml ~/.magick/type.xml`
    # List fonts ImageMagick knows about. Our fonts in .fonts/ should be listed.
    list_fonts
  end

  desc 'List fonts ImageMagick is configured to use'
  task :list do
    list_fonts
  end

  def list_fonts
    puts `identify -list font | grep 'Font: '`
  end
end