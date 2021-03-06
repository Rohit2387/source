maintainer 'meh. <meh@paranoici.org>'

name 'ncurses'
tags 'library', 'system', 'text', 'gnu'

description 'console display library'
homepage    'http://www.gnu.org/software/ncurses/', 'http://dickey.his.com/ncurses/'
license     'MIT'

source 'gnu://ncurses/#{version}'

features {
	cxx { enabled!
		before :configure do |conf|
			conf.with ['cxx', 'cxx-binding'], enabled?
		end
	}

	unicode { enabled!
		after :unpack do |result, file|
			next if !enabled?

			if !File.exists? "#{package.workdir}/ncursesw"
				FileUtils.cp_r "#{package.workdir}/ncurses-#{package.version}", "#{package.workdir}/ncursesw", :preserve => true
			end
		end

		after :compile do |result, conf|
			next if !enabled?

			conf = conf.clone

			conf.enable 'widec'
			conf.set 'includedir', '/usr/include/ncursesw'

			Dir.chdir "#{package.workdir}/ncursesw"

			package.autotools.configure(conf)
			package.autotools.make

			Dir.chdir "#{package.workdir}/ncurses-#{package.version}"
		end

		after :install do |result, conf|
			Dir.chdir "#{package.workdir}/ncursesw"

			package.autotools.install(package.distdir)
		end
	}

	gpm {
		before :dependencies do |deps|
			deps << 'system/library/gpm' if enabled?
		end

		before :configure do |conf|
			conf.with 'gpm', enabled?
		end
	}

	ada {
		before :configure do |conf|
			conf.with 'ada', enabled?
		end
	}
}

before :configure do |conf|
	conf.with ['shared', 'rcs-ids']
	conf.with 'manpage-format', 'normal'
	conf.without 'hashed-db'

	conf.enable ['symlinks', 'const', 'colorfgbg', 'echo']

	# ABI compatibility
	conf.with 'chtype', 'long'
	conf.with 'mmask-t', 'long'
	conf.disable ['ext-colors', 'ext-mouse']
	conf.without ['pthread', 'reentrant']
end

before :compile do
	autotools.make '-j1', 'sources'
end
