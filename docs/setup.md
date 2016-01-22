Setup and Configuration
-----------------------

1. Download this project and unzip OR git clone this onto your desktop.
```sh
git clone https://github.com/jbossdemocentral/fuse-file-transfer-hub-demo
```

2. Download JBoss Fuse and copy to installs directory

   http://www.jboss.org/products/fuse/download/

   >NOTE: more detail can be found in [README.md](../installs/README.md)

3. setup sftp access, update these login information in sample project.

   To setup sftp, following these command. Here we suppose "localhost" as sftp server and "test" as sftp userid.
   >NOTE: If your public/private rsa key pair already exists in ~/.ssh/id_rsa and your public rsa key already be copied to sftp Server, you can skip this step.

   ```sh
   ssh-keygen -t rsa
   ssh-copy-id -i .ssh/id_rsa.pub test@localhost
   ```

   To update login info, please run the script as below, 
   ```sh
   ./support/project/updateproperties.sh <SFTP_HOSTNAME> <SFTP_USER> <SFTP_PASSWORD>
   ```

   > NOTE: You can also edit property directly. ./projects/sample-fuse-file-transfer/src/main/resources/OSGI-INF/blueprint/properties.xml  

4. Run 'init.sh'

   >NOTE: Although our shell script has already started the FUSE server, if you need to manually start the server in the future, just run ./target/jboss-fuse-6.2.1.redhat-084/bin/start

5. Login to Fuse management console at: http://localhost:8181 (u:admin/p:admin).



Enjoy the demo!
