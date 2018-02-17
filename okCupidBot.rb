class OKCMessage
  require 'rubygems'  #import modules
  require 'watir-webdriver'
  require 'gastly'
  require 'webdriver-user-agent'
  require 'watir-scroll'
  require 'digest/md5'
  require 'RMagick'
  require 'watir'
  require 'watir-webdriver-performance'
  require 'webdriver-user-agent'

  def self.okCupidBot
    $i = 1

    b = Watir::Browser.new :firefox  # call the web driver
    b.goto 'http://www.okcupid.com'  # insert URL
    
    text_field = b.button(:class => 'splashIndividual-header-signin-splashButton') # search for input form box
    if text_field.exists?  # if the text field is found
      text_field.click
    else
      puts "Button Not Found!"
      exit
    end

    old_title = b.title   # store old title
    username_field = b.text_field(:id => 'login_username') #find the login fields for username and password
    password_field = b.text_field(:id => 'login_password')

    if username_field.exists? and password_field.exists?  # if the text field is found
      username_field.set "INSERT EMAIL HERE"
      password_field.set "INSERT PASSWORD HERE"
    end

    login_button = b.button(:id => 'sign_in_button') # find sign in button

    if login_button.exists?
      login_button.click # click it
    end
    Watir::Wait.until { b.title != old_title } # wait until the page title changes to confirm load
    b.goto 'http://www.okcupid.com/match'
    urlist ||= []

    b.body(:class=>['mac  firefox logged_in   okc2014 not-scrolling hastakeover fullwidth lang-en expanded spotlight']).links.each do | link | # pull all links from page
      if(link.href.include? "profile/") # if there exists a link on the page
        urlist  << link.href  # add the url to the array
        # link.click
      else
        puts link.href + " is not a valid url"
      end
    end
    while $i < (urlist.length / 2) # loop to iterate over each item in the
      b.goto urlist[$i] # go to the url in the list
      Watir::Wait.until { b.title != old_title } # wait until the page title changes to confirm load
      like_button = b.button(:id=>'like-button')
      like_button.click
      message_button = b.button(:class=>["actions2015-chat flatbutton blue"])
      message_button.click
      text_box = b.textarea(:id=>/([message_])\w+\d/)
      if(text_box.exists?)
        text_box.click
        text_box.send_keys "THIS IS YOUR CUSTOM MESSAGE"
        submit_button = b.button(:class=>["flatbutton"])
        submit_button.click
        # okCupid has anti selenium detection this boost-cancel is an...
        # attempt to close the box they use to prevent bots however this does not work.
        deny_boost = b.a(:class=>"boost-cancel")
        deny_boost.click
        submit_button.click
        puts "Well done bot!"
      else
        puts "No text was entered into the box"
      end
      $i = $i + 1
    end
    Watir::Wait.until { b.title != old_title } # wait until the page title changes to confirm load
    puts b.title  # print out new page title
    
  end
  okCupidBot()

end
