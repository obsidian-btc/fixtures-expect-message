# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'fixtures-expect_message'
  s.version = '0.2.0.0.pre1'
  s.summary = 'Expect message fixture'
  s.description = ' '

  s.authors = ['Obsidian Software, Inc']
  s.email = 'developers@obsidianexchange.com'
  s.homepage = 'https://github.com/obsidian-btc/fixtures-expect-reply'
  s.licenses = ['Not licensed for public use']

  s.require_paths = ['lib']
  s.files = Dir.glob('{lib}/**/*')
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.2.3'
  s.bindir = 'bin'

  s.add_runtime_dependency 'evt-messaging-event_store'
end
