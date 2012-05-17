#
# Cookbook Name:: glance
# Recipe:: load_images

include_recipe "#{@cookbook_name}::common"

package "curl"

image_list = node[:glance][:image_list]
if image_list then
  image_list.each do |img|
    bash "glance add: #{img[:name]}" do
      cwd "/tmp"
      user "root"
      code <<-EOH
        [ -f /root/openstackrc ] && source /root/openstackrc
        # wait for glance/keystone to come up
        COUNT=0
        until glance index; do
          COUNT=$(( $COUNT + 1  ))
          sleep 10 
          [ "$COUNT" -eq "36" ] && break
        done
        DIR=$(mktemp -d)
        curl #{img[:url]} -o $DIR/image
        if glance add name="#{img[:name]}" disk_format=#{img[:disk_format]} container_format=#{img[:container_format]} is_public=True --silent-upload < $DIR/image; then
            touch /var/lib/glance/chef_images_loaded
        fi
        rm $DIR/image
        rmdir $DIR
      EOH
      not_if do File.exists?("/var/lib/glance/chef_images_loaded") end
    end
  end
end

tty_linux_image = node[:glance][:tty_linux_image]
if tty_linux_image and not tty_linux_image.empty? then
  bash "glance add: tty linux" do
    cwd "/tmp"
    user "root"
    code <<-EOH
      mkdir -p /var/lib/glance/
      [ -f /root/openstackrc ] && source /root/openstackrc
      # wait for glance/keystone to come up
      COUNT=0
      until glance index; do
        COUNT=$(( $COUNT + 1  ))
        sleep 10 
        [ "$COUNT" -eq "36" ] && break
      done
      curl #{tty_linux_image} | tar xvz -C /tmp/
      ARI_ID=`glance add name="ari-tty" type="ramdisk" disk_format="ari" container_format="ari" is_public=true < /tmp/tty_linux/ramdisk | tail -n 1 | sed 's/.*\: //g'`
      AKI_ID=`glance add name="aki-tty" type="kernel" disk_format="aki" container_format="aki" is_public=true < /tmp/tty_linux/kernel | tail -n 1 | sed 's/.*\: //g'`
      if glance add name="ami-tty" type="kernel" disk_format="ami" container_format="ami" ramdisk_id="$ARI_ID" kernel_id="$AKI_ID" is_public=true < /tmp/tty_linux/image; then
          touch /var/lib/glance/chef_images_loaded
      fi
    EOH
    not_if do File.exists?("/var/lib/glance/chef_images_loaded") end
  end
end
