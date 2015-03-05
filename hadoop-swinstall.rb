#
# Cookbook Name:: vm-hadoop2
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#
#---------------------------------------------------------------------
#
# Hadoop software install recipe
#
# Create group hadoop
# Create user hadoop 
#
# Untar hadoop distribution
#
# Set environment variables in .bashrc of hadoop user
#
#---------------------------------------------------------------------

#Example of embedding bash code:
#bash 'install_something' do
  #user 'root'
  #cwd '/tmp'
  #code <<-EOH
  #wget http://www.example.com/tarball.tar.gz
  #tar -zxf tarball.tar.gz
  #cd tarball
  #EOH
#end

# Create group and user hadoop
group 'hadoop'

user 'hadoop' do

	comment 'Hadoop software owner'
	gid 'hadoop'
	home '/home/hadoop'
	shell '/bin/bash'
	password 'hadoop'

end

# Install hadoop software
bash 'install_hadoop' do
  user 'root'
  cwd '/usr/local'
  code <<-EOH
  tar -zxf /vagrant/hadoop-2.6.0.tar.gz
  dir=`ls -tr1 | grep hadoop| tail -1`
  chown -R hadoop:hadoop $dir
  rm -i hadoop
  ln -s $dir hadoop
  EOH
end

# Configure hadoop user's environment variables
bash 'config_hadoop_user_env' do
  user 'hadoop'
  cwd '/home/hadoop'
  code <<-EOH
  echo "export HADOOP_HOME=/usr/local/hadoop" >> .bashrc
  echo "export HADOOP_STREAMING=$HADOOP_HOME/share/hadoop/tools/lib/Hadoop-streaming-2.6.0.jar" >> .bashrc
  echo "export PATH=$PATH:$HADOOP_HOME/bin" >> .bashrc
  EOH
end
