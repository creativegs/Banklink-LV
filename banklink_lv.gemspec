# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "banklink_lv/version"

Gem::Specification.new do |s|
  s.name = "banklink_lv"
  s.version = BanklinkLv::VERSION
  s.author = "Arturs Braucs"
  s.email = "arturs.braucs@gmail.com"
  s.homepage = "https://github.com/CreativeMobile/Banklink-LV"
  s.platform = Gem::Platform::RUBY
  s.summary = "Banklink integration in your website without active merchant (Latvia)"
  s.require_path = "lib"
  s.has_rdoc = false
  s.extra_rdoc_files = ["README"]
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end