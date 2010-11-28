Package.define('sandbox') {
  behavior Behaviors::GNU

  maintainer 'meh. <meh@paranoici.org>'

  tags 'application', 'system'
  
  description "Gentoo's sandbox utility for more secure package building"
  homepage    'http://www.gentoo.org/'
  license     'GPL-2'

  source 'http://dev.gentoo.org/~vapier/dist/sandbox-#{package.version}.tar.xz'

  dependencies << 'application/archive/xz!' << 'application/utility/pax!'

  features {
    multilib {

    }
  }
}