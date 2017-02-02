set :branch, ENV['REVISION'] || ENV['BRANCH_NAME'] || 'master'
set :whenever_environment, :production
set :stage, :jvtool
set :rails_env, :production

server '209.133.199.225',
       user: 'botly',
       roles: %w( app db web resque retry ),
       ssh_options: {
         keys: %w(/home/james/.ssh/botly),
         forward_agent: true,
         auth_methods: %w(publickey),
         port: 27716
       }

{ '209.133.222.186' => 35121, '209.133.204.90' => 33178 }.each do |ip, port|
  server ip,
         user: 'botly',
         roles: %w( resque ),
         ssh_options: {
           keys: %w(/home/james/.ssh/botly),
           forward_agent: true,
           auth_methods: %w(publickey),
           port: port
         }
end
