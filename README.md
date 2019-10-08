# docker-ansible-bundled
Ansible Core 2.8.x and Tower 3.5.3 for el7 in a Docker container

# Run immediately (no clone)
```
docker pull asubowo/docker-ansible-bundled
```

# Build
1. Change directory to directory root where the contents of this repository are located
  ```
  docker-ansible-bundled
      |_ Dockerfile
      |_ inventory
      |_ init-tower.sh
  ```
2. Run the build
  ```
  docker build . -t asubowo/ansible-bundled:3.5.3 
  ```
  
# Create a Tower DB volume (optional)
To persist the Tower database, create a Docker volume
```
docker volume create tower-data
```

# Run parameters

Add this flag to persist the `/var/lib/awx/projects/` directory or to map it somewhere on your host OS. If the directory on the host OS does not exist, Docker will create it for you.
```
-v ~/ansible_projects:/var/lib/awx/projects
```

Add this flag to persist the Tower database.
```
-v tower-data:/var/lib/postgresql/9.6/main
```

Add this flag to map your Tower certs and license directory to `/license_and_certs` inside the container.
```
-v <path_to_your_directory_containing_certs_and_license>:/license_and_certs
```

If you're looking to do everything above, your run command may look similar to the following:
```
docker run -d -p 443:443 ~/ansible_projects:var/lib/awx/projects -v tower-data:/var/lib/postgresql/9.6/main -v ~/tower_stuff:/license_and_certs --name ansible-bundled asubowo/ansible-bundled:3.5.3
```

# Appendix
If you're running CentOS 7+ as your base image, you may want to disable Bubblewrap. Otherwise you may see namespace issues when attempting to run jobs in Tower. To do this, log into Tower, navigate to *Settings > Jobs* and disable "Job Isolation"

# Login
URL: https://localhost:443

Username: admin

Password: changeme
