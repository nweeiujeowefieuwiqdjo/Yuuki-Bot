# Copyright Seriel 2016-2017
module YuukiBot
  module Owner

    Commandrb.commands[:upload] = {
      code: proc { |event, args|
        filename = args.join(' ')
        event.channel.send_file File.new([filename].sample)
      },
      triggers: %w(upload sendfile),
      owners_only: true,
    }

    Commandrb.commands[:rehost] = {
      code: proc { |event, args|
        event.channel.start_typing
        url = args.join(' ')
        file = Helper.download_file(url, 'tmp')
        Helper.upload_file(event.channel, file)
        event.message.delete
      },
      triggers: %w(rehost sendurl),
      owners_only: true,
    }

    # noinspection RubyResolve,RubyResolve
    Commandrb.commands[:dump] = {
      code: proc { |event, args|
        channel = begin
          args[0].nil? ? event.bot.channel(event.channel.id) : event.bot.channel(args[0])
        rescue
          event.respond('❌ Enter a valid channel id!')
        end
        ts = event.message.timestamp
        Helper.dump_channel(channel, event.channel, Config.dump_dir, ts)
        event.respond('✅ Dumped successfully!')
      },
      triggers: %w(dump log savechannel),
      owners_only: true,
    }

  end
end
