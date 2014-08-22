require "live_assets/engine"
require "thread"
require "listen"

##
# LiveAssets updates your browser using Server Send Events and Websockets with out 
# having to install anything, every time you modify a file into the assets path
# 
# @author Pablo Formoso Estrada
# @author pablo.formoso@softwhisper.es
# 
module LiveAssets

  autoload :SSESubscriber, "live_assets/sse_subscriber"

  # Store all the subscribres to the service
  mattr_reader :subscribers
  @@subscribers = []

  ##
  # Introduces a subscribre intro the array to 
  # send and attend events
  # 
  # @param [Array] the suscriber to include
  # 
  def self.subscribe(subscriber) 
    subscribers << subscriber
  end

  ##
  # Removes a subscribre intro the array to 
  # send and attend events
  # 
  # @param [Array] the subscriber to include
  # 
  def self.unsubscribe(subscriber) 
    subscribers.delete(subscriber)
  end  

  ##
  # Start tje listener for the given directories sending an
  # evento to the subscribers available.
  # 
  # @param [String] event
  # @param [Arrat] directories
  def self.start_listener(event, directories)
    Thread.new do
      Listen.to(*directories, latency: 0.5) do |modified, added, removed|        
        subscribers.each { |s| s << event }
      end.start
    end
  end

  # Mounts the path of the gem as an Engine
  # 
  class Engine < Rails::Engine
    paths["app/controllers"] << "lib/controllers"
  end
end
