set :branch, ENV['REVISION'] || ENV['BRANCH_NAME'] || 'master'
set :whenever_environment, :staging
server '162.242.237.130',
       user: 'botly',
       roles: %w( app db web resque retry ),
       ssh_options: {
         keys: %w(/home/james/.ssh/botly),
         forward_agent: true,
         auth_methods: %w(publickey)
       }

server '104.130.4.141',
       user: 'botly',
       roles: %w( resque ),
       ssh_options: {
         keys: %w(/home/james/.ssh/botly),
         forward_agent: true,
         auth_methods: %w(publickey)
       }
