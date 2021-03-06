maintainer  'shura <shura1991@gmail.com>'

use Modules::Building::CMake

name 'zlib'
tags 'library', 'system', 'compression'

description 'Standard (de)compression library'
homepage    'http://www.zlib.net/'
license     'ZLIB'

source 'http://zlib.net/zlib-#{version}.tar.gz'

autotools.force!

before :configure do |conf|
	conf.delete :other, [:sharedstatedir, :host, :build, :target]
end

before :compile do |conf|
	if host == '*-mingw*' || host == 'mingw*' || host == '*cygwin*'
		autotools.make '-f', 'win32/Makefile.gcc', "prefix=/usr/", 'STRIP=', "PREFIX=#{host}-"

		skip
	end
end
