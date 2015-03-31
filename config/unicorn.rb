# Sample verbose configuration file for Unicorn (not Rack)
#
# This configuration file documents many features of Unicorn
# that may not be needed for some applications. See
# http://unicorn.bogomips.org/examples/unicorn.conf.minimal.rb
# for a much simpler configuration file.
#
# See http://unicorn.bogomips.org/Unicorn/Configurator.html for complete
# documentation.

app_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
app_env = ENV['RACK_ENV'] || 'development'
is_production = app_env == 'production'
is_development = app_env == 'development'

# Use at least one worker per core if you're on a dedicated server,
# more will usually help for _short_ waits on databases/caches.
worker_processes(is_production ? 4 : 1)

# Since Unicorn is never exposed to outside clients, it does not need to
# run on the standard HTTP port (80), there is no reason to start Unicorn
# as root unless it's from system init scripts.
# If running the master process as root and the workers as an unprivileged
# user, do this to switch euid/egid in the workers (also chowns logs):
# user "unprivileged_user", "unprivileged_group"

# Help ensure your application will always spawn in the symlinked
# "current" directory that Capistrano sets up.
working_directory app_root # available in 0.94.0+

# nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 30

tmp_dir_socket = File.expand_path(File.join(app_root, 'tmp', 'socket'))
FileUtils.mkdir_p tmp_dir_socket unless Dir.exist?(tmp_dir_socket)
listen_socket_file = File.expand_path(File.join(tmp_dir_socket, 'unicorn.sock.0'))

# listen on both a Unix domain socket and a TCP port,
# we use a shorter backlog for quicker failover when busy
listen listen_socket_file, backlog: 512
if is_development
  listen('0.0.0.0:' + "#{ENV['PORT'] || '5000'}", backlog: 512, tcp_nopush: true)
else
  listen 8080, tcp_nopush: true
end

tmp_dir_pid = File.expand_path(File.join(app_root, 'tmp', 'pids'))
FileUtils.mkdir_p tmp_dir_pid unless Dir.exist?(tmp_dir_pid)
pid_file = File.expand_path(File.join(tmp_dir_pid, 'unicorn.pid'))

# feel free to point this anywhere accessible on the filesystem
pid pid_file

tmp_dir_log = File.expand_path(File.join(app_root, 'tmp', 'log'))
FileUtils.mkdir_p tmp_dir_log unless Dir.exist?(tmp_dir_log)

stderr_file = File.expand_path(File.join(tmp_dir_log, "unicorn_#{app_env}_error.log"))
stdout_file = File.expand_path(File.join(tmp_dir_log, "unicorn_#{app_env}.log"))

# By default, the Unicorn logger will write to stderr.
# Additionally, ome applications/frameworks log to stderr or stdout,
# so prevent them from going to /dev/null when daemonized here:
stderr_path stderr_file
stdout_path stdout_file

# combine Ruby 2.0.0dev or REE with "preload_app true" for memory savings
# http://rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
preload_app true

GC.respond_to?(:copy_on_write_friendly=) &&
  GC.copy_on_write_friendly = true

# Enable this flag to have unicorn test client connections by writing the
# beginning of the HTTP headers before calling the application.  This
# prevents calling the application for connections that have disconnected
# while queued.  This is only guaranteed to detect clients on the same
# host unicorn runs on, and unlikely to detect disconnects even on a
# fast LAN.
check_client_connection false

# local variable to guard against running a hook multiple times
run_once = true

before_fork do |server, worker|
  # The following is only recommended for memory/DB-constrained
  # installations.  It is not needed if your system can house
  # twice as many worker_processes as you have configured.

  # This allows a new master process to incrementally
  # phase out the old master process with SIGTTOU to avoid a
  # thundering herd (especially in the "preload_app false" case)
  # when doing a transparent upgrade.  The last worker spawned
  # will then kill off the old master process with a SIGQUIT.
  if is_production
    old_pid = "#{server.config[:pid]}.oldbin"
    if File.exist?(old_pid) && server.pid != old_pid
      begin
        sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
        Process.kill(sig, File.read(old_pid).to_i)
      rescue Errno::ENOENT, Errno::ESRCH
        puts 'Someone else did our job for us: kill the old master process'
      end
    end
  end

  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  # Throttle the master from forking too quickly by sleeping.  Due
  # to the implementation of standard Unix signal handlers, this
  # helps (but does not completely) prevent identical, repeated signals
  # from being lost when the receiving process is busy.
  # sleep 1
end

after_fork do |_, _|
  # per-process listener ports for debugging/admin/migrations
  # addr = "127.0.0.1:#{9293 + worker.nr}"
  # server.listen(addr, :tries => -1, :delay => 5, :tcp_nopush => true)

  # if preload_app is true, then you may also want to check and
  # restart any other shared sockets/descriptors such as Memcached,
  # and Redis.  TokyoCabinet file handles are safe to reuse
  # between any number of forked children (assuming your kernel
  # correctly implements pread()/pwrite() system calls)

  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to sent QUIT'
  end
end
