FROM ubuntu

WORKDIR /home/eth


RUN apt update
RUN apt -y upgrade

RUN apt -y install curl
RUN apt -y install apt-utils

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt -y install build-essential
RUN apt-get install -y nodejs
RUN apt --assume-yes install git

RUN npm install -g --unsafe-perm \
    truffle \
    @angular/cli \
    ganache-cli

RUN git clone https://github.com/regig4/ethereum.git

RUN cd ethereum/client && npm install 

EXPOSE 4200
EXPOSE 8545

CMD [ "/home/eth/ethereum/start.sh" ]

