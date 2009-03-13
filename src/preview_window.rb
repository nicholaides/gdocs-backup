class PreviewWindow
  include_package 'javax.swing'
  include_package 'java.awt'
  include_package 'com.sun.pdfview'
  include_package 'java.io'
  include_package 'java.nio'
  include_package 'java.nio.channels'
  include Profligacy
  include GUIShortcuts
  
  def initialize(current_file)
    @current_file = current_file
    @main_frame = Swing::Build.new(JFrame, :x){}.build("Preview of #{current_file.title}") do |c|
      c.add main_panel
    end
    @main_frame.pack
    @main_frame.visible = true
    @main_frame.default_close_operation = JFrame::DISPOSE_ON_CLOSE
    
    @page = @pdffile.getPage(0)
    @panel.showPage(@page)
  end
  
  def main_panel
    JPanel.new.tap do |jp|
      #jp.opaque = true
      jp.background = Color::WHITE
      @panel = PagePanel.new
      file = java.io.File.new(@current_file.preview_path)
      raf = RandomAccessFile.new(file, "r")
      channel = raf.getChannel
      buf = channel.map(FileChannel::MapMode::READ_ONLY, 0, channel.size)
      @pdffile = PDFFile.new(buf)
      jp.add @panel
    end
  end
end