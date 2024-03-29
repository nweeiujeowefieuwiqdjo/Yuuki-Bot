# Copyright Seriel 2016-2017

module YuukiBot
  # noinspection ALL
  module Mod

    Commandrb.commands[:clear] = {
      :code => proc { |event, args|
        unless /\A\d+\z/ =~ args[0]
            event.respond("`#{args[0]}` is not a valid number!")
            break
        end
        original_num = args[0].to_i
        clearnum = original_num + 1

        if clearnum >= 100
          message = "⚠ You are attempting to clear more than 100 messages.\n"
          message << "To avoid rate limiting, the clearing will be done 99 messages at a time, so it might take a while.\n"
          message << 'This message will vanish in 5 seconds and the clearing will begin, please wait..'
          event.respond(message)
          sleep(5)
        end

        begin
            while clearnum > 0
                if clearnum >= 99
                    ids = Array.new
                    event.channel.history(99).each { |x| ids.push(x.id) }
                    Discordrb::API::Channel.bulk_delete_messages(event.bot.token, event.channel.id, ids)
                    clearnum -= 99
                    sleep(4)
                else
                    ids = Array.new
                    event.channel.history(clearnum).each { |x| ids.push(x.id) }
                    Discordrb::API::Channel.bulk_delete_messages(event.bot.token, event.channel.id, ids)
                    clearnum = 0
                end
            end
            # Emoji below is a trash can icon thingy.
            event.respond(" 🚮  Cleared #{original_num} messages!")

            # On second thought, that's annoying.

            #~ sleep(3)
            #~ message.delete
        rescue Discordrb::Errors::NoPermission
            event.respond('❌ Message delete failed!\nCheck the permissions?')
            break
        end
        nil
      },
      :triggers =>['clear', 'clean'],
      :server_only => true,
      :required_permissions => [:manage_messages],
      :owner_override => false,
      :max_args => 1,
    }

  end
end
