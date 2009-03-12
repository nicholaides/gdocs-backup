class LoginWindow
  include_package 'javax.swing'
  include_package 'java.awt'
  include Profligacy
  include GUIShortcuts
  
  def initialize(driver, owner, err_message=nil)
    @driver = driver
    create_dialog(owner, err_message)
    @dialog.pack
    @dialog.visible = true
  end
  
  private
    def create_dialog(owner, err_message=nil)
      @dialog = JDialog.new owner, "Title", true
      
      if err_message
        @dialog.add( panel(:msg) { |c,i| c.msg = l err_message }, N )
      end
      
      layout = "
        [ login_l | (200)login]
        [ pass_l  | pass]
      "
      
      @dialog.add(
        Swing::LEL.new(JPanel, layout) do |c, i|
          c.login_l = l "Google Login"
          c.pass_l  = l "Password"
          c.login   = @login = t("login")
          c.pass    = @pass  = JPasswordField.new
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
      @dialog.hide
    end
    
    def cancel
      @driver.quit_unless_logged_in
    end
end
