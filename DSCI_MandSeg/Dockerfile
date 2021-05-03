FROM ubuntu:latest

RUN mkdir /app
WORKDIR /app

# Matlab runtime 9.8
RUN apt-get update
RUN apt-get install -y wget unzip libxt-dev openjdk-8-jdk
RUN echo -e '\n31\n1\n' | apt-get install -y xserver-xorg
RUN mkdir matlab_install matlab
RUN wget https://ssd.mathworks.com/supportfiles/downloads/R2020a/Release/5/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2020a_Update_5_glnxa64.zip && \
    unzip MATLAB_Runtime_R2020a_Update_5_glnxa64.zip -d matlab_install
RUN /app/matlab_install/install -mode silent -agreeToLicense yes -destinationFolder /app/matlab
RUN rm -rf MATLAB_Runtime_R2020a_Update_5_glnxa64.zip && \
    rm -rf MATLAB_Runtime_R2020a_Update_5_glnxa64

# Python 3.7
RUN apt-get update && \
apt-get install -y python3.7 && \
apt-get install -y python3-pip && \
pip3 install tensorflow Pillow

COPY ./unet_model_XV_5_20.hdf5 .
RUN mkdir /app/src
WORKDIR /app/src
COPY ./src/ .

RUN chmod +x ./main.sh 
RUN chmod +x ./main1
RUN chmod +x ./main2
RUN chmod +x ./run_main1.sh
RUN chmod +x ./run_main2.sh 

