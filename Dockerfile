FROM ubuntu

ENV SOMETHING=this

# Run the Update
RUN apt-get update && apt-get upgrade -y

ENTRYPOINT ["bash"]
