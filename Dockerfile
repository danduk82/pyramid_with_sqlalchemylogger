FROM python:3.9-slim

# install certificates into local cert store
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates locales && \
    sed -i -e 's/# de_CH.UTF-8 UTF-8/de_CH.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=de_CH.UTF-8 && \
    update-ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Default to UTF-8 file.encoding and de_CH locale
ENV LANG de_CH.UTF-8
ENV LANGUAGE de_CH:en
ENV LC_ALL de_CH.UTF-8

# timezone setting
ENV TZ=Europe/Zurich
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


ARG PYTHON_DEV_PACKAGES="build-essential"
ARG DEV_PACKAGES="libpq-dev"
ARG PIP_OPTIONS=

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install --yes --no-install-recommends \
        ${PYTHON_DEV_PACKAGES} ${DEV_PACKAGES} && \
    apt-get clean && \
    rm --force --recursive /var/lib/apt/lists/*

WORKDIR /app
COPY requirements.txt /app/

RUN pip3 install ${PIP_OPTIONS} --disable-pip-version-check --no-cache-dir \
    --requirement requirements.txt \
    gunicorn PasteDeploy
	
COPY . .

RUN pip3 install ${PIP_OPTIONS} --disable-pip-version-check --no-cache-dir -e .
EXPOSE 8080
EXPOSE 6543


# Does not work with this setting
#CMD ["gunicorn", "--paste", "config/webserver.ini", "--config", "gunicorn_config.py", "--forwarded-allow-ips", "*", "-b 0.0.0.0:8080", "--worker-class", "gthread", "--threads", "10", "--workers", "1", "--timeout", "60", "--max-requests", "1000", "max-requests-jitter", "100", "--worker-tmp-dir", "/dev/shm", "--limit-request-line", "8190"]
#CMD ["gunicorn", "--config", "gunicorn_config.py", "--forwarded-allow-ips", "*", "-b 0.0.0.0:8080", "--worker-class", "gthread", "--threads", "10", "--workers", "1", "--timeout", "60", "--max-requests", "1000", "max-requests-jitter", "100", "--worker-tmp-dir", "/dev/shm", "--limit-request-line", "8190"]
#WORKS WITH THIS SETTING:

CMD ["gunicorn", "--paste", "development.ini", "--config", "gunicorn_config.py", "--forwarded-allow-ips", "*", "-b 0.0.0.0:8080", "--worker-class", "gthread", "--threads", "10", "--workers", "1", "--timeout", "60", "--max-requests", "1000", "max-requests-jitter", "100", "--worker-tmp-dir", "/dev/shm", "--limit-request-line", "8190"]
#CMD ["gunicorn", "--paste", "development.ini", "--forwarded-allow-ips", "*", "-b 0.0.0.0:8080", "--worker-class", "gthread", "--threads", "10", "--workers", "1", "--timeout", "60", "--max-requests", "1000", "max-requests-jitter", "100", "--worker-tmp-dir", "/dev/shm", "--limit-request-line", "8190", "--spew"]

#CMD ["sleep", "infinity"]
