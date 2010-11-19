# Maintainer: meh. <meh@paranoici.org>

Packo::Package.new('system/applications/coreutils', '8.6') {
  arch     '~x86', '~amd64'
  kernel   'linux'
  compiler 'gcc'
  libc     'glibc'
}