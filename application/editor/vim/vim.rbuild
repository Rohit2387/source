Package.define('vim') {
  tags 'application', 'editor'

  description 'Vim, an improved vi-style text editor'
  homepage    'http://www.vim.org/'
  license     'vim'

  maintainer 'meh. <meh@paranoici.org>'

  source 'ftp://ftp.vim.org/pub/vim/unix/vim-#{package.version}.tar.bz2'

  features {
    ruby {
      before :configure do |conf|
        conf.enable 'rubyinterp', enabled?
      end
    }

    perl {
      before :configure do |conf|
        conf.enable 'perlinterp', enabled?
      end
    }

    mzscheme {
      before :configure do |conf|
        conf.enable 'mzschemeinterp', enabled?
      end
    }

    lua {
      before :configure do |conf|
        conf.enable 'luainterp', enabled?
      end
    }

    tcl {
      before :configure do |conf|
        conf.enable 'tclinterp', enabled?
      end
    }

    python {
      before :dependencies do |deps|
        deps << 'development/interpreter/python%2'
      end

      before :configure do |conf|
        conf.enable 'pythoninterp', enabled?
      end
    }

    python3 {
      before :dependencies do |deps|
        deps << 'development/interpreter/python%3'
      end

      before :configure do |conf|
        conf.enable 'python3interp', enabled?
      end
    }

    X {
      before :configure do |conf|
        conf.with 'x', enabled?
      end
    }

    gtk {
      needs 'X'

      before :configure do |conf|
        if enabled?
          conf.enable 'gtk2-check'
          conf.enable 'gui', 'gtk2'
        end
      end
    }

    gnome {
      needs 'X'

      before :configure do |conf|
        if enabled?
          conf.enable 'gtk2-check'
          conf.enable 'gui', 'gnome2'
        end
      end
    }

    netbeans {
      before :configure do |conf|
        conf.enable 'netbeans', enabled?
      end
    }

    cscope {
      before :dependencies do |deps|
        deps << 'development/utility/cscope'
      end
    }

    gpm {

    }
  }

  after :unpack do
    Do.cd "#{package.workdir}/vim#{package.version.major}#{package.version.minor}"
  end

  after :dependencies do |result, deps|
    deps.delete_if {|dep|
      dep.name == 'python' && !dep.slot
    }
  end

  # this fixes the configure, or it would be called during compile time
  before :configure do
    Do.rm  'src/auto/configure'
    Do.sed 'src/Makefile', [' auto.config.mk:', ':']

    autotools.make '-j1', '-C', 'src', 'autoconf'
  end

  before :configure do |conf|
    conf.with 'modified-by', 'Distrø'

    conf.with 'tlib', 'curses'

    if !(features.gtk.enabled? || features.gnome.enabled?)
      conf.enable 'gui', 'no'
    end
  end
}
