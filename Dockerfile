FROM cptactionhank/atlassian-jira-service-desk:4.0.2
USER root
RUN mkdir /cache

RUN ln -s /var/atlassian/jira/cache /cache
RUN chmod -R 700 /cache
RUN chown -R jira:jira /cache

USER 1000