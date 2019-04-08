# Service Desk Jira, Confluence, with postgress and traefik configuration

- postgres / adminer
- NFS volumes
- confluence with synchrony
- traefik reverse proxy labels

## This is kind of custom deployment files for a separated prod and dev environments but I hope it can help people starting up with confluence/servicedesk with docker swarm (or compose with minor tweaks) with those products.

This requires a traefik instance to be running in the swarm network (obviously) or setup your own reverse proxy, and remove labels.
I've included my (very light) .gitlab-ci.yml file but it's really here for my own use. i'll probably make a blog post about how to setup a gitlab server with docker runners for a swarm environment in the future.

You need a couple environment variables (or replace them in the service config files) before deploying :

-   CI_PROJECT_NAME for me it's servicedesk : I use project names to deploy the main service url in traefik in my environment. use anything you like.
-   NFS_HOST : ip or host for nfs server
-   NFS_ROOT : the base root folder for the NFS service
-   JIRA_DEV_DOMAIN (or JIRA_DOMAIN for prod) : the domain name in which your services are deployed


## After deploying the service, execute the following queries in postgres:

create user jirauser with encrypted password 'yoursecretpassword';
CREATE DATABASE servicedesk WITH ENCODING 'UNICODE' LC_COLLATE 'C' LC_CTYPE 'C' TEMPLATE template0;
grant all privileges on database servicedesk to jirauser;

## after that, setup your instance like normal, and add an app link to 'confluence.(yourdomain)'

## lucene doesnt like NFS : 

So if you use NFS, you can use the dockerfile I've provided, and switch the image in the service definition, it builds an image with a symlinked folder inside the container, using the thin layer of the container to store the cache. It's sub-optimal as the cache will then be rebuilt at each run, but the only option to have a healthy cache right now. 

# TODO :

-   you are supposed to store postgres password in a secret for the production deployment
-   add DB config for confluence (you need a licence to set it up with a production database, as opposed to servicedesk, which can be used directly with dedicated database. why this Atlassian ?)

## To use: 

If you want tu use env vars with swarm you can do sth like:
export VARIABLE=VALUE && export .. && docker stack deploy jiraapps -c servicedesk_dev.yml

or

Just replace the ${VARs} in the stack files.

