FROM odoo:16.0

USER root

# Update and install required packages
RUN apt-get update -y && apt-get install -y \
    pkg-config gcc make build-essential libssl-dev libffi-dev python3-dev libcups2-dev python3-pip \
    && pip3 install --upgrade pip
#
# Clean up apt-get
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install Python packages
RUN pip3 install -U pip

# Create necessary directories and set permissions
RUN mkdir -p /etc/odoo /mnt/addons /var/lib/odoo/sessions && \
    chown -R odoo:odoo /var/lib/odoo /etc/odoo /var/lib/odoo/sessions

# Copy configuration files and custom addons
COPY ./configurations/dev/config/odoo.conf /etc/odoo
COPY ./addons /mnt/addons

# Switch to the odoo user
USER odoo

# Expose Odoo service port
EXPOSE 8069

# Define entrypoint
ENTRYPOINT ["odoo", "-c", "/etc/odoo/odoo.conf"]
