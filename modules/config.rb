module YuukiBot

  class << self
     attr_accessor :config
  end

  require 'yaml'
  # Load Config from YAML
  @config = YAML.load_file('config/config.yml')
  @config.each do |key, value|
    if value.nil?
      puts "config.yml: #{key} is nil!"
      puts 'Corrupt or incorrect Yaml.'
      exit
    else
      puts("config.yml: Found #{key}: #{value}") if @config['verbose']
    end
  end

  if @config['status'].nil?
    puts 'Enter a valid status in config.yml!'
    puts 'Valid options are \'online\', \'idle\', \'dnd\' and \'invisible\'.'
    exit
  end

  if @config['token'].nil?
    puts 'No valid token entered!'
    exit
  end

  def self.build_init
    # Transfer it into an init hash.
    init_hash = {
      token: @config['token'],
      prefixes: @config['prefixes'],
      client_id: @config['client_id'],
      parse_self: @config['parse_self'],
      parse_bots: @config['parse_bots'],
      selfbot: @config['selfbot'],
      type: @config['type'],
      game: @config['game'],
      owners: @config['owners'],
      typing_default: @config['typing_default'],
      ready: proc { |event|
        puts "[READY] :: Logged in as #{event.bot.user(event.bot.profile.id).distinct} !"
        puts "[READY] :: Servers: #{event.bot.servers.count}"

        puts '>> Bot connected and ready for action! << '
      },
      on_message: Proc.new {|event|
        begin
          next if Config.ignored_servers.include?(event.server.id) || !Config.logging
        rescue
          nil
        end
        Logging.get_message(event, nil)
       }
    }
  end
end
