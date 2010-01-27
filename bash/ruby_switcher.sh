export ORIGINAL_PATH=$PATH

function use_leopard_ruby {
 export MY_RUBY_HOME=/System/Library/Frameworks/Ruby.framework/Versions/Current/usr
 export GEM_HOME=~/.gem/ruby/1.8
 export GEM_PATH=~/.gem/ruby/1.8:/Library/Ruby/Gems/1.8:/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8
 export RUBY_VER=leopard_ruby
 update_path
}


function use_jruby {
 export JRUBY_HOME=~/.ruby_versions/jruby-1.3.1
 export JRUBY_GEM_PATH=~/.gem/jruby/1.8
 export JRUBY_GEM_HOME=~/.gem/jruby/1.8
 export MY_RUBY_HOME=$JRUBY_HOME
 export GEM_HOME=$JRUBY_GEM_HOME
 export GEM_PATH=$JRUBY_GEM_PATH
 export RUBY_VER=jruby
 export INCLUDE_JRUBY=false
 alias ruby_ng="jruby --ng"
 alias ruby_ng_server="jruby --ng-server"
 update_path
}

function install_jruby {
  mkdir -p ~/.ruby_versions && pushd ~/.ruby_versions &&
  curl -O -L --silent http://dist.codehaus.org/jruby/1.3.1/jruby-bin-1.3.1.zip &&
  rm -rf jruby-1.3.1 &&
  jar xf jruby-bin-1.3.1.zip &&
  ln -sf ~/.ruby_versions/jruby-1.3.1/bin/jruby ~/.ruby_versions/jruby-1.3.1/bin/ruby &&
  ln -sf ~/.ruby_versions/jruby-1.3.1/bin/jgem ~/.ruby_versions/jruby-1.3.1/bin/gem   &&
  ln -sf ~/.ruby_versions/jruby-1.3.1/bin/jirb ~/.ruby_versions/jruby-1.3.1/bin/irb &&
  chmod +x ~/.ruby_versions/jruby-1.3.1/bin/{jruby,jgem,jirb,jrubyc} &&
  cd ~/.ruby_versions/jruby-1.3.1/tool/nailgun && make &&
  rm -rf ~/.ruby_versions/jruby-bin-1.3.1.zip &&
  use_jruby && install_jruby_openssl && install_rake &&
  popd
}

function use_jruby_120 {
 export MY_RUBY_HOME=~/.ruby_versions/jruby-1.2.0
 export GEM_HOME=~/.gem/jruby/1.8
 export RUBY_VER=jruby1.2
 export GEM_PATH=~/.gem/jruby/1.8
 update_path
}

function install_jruby_120 {
  mkdir -p ~/.ruby_versions && pushd ~/.ruby_versions &&
  curl -O -L --silent http://dist.codehaus.org/jruby/1.2.0/jruby-bin-1.2.0.zip &&
  rm -rf jruby-1.2.0 &&
  jar xf jruby-bin-1.2.0.zip &&
  ln -sf ~/.ruby_versions/jruby-1.2.0/bin/jruby ~/.ruby_versions/jruby-1.2.0/bin/ruby &&
  ln -sf ~/.ruby_versions/jruby-1.2.0/bin/jgem ~/.ruby_versions/jruby-1.2.0/bin/gem   &&
  ln -sf ~/.ruby_versions/jruby-1.2.0/bin/jirb ~/.ruby_versions/jruby-1.2.0/bin/irb &&
  chmod +x ~/.ruby_versions/jruby-1.2.0/bin/{jruby,jgem,jirb} &&
  rm -rf ~/.ruby_versions/jruby-bin-1.2.0.zip &&
  use_jruby_120 && install_jruby_openssl && install_rake &&
  popd
}

function install_llvm_for_macruby {
  # Based on the tutorial at http://redartisan.com/2009/9/1/macruby-intro
  export UNIVERSAL=1
  export UNIVERSAL_ARCH="i386 x86_64"
  export ENABLE_OPTIMIZED=1
  echo 'Building LLVM may take about 45 minutes'
  mkdir -p ~/.ruby_versions/macruby/src && pushd ~/.ruby_versions/macruby/src &&
  ((pushd llvm && git fetch origin && popd) || git clone git://repo.or.cz/llvm.git llvm) &&
  cd llvm &&
  git checkout ebe2d0079b086caa4d68ea9b63397751e4df6564 &&
  ./configure --prefix=$HOME/.ruby_versions/macruby &&
  make &&
  env UNIVERSAL=1 UNIVERSAL_ARCH="i386 x86_64" ENABLE_OPTIMIZED=1 make install &&
  popd
}

function install_macruby {
  # Based on the tutorial at http://redartisan.com/2009/9/1/macruby-intro
  use_leopard_ruby &&
  install_llvm_for_macruby &&
  pushd ~/.ruby_versions/macruby/src &&
  ((pushd macruby && git fetch origin && popd) || git clone git://git.macruby.org/macruby/MacRuby.git macruby) &&
  cd macruby &&
  env PATH=~/.ruby_versions/macruby:$ORIGINAL_PATH rake &&
  sudo rake install &&
  setup_macruby_env &&
  use_macruby &&
  popd
}

function setup_macruby_env {
  mkdir -p ~/.ruby_versions/macruby/bin &&
  mkdir -p ~/.gem/macruby/1.9.1 &&
  pushd ~/.ruby_versions/macruby/bin &&
  echo "`which macruby` \$*" > ruby && chmod +x ruby &&
  echo "`which macrake` \$*" > rake && chmod +x rake &&
  echo "`which macirb` \$*" > irb && chmod +x irb &&
  echo "`which macri` \$*" > ri && chmod +x ri &&
  echo "`which macerb` \$*" > erb && chmod +x erb &&
  echo "`which macrdoc` \$*" > rdoc && chmod +x rdoc &&
  echo "`which mactestrb` \$*" > testrb && chmod +x testrb &&
  echo "`which macgem` \$*" > gem && chmod +x gem &&
  popd
}

function use_macruby {
  export MY_RUBY_HOME=~/.ruby_versions/macruby
  export GEM_HOME=~/.gem/macruby/1.9.1
  export GEM_PATH=~/.gem/macruby/1.9.1
  export RUBY_VER=macruby
  update_path
}

#function use_ree_186 {
# export MY_RUBY_HOME=~/.ruby_versions/ruby-enterprise-1.8.6-20090610
# export GEM_HOME=~/.gem/ruby-enterprise/1.8
# export GEM_PATH=~/.gem/ruby-enterprise/1.8
# update_path
#}

function install_ree_186 {
  echo "Clearing RUBYOPT environment variable. Was set to '$RUBYOPT'."
  export RUBYOPT=

  mkdir -p ~/tmp && mkdir -p ~/.ruby_versions &&
  pushd ~/tmp
  curl --silent -L -O http://rubyforge.org/frs/download.php/58677/ruby-enterprise-1.8.6-20090610.tar.gz &&
  tar xzf ruby-enterprise-1.8.6-20090610.tar.gz &&
  cd ruby-enterprise-1.8.6-20090610 &&
  ./installer -a $HOME/.ruby_versions/ruby-enterprise-1.8.6-20090610 --dont-install-useful-gems &&
  cd ~/tmp &&
  rm -rf ~/tmp/ruby-enterprise-1.8.6-20090610 ruby-enterprise-1.8.6-20090610.tar.gz &&
  use_ree_186 && install_rubygems_from_source "1.3.5" && install_rake &&
  popd
}

function use_ree_187 {
  export MY_RUBY_HOME=~/.ruby_versions/ruby-enterprise-1.8.7-2009.10
  export GEM_HOME=~/.gem/ruby/1.8.7 
  export GEM_PATH=~/.gem/ruby/1.8.7 
  update_path 
}

function install_ree_187 {
  mkdir -p ~/tmp && mkdir -p ~/.ruby_versions && pushd ~/tmp 
  curl --silent -L -O http://rubyforge.org/frs/download.php/66162/ruby-enterprise-1.8.7-2009.10.tar.gz && 
  tar xzf ruby-enterprise-1.8.7-2009.10.tar.gz && cd ruby-enterprise-1.8.7-2009.10 && 
  ./installer -a $HOME/.ruby_versions/ruby-enterprise-1.8.7-2009.10 --dont-install-useful-gems && 
  cd ~/tmp && rm -rf ~/tmp/ruby-enterprise-1.8.7-2009.10 ruby-enterprise-1.8.7-2009.10.tar.gz && 
  use_ree_187 && install_rake && 
  popd
}

function use_ruby_191 {
 export MY_RUBY_HOME=~/.ruby_versions/ruby-1.9.1-p243
 export GEM_HOME=~/.gem/ruby/1.9.1
 export GEM_PATH=~/.gem/ruby/1.9.1
 export RUBY_VER=1.9.1
 export INCLUDE_JRUBY=false
 update_path
}

function use_ruby_191_and_jruby {
 use_jruby
 use_ruby_191
 export RUBY_VER=1.9.1+jruby
 export INCLUDE_JRUBY=true
 update_path
}

function install_ruby_191 {
  install_ruby_from_source "1.9" "1" "243" &&
  use_ruby_191 && install_rubygems_from_source "1.3.5" && install_rake && popd
}


#function use_ruby_186 {
# export MY_RUBY_HOME=~/.ruby_versions/ruby-1.8.6-p369
# export GEM_HOME=~/.gem/ruby/1.8
# export GEM_PATH=~/.gem/ruby/1.8
# update_path
#}

#function install_ruby_186 {
#  install_ruby_from_source "1.8" "6" "369" &&
#  use_ruby_186 && install_rubygems_from_source "1.3.5" && install_rake && popd
#}

function use_ruby_187_and_jruby {
 use_jruby
 use_ruby_187
 export RUBY_VER=1.8.7+jruby
 export INCLUDE_JRUBY=true
 update_path
}

function use_ruby_187 {
 export MY_RUBY_HOME=~/.ruby_versions/ruby-1.8.7-p174
 export GEM_HOME=~/.gem/ruby/1.8.7
 export GEM_PATH=~/.gem/ruby/1.8.7
 export RUBY_VER=1.8.7
 export INCLUDE_JRUBY=false
 update_path
}

function install_ruby_187 {
  install_ruby_from_source "1.8" "7" "174" &&
  use_ruby_187 && install_rubygems_from_source "1.3.5" && install_rake && popd
}

function install_ruby_from_source {
  local ruby_major=$1
  local ruby_minor=$2
  local patch_level=$3
  local ruby_version="ruby-$1.$2-p$patch_level"
  local url="ftp://ftp.ruby-lang.org/pub/ruby/$ruby_major/$ruby_version.tar.gz"

  mkdir -p ~/tmp && mkdir -p ~/.ruby_versions && rm -rf ~/.ruby_versions/$ruby_version &&
  pushd ~/tmp &&
  curl --silent -L -O $url &&
  tar xzf $ruby_version.tar.gz &&
  cd $ruby_version &&
  ./configure --prefix=$HOME/.ruby_versions/$ruby_version --enable-shared &&
  make && make install && cd ~/tmp &&
  rm -rf $ruby_version.tar.gz $ruby_version
}

function install_rubygems_from_source {
    local rubygems_version="rubygems-$1"
    local url="http://files.rubyforge.vm.bytemark.co.uk/rubygems/$rubygems_version.tgz"

    mkdir -p ~/tmp &&
    pushd ~/tmp &&
    curl --silent -L -O $url &&
    tar xzf $rubygems_version.tgz &&
    cd $rubygems_version &&
    ruby setup.rb -q && cd ~/tmp &&
    rm -rf $rubygems_version.tgz $rubygems_version &&
    popd
}

function install_rake {
  gem install -q --no-ri --no-rdoc rake
}

function install_jruby_openssl {
  gem install -q --no-ri --no-rdoc jruby-openssl
}

function update_path {
  if [[ $INCLUDE_JRUBY == "true" ]]; then
    echo "including jruby"
    export GEM_PATH=$GEM_PATH:$JRUBY_GEM_PATH
    export PATH=$GEM_HOME/bin:$MY_RUBY_HOME/bin:$JRUBY_GEM_HOME/bin:$JRUBY_HOME/bin:$ORIGINAL_PATH
  else
    export PATH=$GEM_HOME/bin:$MY_RUBY_HOME/bin:$ORIGINAL_PATH
  fi
  export RUBY_VERSION="$(ruby -v | colrm 11)"
  display_ruby_version
}

function display_ruby_version {
 if [[ $SHELL =~ "bash" ]]; then
   echo "Using `ruby -v`"
 fi
 # On ZSH, show it on the right PS1
 export RPS1=$RUBY_VERSION
}

use_ruby_191
