class ProgressWindow
  include_package 'javax.swing'
  include_package 'java.awt'
  include Profligacy
  include GUIShortcuts

  def initialize(driver, owner)
    @driver = driver
    create_dialog(owner)
    @dialog.pack
    @dialog.visible = true
  end
  
  def update_status(str)
    @status_l.text = str
  end
  
  def update_progress(complete, total)
    if total == 0
      @progress_bar.indeterminate = true
      @progress_bar.string        = nil
    else
      @progress_bar.indeterminate = false
      @progress_bar.maximum       = total
      @progress_bar.value         = complete
      @progress_bar.string        = "#{complete}/#{total}"
    end
  end
  
  def complete!
    @dialog.hide
  end
  
  private
    def create_dialog(owner)
      @dialog = JDialog.new owner, "Backing up Documents"
      
      @dialog.add(
        Swing::LEL.new(JPanel, "[status_l][progress_bar]") do |c, i|
          c.status_l     = @status_l     = l("Status...")
          c.progress_bar = @progress_bar = JProgressBar.new
        end.build,
        C
      )
      @dialog.add(
        Swing::LEL.new(JPanel, '[ >cancel]') { |c,i|
          c.cancel = b "Cancel"
          i.cancel = a{ cancel }
        }.build,
        S
      )
      
      @progress_bar.string_painted = true
    end
    
    def cancel
      @driver.quit_unless_logged_in
    end
  
end