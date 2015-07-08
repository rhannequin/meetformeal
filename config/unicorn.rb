preload_app true
app_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
working_directory app_root
worker_processes 4
timeout 30
pid_dir = File.join(app_root, 'tmp', 'pids')
pid_file = File.expand_path(File.join(pid_dir, 'unicorn.pid'))
pid pid_file
log_dir = ENV['APPLI_LOG'] || File.join(app_root, 'log')
log_file =  File.expand_path(File.join(log_dir, 'unicorn.log'))
stderr_path log_file
stdout_path log_file

# listen "127.0.0.1:8080", backlog: 1024

before_fork do |server, worker|
  # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
  # immediately start loading up a new version of itself (loaded with a new
  # version of our app). When this new Unicorn is completely loaded
  # it will begin spawning workers. The first worker spawned will check to
  # see if an .oldbin pidfile exists. If so, this means we've just booted up
  # a new Unicorn and need to tell the old one that it can now die. To do so
  # we send it a QUIT.
  #
  # Using this method we get 0 downtime deploys.
  old_pid = pid_file + '.oldbin'
  if File.exist?(old_pid) && server.pid != old_pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      puts 'Someone else did our job for us: kill the old master process'
    end
  end

  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
end

after_fork do |_, _|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
