tar -xz -C /opt -f /tmp/freesurfer-linux-ubuntu22_amd64-7.4.1.tar.gz
# rm /tmp/freesurfer-linux-ubuntu22_amd64-7.4.1.tar.gz
chown -R root:root /opt/freesurfer && chmod -R a+rx /opt/freesurfer
cat /opt/freesurfer/SetUpFreeSurfer.sh >> ~/.bashrc

export FREESURFER_HOME="/opt/freesurfer"
cp /tmp/fs_install_mcr /opt/freesurfer/bin/
cd /opt/freesurfer/bin/
RUN chmod +x /opt/freesurfer/bin/fs_install_mcr && /opt/freesurfer/bin/fs_install_mcr R2014b