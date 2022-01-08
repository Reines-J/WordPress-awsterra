#ssh-keygen -t rsa -b 4096 -C "smu05186@naver.com" -f "/mnt/c/Users/Khung/Desktop/terraform/terra-key" -N ""

resource "aws_key_pair" "terra-key" {
    key_name = "terra-key"
    public_key = file("/mnt/c/Users/khung/Desktop/terraform/terra-key.pub")
    tags = { Name = "terra-key"}
  
}

resource "aws_instance" "terra-wp" {
  ami = "ami-0b827f3319f7447c6"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.wp_pub1.id
  iam_instance_profile = aws_iam_instance_profile.ec2-s3.name
  key_name = aws_key_pair.terra-key.key_name
  instance_initiated_shutdown_behavior = "terminate"
  vpc_security_group_ids = [aws_security_group.wp-sg.id]
  tags = {Name = "terra-wp"} 
  
  user_data = <<-EOF
    #!/bin/bash
    amazon-linux-extras install lamp-mariadb10.2-php7.2 php7.2 -y
    yum install httpd htop amazon-efs-utils tree -y
    systemctl start httpd && systemctl enable httpd
    yum install gcc php-xml php-mbstring php-sodium php-devel php-pear ImageMagick-devel ghostscript -y
    cat <<EOT> /etc/php.d/40-imagick.ini
    extension = imagick.so
    EOT
    printf "\n" | pecl install imagick
    sed -i 's/^upload_max_filesize = 2M/upload_max_filesize = 64M/g' /etc/php.ini
    sed -i 's/^post_max_size = 8M/post_max_size = 64M/g' /etc/php.ini
    sed -i 's/^max_execution_time = 30/max_execution_time = 300/g' /etc/php.ini
    sed -i 's/^memory_limit = 128M/memory_limit = 256/g' /etc/php.ini
    wget https://ko.wordpress.org/wordpress-latest-ko_KR.zip
    unzip wordpress-latest-ko_KR.zip
    cp wordpress/wp-config-sample.php wordpress/wp-config.php
    sed -i "s/username_here/root/g" wordpress/wp-config.php
    sed -i "s/password_here/qwe12345/g" wordpress/wp-config.php
    cat <<EOT>> wordpress/wp-config.php
    define('WP_MEMORY_LIMIT', '256M');
    EOT
    mkdir -p /var/www/wordpress/
    mount -t efs ${aws_efs_file_system.terra-efs.id}:/ /var/www/wordpress
    cp -r wordpress/* /var/www/wordpress/
    chown -R apache:apache /var/www
    chmod 2775 /var/www
    find /var/www -type d -exec chmod 2775 {} \;
    find /var/www -type f -exec chmod 0664 {} \;
    chmod u+wrx /var/www/wordpress/wp-content/*
    echo 'ServerName 127.0.0.1:80' >> /etc/httpd/conf.d/MyBlog.conf
    echo 'DocumentRoot /var/www/wordpress' >> /etc/httpd/conf.d/MyBlog.conf
    echo '<Directory /var/www/wordpress>' >> /etc/httpd/conf.d/MyBlog.conf
    echo '  Options Indexes FollowSymLinks' >> /etc/httpd/conf.d/MyBlog.conf
    echo '  AllowOverride All' >> /etc/httpd/conf.d/MyBlog.conf
    echo '  Require all granted' >> /etc/httpd/conf.d/MyBlog.conf
    echo '</Directory>' >> /etc/httpd/conf.d/MyBlog.conf
    systemctl restart php-fpm
    systemctl restart httpd
    sed -i "s/localhost/${aws_db_instance.terra-rds.endpoint}/g" /var/www/wordpress/wp-config.php
    sed -i "s/database_name_here/${aws_db_instance.terra-rds.name}/g" /var/www/wordpress/wp-config.php
    umount /var/www/wordpress
    echo "${aws_efs_file_system.terra-efs.id}:/ /var/www/wordpress efs _netdev,noresvport,tls,iam 0 0" >> /etc/fstab
    mount -fav
    reboot
    
  EOF
}

resource "aws_eip_association" "terra-eip" {
  instance_id = aws_instance.terra-wp.id
  allocation_id = aws_eip.terra-eip.id
}

#resource "aws_ebs_volume" "terra-wp" {
#    availability_zone = "ap-northeast-2a"
#    type = "gp2"
#    size = "10"
#    tags = {Name = "terra-wp"}
#}

#resource "aws_volume_attachment" "terra-wp" {
#  device_name = "/dev/sda1"
#  volume_id = aws_ebs_volume.terra-wp.id
#  instance_id = aws_instance.terra-wp.id
#}
