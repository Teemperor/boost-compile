#! /usr/bin/ruby

File.open(ARGV[0], "r").read.each_line do |line|
  prefix = "boost-compile/"
  if line[0,5].count('.') <= 2 and line =~ %r(#{prefix}(.*?)$)
    name = $1
    if /ifn?def/ !~ File.read(name)
      print name + " "
    end
  end
end
