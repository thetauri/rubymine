module Rubymine
  class Transceiver < SystemBlock

    class << self
      def initialize(options)
        @chest = options[:chest] || raise "Chest required"
        @sign = options[:sign] || raise "Sign required"
      end

      def process_vehicle_move(event)
        @vehicle = event.get_vehicle
        if @vehicle.respond_to?(:get_inventory)

            material = sign.get_state.get_line(0).to_sym
            Inventory.move_items(cart.get_inventory, chest.get_state.get_inventory, material)
        end
      end

      def me?(block)
        base = block.block_at(:down)  
        if base.is?(:iron_block)
          chest = find_and_return(:chest,base)
          sign = find_and_return(:wall_sign,base)
          if chest && sign
            new {chest: chest, sign: sign}
          end
        end
        false
      end
    end
  end
end
