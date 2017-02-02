set :branch, ENV['REVISION'] || ENV['BRANCH_NAME'] || 'master'
set :whenever_environment, :production 
set :stage, :sean
set :rails_env, :production

server '23.111.154.106',
       user: 'botly',
       roles: %w( app db web resque retry ),
       ssh_options: {
         keys: %w(/home/james/.ssh/botly),
         forward_agent: true,
         auth_methods: %w(publickey)
       }

server '23.111.154.162',
       user: 'botly',
       roles: %w( resque ),
       ssh_options: {
         keys: %w(/home/james/.ssh/botly),
         forward_agent: true,
         auth_methods: %w(publickey),
       }

server '23.111.154.158',
       user: 'botly',
       roles: %w( resque ),
       ssh_options: {
         keys: %w(/home/james/.ssh/botly),
         forward_agent: true,
         auth_methods: %w(publickey),
       }
