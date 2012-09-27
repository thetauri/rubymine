module Rubymine
  class StorageCartSystem
    def initialize
      # Register vehicle move event
      plugin.event(:vehicle_move) do |event|
        moved_a_whole_block(event) do |from, to|
          # Per block type we can check if this event is applicable, and if so, process the event.
          if transceiver = Transceiver.me?(to.get_block)
            transceiver.process_verhicle_move(event)
          end
        end
      end

      # Register our command structure
      plugin.public_command('scs', 'Storage Cart System', '/scs ...') do |me, *args|
        command(me, args)
      end
    end

    private

    # Check that we moved a whole block, this prevents multiple events fired for moving from the same X,Z coordinates
    def moved_a_whole_block(event)
      to = event.get_to
      from = event.get_from
      if to.get_x.to_i != from.get_x.to_i || to.get_y.to_i != from.get_y.to_i
        yield from, to
      end
    end

    # Fired when a player types /scs
    def command(player, arguments)
      plugin.broadcast "Look ma! #{player.name} sent me command #{arguments.first}"
    end

    def plugin
      @plugin ||= Plugin.new
    end
  end
end