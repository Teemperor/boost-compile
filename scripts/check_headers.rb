#! /usr/bin/ruby

File.open(ARGV[0], "r").read.each_line do |line|
  prefix = "boost-compile/"
  if line[0,5].count('.') <= 2 and line =~ %r(#{prefix}(.*?)$)
    name = $1
    if name.match(/#ifdef|#ifndef/) == nil
      p name
    end
  end
end
