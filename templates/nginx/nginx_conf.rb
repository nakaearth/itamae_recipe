user nginx;
worker_processes 1;
error_log <%= @error_log_path %>;
pid  /var/run/nginx.pid;
events {
    worker_connections  1024;
    multi_accept on;
}
