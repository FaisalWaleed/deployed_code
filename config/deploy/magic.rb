set :whenever_environment, :production
set :stage, :magic
set :rails_env, :production

server '104.130.170.153',
       user: 'botly',
       roles: %w( app db web resque retry ),
       ssh_options: {
         keys: %w(/home/james/.ssh/botly),
         forward_agent: true,
         auth_methods: %w(publickey)
       }

%w{162.242.235.197 162.242.232.22 162.242.232.61 104.239.166.39 104.239.168.67 23.253.151.118 162.242.223.214 162.242.232.72 162.242.221.128}.each do |ip| 
  server ip,
         user: 'botly',
         roles: %w( resque ),
         ssh_options: {
           keys: %w(/home/james/.ssh/botly),
           forward_agent: true,
           auth_methods: %w(publickey)
         }
end
