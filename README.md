# Smart Proxy Tail plugin

Tails specified log files, filters via regular expression and sends the
result into Smart Proxy logs buffer.

Implementation is via separate thread that catches up with opened file handles rather than via inotify to avoid new dependency.

## Usage

Enable the plugin and configure regexp pattern and input files

## Testing

To tests the regular expression on live data, use the helper binary:

    smart-proxy-tail '(ERR|Error|error|FATAL|fatal|Exception)' httpd /var/log/httpd/error_log httpd /var/log/httpd/foreman_error.log httpd /var/log/httpd/foreman-ssl_error_ssl.log puppet /var/log/puppet/masterhttp.log
