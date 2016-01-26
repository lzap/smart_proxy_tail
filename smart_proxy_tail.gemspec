require File.expand_path('../lib/smart_proxy_tail/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'smart_proxy_tail'
  s.version = Proxy::Tail::VERSION

  s.summary = 'Smart Proxy Tail plugin'
  s.description = 'Tails and greps specified files copying entries into Smart Proxy log buffer'
  s.authors = ['Lukas Zapletal']
  s.email = 'lukas-x@zapletalovi.com'
  s.extra_rdoc_files = ['README.md', 'LICENSE']
  s.files = Dir['{lib,settings.d,bundler.d}/**/*'] + s.extra_rdoc_files
  s.homepage = 'http://github.com/lzap/smart_proxy_tail'
  s.license = 'GPLv3'

  s.add_development_dependency('rake')
  s.add_development_dependency('rack')
end
