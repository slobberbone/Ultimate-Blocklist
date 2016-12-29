FROM python:2-onbuild

# map /config to host defined blockList.txt file path
VOLUME /config

ADD ./UpdateList.sh /UpdateList.sh
RUN chmod u+x  /UpdateList.sh

RUN echo "0 * * * * root 0 * * * * ./UpdateList.sh -c /config >> /var/log/UpdateList.log 2>&1"

EXPOSE 80

CMD [ "python", "./UltimateBlockList.py" ]

CMD ["/UpdateList.sh"]

# Add crontab file in the cron directory
ADD crontab /etc/cron.d/UpdateList
 
# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/UpdateList
 
# Create the log file to be able to run tail
RUN touch /var/log/UpdateList.log
 
# Run the command on container startup
CMD cron && tail -f /var/log/UpdateList.log
