from logging.config import fileConfig


def post_fork(server, worker):
    fileConfig("development.ini")
