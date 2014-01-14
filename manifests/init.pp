class jdk{
  package { 'java-1.7.0-openjdk':
        ensure => 'installed',
        provider => 'yum'
  }
}
class elasticsearch ( 
  $es_version = "0.90.10"
  $es_download_root = "https://download.elasticsearch.org/elasticsearch/elasticsearch/"
  $es_install_location = "/usr/local/share"
){
  require jdk

  # GLOBAL PATH SETTING
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

  $es_filename = "elasticsearch-${es_version}.tar.gz"
  $es_package_url = "${es_download_root}/${es_filename}"

  exec { 'download ES package':
        command => "wget ${es_package_url} -O /tmp/elasticsearch.tar.gz",
        creates => "/tmp/elasticsearch.tar.gz"
  }
  ->
  exec{ 'unzip elasticesearch':
        command => "tar -xzvf /tmp/elasticsearch.tar.gz",
        cwd => "/tmp"
  }
  ->
  exec{ 'rename folder':
        command => "mv /tmp/elasticsearch-* /tmp/elasticsearch"
  }
  exec{ 'move to install location':
        command => "mv /tmp/elasticsearch ${es_install_location}"
  }
  ->
  exec{'get service wrapper':
        command => "curl -L http://github.com/elasticsearch/elasticsearch-servicewrapper/tarball/master | tar -xz",
        cwd => "/tmp"
  }
  ->
  exec{'move to destination':
        command => "mv /tmp/*servicewrapper*/service ${es_install_location}/elasticsearch/bin/"
  }
  ->
  exec{ 'install elasticsearch':
        command => "${es_install_location}/elasticsearch/bin/service/elasticsearch install"
  }

}
