set :branch, ENV['REVISION'] || ENV['BRANCH_NAME'] || 'master'
set :whenever_environment, :production
set :stage, :proxelle
set :rails_env, :production

server '162.220.62.84',
       user: 'botly',
       roles: %w( app db web resque retry ),
       ssh_options: {
         keys: %w(/home/james/.ssh/botly),
         forward_agent: true,
         auth_methods: %w(publickey),
         port: 41017
       }

server '198.178.123.85',
       user: 'botly',
       roles: %w( resque ),
       ssh_options: {
         keys: %w(/home/james/.ssh/botly),
         forward_agent: true,
         auth_methods: %w(publickey),
         port: 35666
       }

server '74.50.117.29',
       user: 'botly',
       roles: %w( resque ),
       ssh_options: {
         keys: %w(/home/james/.ssh/botly),
         forward_agent: true,
         auth_methods: %w(publickey),
         port: 32252
       }
