cd ~
sudo yum update
sudo yum install java-1.7.0-openjdk.i686 -y

wget https://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-0.19.9.tar.gz -O elasticsearch.tar.gz

tar -xf elasticsearch.tar.gz
rm elasticsearch.tar.gz
mv elasticsearch-* elasticsearch
sudo mv elasticsearch /usr/local/share

curl -L http://github.com/elasticsearch/elasticsearch-servicewrapper/tarball/master | tar -xz
mv *servicewrapper*/service /usr/local/share/elasticsearch/bin/
rm -Rf *servicewrapper*
sudo /usr/local/share/elasticsearch/bin/service/elasticsearch install
sudo /etc/init.d/elasticsearch start

