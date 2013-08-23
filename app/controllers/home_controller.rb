require 'net/sftp'

class HomeController < ApplicationController
  
  def index
    @message = "Welcome to the Test App"
  end
  
  def show
    @sftp_address = ''
    @sftp_user_id = ''
    @sftp_password = ''
    @sftp_port = 22
    @sftp_send = '/outbound'
    @sftp_receive = '/inbound'
    
    Rails.logger.error "Starting"
    @message = []
    @message.push "Starting"
    begin
      Net::SFTP.start(@sftp_address, @sftp_user_id, :password => @sftp_password, :port => @sftp_port ) do |sftp|
        Rails.logger.error "Connection to #{@sftp_address} created with user: #{@sftp_user_id}"
        @message.push "Connection to #{@sftp_address} created with user: #{@sftp_user_id}"
        #check for the folder sending data to the vendor
        check_outbound(sftp)
        check_inbound(sftp)
      end    
    rescue SocketError => e
          Rails.logger.error "Issue with the SFTP connection => #{e.message}"
          @message.push "Issue with the SFTP connection => #{e.message}"
    rescue Net::SSH::AuthenticationFailed => e
          Rails.logger.error "User name or password is incorrect => #{e.message}"
          @message.push "User name or password is incorrect => #{e.message}"
    rescue Net::SSH::Authentication::AgentError => e
          Rails.logger.error "User name or password is incorrect => #{e.message}"
          @message.push "User name or password is incorrect => #{e.message}"          
    rescue Errno::ETIMEDOUT => e
          Rails.logger.error "Possible error with the port or other SFTP settings => #{e.message}"
          @message.push "Possible error with the port or other SFTP settings => #{e.message}"          
    rescue Net::SFTP::StatusException => e
          Rails.logger.error "A Status exception error occured => #{e.message}"
          @message.push "A Status exception error occured => #{e.message}"          
    rescue => e
          Rails.logger.error "A general error occured.  Please check your settings. => #{e.message}"          
          @message.push "A general error occured.  Please check your settings. => #{e.message}"
          @message.push "#{e.inspect}"     
    end
  end
  
  
  private
  
  def check_outbound(sftp)
      sftp.lstat!(@sftp_send) do |response|
        if response.ok?
          Rails.logger.error "The send to folder: #{@sftp_send} exists."           
          @message.push "The send to folder: #{@sftp_send} exists."
        else
          status = false
          Rails.logger.error "The send to folder: #{@sftp_send} is not correct"
          @message.push "The send to folder: #{@sftp_send} is not correct"
        end
      end
    
  end
  
  def check_inbound(sftp)
      #check for the folder receiving data from the vendor
      sftp.lstat!(@sftp_receive) do |response|
        if response.ok?
          Rails.logger.error "The receive from folder: #{@sftp_receive} exists."
          @message.push "The receive from folder: #{@sftp_receive} exists."
        else
          status = false
          Rails.logger.error "The receive from folder: #{@sftp_receive} is not correct"
          @message.push "The receive from folder: #{@sftp_receive} is not correct"
        end                  
      end    
  end
  
end
