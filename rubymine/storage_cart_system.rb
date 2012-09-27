module Rubymine
  class StorageCartSystem
    def initialize(plugin)
      @plugin = plugin

      # Register vehicle move event
      plugin.event(:vehicle_move) do |event|
        to = event.get_to
        from = event.get_from
        if to.get_x.to_i != from.get_x.to_i || to.get_y.to_i != from.get_y.to_i
          check(to.get_block, event.get_vehicle)
        end
      end

      # Register our command structure
      plugin.public_command('scs', 'Storage Cart System', '/scs ...') do |me, *args|
        command(me, args)
      end
    end

    def command(player, arguments)
      broadcast "Look ma! #{player.name} sent me command #{arguments.first}"
    end

    def check(block, cart)
      base = block.block_at(:down)

      if base.is?(:iron_block)
        chest = find_and_return(:chest,base)
        sign = find_and_return(:wall_sign,base)
        if chest && sign
          if cart.respond_to?(:get_inventory)
            material = sign.get_state.get_line(0).to_sym
            debug "looking for #{material}"

            Inventory.move_items(cart.get_inventory, chest.get_state.get_inventory, material)
          end
        end
      end
    end

    private

    def find_and_return(type, block)
      case 
      when block.block_at(:north).is?(type)
        block.block_at(:north)
      when block.block_at(:east).is?(type)
        block.block_at(:east)
      when block.block_at(:south).is?(type)
        block.block_at(:south)
      when block.block_at(:west).is?(type)
        block.block_at(:west)
      end
    end

    def debug(text)
      plugin.broadcast "StorageCartSystem: #{text}"
    end

    def plugin
      @plugin
    end
  end
end