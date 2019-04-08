# Service Desk Jira, Confluence, with postgress and traefik configuration

- postgres / adminer
- NFS volumes
- confluence with synchrony
- traefik reverse proxy labels


## This is a very custom deployment but I hope it can help people starting up with confluence/servicedesk with docker swarm (or compose) environment.

This requires a traefik instance to be running in the swarm network. (obviously) or setup our own reverse proxy but then what's the point ?
I've included my very custom gitlab-ci file but it's really here for my own use. 


You need a couple environment variables (or replace them in the config files) before deploying :

CI_PROJECT_NAME (it is 'servicedesk')  I use project names to deploy the main service url in traefik in my environment. use anything you like.
NFS_HOST : ip or host for nfs server
NFS_ROOT : the base root folder for the NFS service
JIRA_DEV_DOMAIN (or JIRA_DOMAIN) : the domain name in which your services are deployed


# After deploying the service, execute the following queries in postgres:

create user jirauser with encrypted password 'dockertest';
CREATE DATABASE servicedesk WITH ENCODING 'UNICODE' LC_COLLATE 'C' LC_CTYPE 'C' TEMPLATE template0;
grant all privileges on database servicedesk to jirauser;

# Setup your instance like normal, and add a link to confluence.(yourdomain)


# TODO : 
    -   custom image with a symbolic link to a folder that is not in the NFS for indexes (cache)
    -   you are supposed to store postgres password in a secret for the production deployment
    -   add DB config for confluence (you need a licence to set it up with a production database, as opposed to servicedesk, which can be used directly with dedicated database. why this Atlassian ?)