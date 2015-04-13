ser nginx;
worker_processes 1;
error_log /var/log/nginx/error.log;
pid /var/runfer_name localhost;
    location / {
      root /usr/share/nginx/html;
      index index.html index.htm;
    }
  }
}
