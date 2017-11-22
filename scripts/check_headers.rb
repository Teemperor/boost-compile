#!/usr/bin/ruby
require 'fileutils'

modules = []
File.open(ARGV[0], "r").read.each_line do |line|
  if line[0,5].count('.') <= 2 and line =~ %r(#{"boost-compile/"}(.*?)$)
    filename = $1
    if /ifdef/ !~ File.read(filename) && %r(inc/boost/(.*?)/) =~ filename
      modules.push(["module boost_" + $1 + " {\n",filename])
    end
  end
end

modulepath = "inc/boost/module.modulemap"
modules.each {|m|
  tmp = "/tmp/module.modulemap"
  FileUtils.cp(modulepath, tmp)
  File.open(modulepath, "w") do |mm|
    File.open(tmp,"r").each_line do |line|
      if m[0] == line
        mm.puts(line)
        m[1].slice!(/inc\/boost\//)
        mm.puts("  module \"" + m[1].gsub(/\//, "__") + "\" { header \"" + m[1] + "\" export * }")
      else
        mm.puts(line)
      end
    end
  end
  res = `./scripts/run_travis.sh clang clang++ On 2> /tmp/error`
  p res
  if res.include? "Found all PCMS!"
    p m[1]
  end
  FileUtils.cp(tmp, modulepath)
}
