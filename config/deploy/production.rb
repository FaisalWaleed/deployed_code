set :branch, ENV['REVISION'] || ENV['BRANCH_NAME'] || 'master'
set :whenever_environment, :production 
server '104.130.12.61',
       user: 'botly',
       roles: %w( app db web resque retry ),
       ssh_options: {
         keys: %w(/home/james/.ssh/botly),
         forward_agent: true,
         auth_methods: %w(publickey)
       }

server '104.130.13.229',
       user: 'botly',
       roles: %w( resque ),
       ssh_options: {
         keys: %w(/home/james/.ssh/botly),
         forward_agent: true,
         auth_methods: %w(publickey)
       }

server '104.130.172.138',
       user: 'botly',
       roles: %w( resque ),
       ssh_options: {
         keys: %w(/home/james/.ssh/botly),
         forward_agent: true,
         auth_methods: %w(publickey)
       }

server '104.130.15.99',
       user: 'botly',
       roles: %w( resque ),
       ssh_options: {
         keys: %w(/home/james/.ssh/botly),
         forward_agent: true,
         auth_methods: %w(publickey)
       }

server '162.242.249.189',
       user: 'botly',
       roles: %w( resque ),
       ssh_options: {
         keys: %w(/home/james/.ssh/botly),
         forward_agent: true,
         auth_methods: %w(publickey)
       }

server '162.242.237.238',
       user: 'botly',
       roles: %w( resque ),
       ssh_options: {
         keys: %w(/home/james/.ssh/botly),
         forward_agent: true,
         auth_methods: %w(publickey)
       }

server '104.239.164.161',
       user: 'botly',
       roles: %w( resque ),
       ssh_options: {
         keys: %w(/home/james/.ssh/botly),
         forward_agent: true,
         auth_methods: %w(publickey)
       }


server '162.242.225.18',
       user: 'botly',
       roles: %w( resque ),
       ssh_options: {
         keys: %w(/home/james/.ssh/botly),
         forward_agent: true,
         auth_methods: %w(publickey)
       }

server '104.239.163.107',
       user: 'botly',
       roles: %w( resque ),
       ssh_options: {
         keys: %w(/home/james/.ssh/botly),
         forward_agent: true,
         auth_methods: %w(publickey)
       }

server '104.239.162.108',
       user: 'botly',
       roles: %w( resque ),
       ssh_options: {
         keys: %w(/home/james/.ssh/botly),
         forward_agent: true,
         auth_methods: %w(publickey)
       }

server '104.130.229.112',
       user: 'botly',
       roles: %w( resque ),
       ssh_options: {
         keys: %w(/home/james/.ssh/botly),
         forward_agent: true,
         auth_methods: %w(publickey)
       }

server '104.239.165.19',
       user: 'botly',
       roles: %w( resque ),
       ssh_options: {
         keys: %w(/home/james/.ssh/botly),
         forward_agent: true,
         auth_methods: %w(publickey)
       }

server '104.130.169.42',
       user: 'botly',
       roles: %w( resque ),
       ssh_options: {
         keys: %w(/home/james/.ssh/botly),
         forward_agent: true,
         auth_methods: %w(publickey)
       }

server '104.239.231.150',
       user: 'botly',
       roles: %w( resque ),
       ssh_options: {
         keys: %w(/home/james/.ssh/botly),
         forward_agent: true,
         auth_methods: %w(publickey)
       }

server '104.239.232.41',
       user: 'botly',
       roles: %w( resque ),
       ssh_options: {
         keys: %w(/home/james/.ssh/botly),
         forward_agent: true,
         auth_methods: %w(publickey)
       }

server '162.242.241.6',
       user: 'botly',
       roles: %w( resque ),
       ssh_options: {
         keys: %w(/home/james/.ssh/botly),
         forward_agent: true,
         auth_methods: %w(publickey)
       }

server '104.130.163.132',
       user: 'botly',
       roles: %w( resque ),
       ssh_options: {
         keys: %w(/home/james/.ssh/botly),
         forward_agent: true,
         auth_methods: %w(publickey)
       }

server '104.130.163.147',
       user: 'botly',
       roles: %w( resque ),
       ssh_options: {
         keys: %w(/home/james/.ssh/botly),
         forward_agent: true,
         auth_methods: %w(publickey)
       }
