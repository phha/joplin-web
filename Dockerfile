# Pull base image.
FROM jlesage/baseimage-gui:debian-10

# Define arguments
ARG JOPLIN_VERSION=2.5.12
ARG JOPLIN_URL=https://github.com/laurent22/joplin/releases/download/v${JOPLIN_VERSION}/Joplin-${JOPLIN_VERSION}.AppImage
ARG APP_ICON_URL=https://joplinapp.org/images/Icon512.png

# Install runtime reqs
RUN add-pkg libnss3 libasound2 libgbm1 libgtk-3-0 libatk-bridge2.0 libatk1.0

# Install joplin
WORKDIR /app
RUN \
    add-pkg curl && \
    curl -# -L -o Joplin.AppImage "$JOPLIN_URL" && \
    chmod a+x Joplin.AppImage && \
    ./Joplin.AppImage --appimage-extract && \
    mv squashfs-root joplin && \
    chmod 755 joplin && \
    chmod a+x joplin/AppRun && \
    rm /app/Joplin.AppImage && \
    chown $USER_ID:$GROUP_ID /app -R && \
    chown root joplin/chrome-sandbox && \
    chmod 4755 joplin/chrome-sandbox && \
    del-pkg curl

# Install app icon
RUN install_app_icon.sh "$APP_ICON_URL"

# Copy files
COPY rootfs/ /

# Set the name of the application.
ENV APP_NAME="Joplin"

# Define mountable directories.
VOLUME ["/config"]
