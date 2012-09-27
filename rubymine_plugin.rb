require_relative 'rubymine/transceiver'
require_relative 'rubymine/storage_cart_system'

class RubyminePlugin
  include Purugin::Plugin, Purugin::Colors
  description 'Rubymine', 0.1
 
   def on_enable
    @plugin = RubyMine::Plugin.new
    @plugin.setup self
    @plugin.broadcast "Loaded 'Rubymine' plugin"

    @storage_cart_system = Rubymine::StorageCartSystem.new(self)
  end
end