#! /usr/bin/ruby

File.open(ARGV[0], "r").read.each_line do |line|
  prefix = "boost-compile/inc/boost/"
  if line =~ %r(#{prefix}(.*?)$)
    if File.readlines("inc/boost/module.modulemap").grep($1).size == 0
      p $1
    end
  end
end
