# Additional Documentation

This section is for additional documentation.

# Start SSH container

For testing purposes start a container and connect to it via SSH.

    docker create samrocketman/gimp-unstable | xargs docker start | xargs docker inspect -f "{{ .NetworkSettings.IPAddress }}"

SSH to container IP.

    ssh -l root -i docker-gimp-unstable/insecure_key 172.17.0.2
