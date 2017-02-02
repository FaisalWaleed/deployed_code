# clear queue
Resque.destroy('default', Bot)
# restart all workers
`killall -9 resque`
# kill all phantom
`pkill -f phantomjs`
# Clear stuck jobs
Resque.workers.each {|w| w.unregister_worker if w.processing['run_at'] && Time.now - w.processing['run_at'].to_time > 3600}
# restart resque-scheduler
resque-web -p 8282 lib/resque_web_init.rb
# restart resque-web
rake resque:schedule
