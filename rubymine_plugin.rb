class RubyminePlugin
  include Purugin::Plugin, Purugin::Colors
  description 'Rubymine', 0.1
 
   def on_enable
    broadcast "Loaded 'Rubymine' plugin"

    @storage_cart_system = StorageCartSystem.new(self)


    # Some legacy build scripts
    public_command('rubymine', 'magic stuff', '/rubymine ...') do |me, *args|
      begin
        case args.first

        when 'replace'
          from = args[1] ? args[1].to_sym : raise("from required")
          to = args[2] ? args[2].to_sym : :air
          distance = (args[3] || 1).to_i
          height = (args[4] || 1).to_i

          square(me.target_block, distance, height) do |block|
            block.change_type(to) if from == :any || block.is?(from)
          end

        when 'inspect'
          me.msg me.target_block.inspect

        else
          me.msg red("Not cool!")
        end

      rescue => e
        me.msg red("ERROR: #{e.message}")
      end
    end
  end

  def broadcast(message, color = nil)
    message = case color
    when :red
      red(message)
    else
      message
    end

    server.broadcast_message message
  end

  private

  def square(start, distance = 5, height = 1)
    initial = start.block_at(:south, distance / 2).block_at(:west, distance / 2)
    height.times do |h|
      way = :north
      pointer = initial.block_at(:up, h)

      distance.times do
        distance.times do
          yield(pointer)
          pointer = pointer.block_at(way)
        end
        pointer = pointer.block_at(:east)
        way= (way == :north) ? :south : :north
        pointer = pointer.block_at(way)
      end
    end
  end
end
