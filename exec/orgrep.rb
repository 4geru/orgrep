#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))
require 'orgrep'
Orgrep.run(ARGV)