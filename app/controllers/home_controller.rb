require 'socket'

class HomeController < ApplicationController
  
  def index       
    @hostname = Socket.gethostname
    @ip_address = Socket.ip_address_list.find { |ai| ai.ipv4? && !ai.ipv4_loopback? }.ip_address
    @public_address = Socket.ip_address_list.detect{|intf| intf.ipv4? and !intf.ipv4_loopback? and !intf.ipv4_multicast? and !intf.ipv4_private?}
    respond_to do |format|
      format.html
    end
  end
  
  
end
