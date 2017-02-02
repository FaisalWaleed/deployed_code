set :branch, ENV['REVISION'] || ENV['BRANCH_NAME'] || 'master'
set :whenever_environment, :production
set :stage, :stargoods
set :rails_env, :production

server '162.220.61.9',
       user: 'botly',
       roles: %w( app db web resque retry ),
       ssh_options: {
         keys: %w(/home/james/.ssh/botly),
         forward_agent: true,
         auth_methods: %w(publickey),
         port: 37505
       }

server '162.220.61.10',
       user: 'botly',
       roles: %w( resque ),
       ssh_options: {
         keys: %w(/home/james/.ssh/botly),
         forward_agent: true,
         auth_methods: %w(publickey),
         port: 24005
       }

server '74.50.117.5',
       user: 'botly',
       roles: %w( resque ),
       ssh_options: {
         keys: %w(/home/james/.ssh/botly),
         forward_agent: true,
         auth_methods: %w(publickey),
         port: 28590
       }
