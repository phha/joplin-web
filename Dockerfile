# Pull base image.
FROM jlesage/baseimage-gui:debian-10

ARG JOPLIN_VERSION=2.1.8
ARG JOPLIN_URL=https://github.com/laurent22/joplin/releases/download/v${JOPLIN_VERSION}/Joplin-${JOPLIN_VERSION}.AppImage
# ARG JOPLIN_URL=https://github.com/laurent22/joplin/archive/refs/tags/v${JOPLIN_VERSION}.zip
ARG APP_ICON_URL=https://joplinapp.org/images/Icon512.png

# Install build reqs
RUN add-pkg curl libnss3 libasound2 libgbm1 libgtk-3-0 libatk-bridge2.0 libatk1.0

# Copy the start script.
COPY rootfs/ /

# Install joplin
RUN mkdir /app
RUN chown $USER_ID:$GROUP_ID /app
USER $USER_ID
ENV HOME=/config
WORKDIR /app
RUN curl -# -L -o Joplin.AppImage "$JOPLIN_URL"
RUN chmod a+x Joplin.AppImage
RUN ./Joplin.AppImage --appimage-extract
RUN mv squashfs-root joplin
RUN chmod 755 joplin
RUN chmod a+x joplin/AppRun
USER 0
RUN chown root joplin/chrome-sandbox
RUN chmod 4755 joplin/chrome-sandbox

# Install app icon
RUN install_app_icon.sh "$APP_ICON_URL"

# Set the name of the application.
ENV APP_NAME="Joplin"

# Define mountable directories.
VOLUME ["/config"]

# Clean up
RUN del-pkg curl
