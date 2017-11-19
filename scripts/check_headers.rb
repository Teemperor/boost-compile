#! /usr/bin/ruby

File.open(ARGV[0], "r").read.each_line do |line|
  prefix = "boost-compile/"
  if line[0,5].count('.') <= 2 and line =~ %r(#{prefix}(.*?)$)
    filename = $1
    if /ifdef/ !~ File.read(filename)
      subdir = $1 if %r(inc/boost/(.*?)/) =~ filename
      if subdir
        modulename = "boost_" + subdir
        File.open("/home/yuka/dev/oldmodulemap","r").each_line do |moduleline|
          File.open("inc/boost/module.modulemap", "a") do |newmoduleline|
            if moduleline.include? modulename
              newmoduleline.puts(moduleline)
              longsubdir = $1 if %r(inc/boost/(.*?)$) =~ filename
              newmoduleline.puts("module \"" + longsubdir.gsub(/\//, "__") + "\" { header \"" + longsubdir + "\" export * }")
              #print "module \"" + longsubdir.gsub(/\//, "__") + "\" { header \"" + longsubdir + "\" export * }"
            else
              newmoduleline.puts(moduleline)
            end
          end
        end
      end
    end
  end
end
