class LoginWindow
  include_package 'javax.swing'
  include_package 'java.awt'
  include Profligacy
  include GUIShortcuts
  
  def initialize(driver, owner, err_message)
    @driver = driver
    create_dialog(owner)
    @dialog.pack
    @dialog.visible = true
  end
  
  private
    def create_dialog(owner)
      layout = "
        [ login_l | (100)login]
        [ pass_l  | pass]
      "
      @dialog = JDialog.new owner, "Title", true
      @dialog.add(
        Swing::LEL.new(JPanel, layout) do |c, i|
          c.login_l = l "Google Login"
          c.pass_l  = l "Password"
          c.login   = @login = t("login")
          c.pass    = @pass  = t("pass")
        end.build,
        C
      )
      @dialog.add(
        panel(:login, :cancel) { |c,i|
          c.login  = b "Login"
          c.cancel = b "Cancel"
          i.login  = a{ login  }
          i.cancel = a{ cancel }
        },
        S
      )
      #@dialog.default_close_operation 
      @dialog.addWindowListener(proc{|sym, *args|
        @driver.quit_unless_logged_in if sym == :windowClosing 
      }.to_listener(:window))
    end
    
    def login
      @driver.login_info = [@login.text, @pass.text]
    end
    
    def cancel
      java.lang.System.exit(0)
    end
end
