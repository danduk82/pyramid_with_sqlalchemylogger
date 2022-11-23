import logging
from .decorators import log_response, OerebStats

log = logging.getLogger(__name__)
from pyramid.response import Response
from pyramid.view import (
    view_config,
    notfound_view_config,
    view_defaults,
    exception_view_config,
)
from pyramid.httpexceptions import (
    HTTPBadRequest,
    HTTPNoContent,
    HTTPServerError,
    HTTPNotFound,
)


@view_defaults(renderer="home.pt", decorator=log_response)
class TutorialViews:
    def __init__(self, request):
        self.request = request

    @view_config(route_name="home")
    def home(self):
        log.debug("In home view")
        return {"name": "Home View"}

    @view_config(route_name="hello")
    def hello(self):
        log.debug("In hello view")
        return {"name": "Hello View"}


@notfound_view_config(decorator=log_response)
def notfound_get(request):
    return Response("Not Found", status="404 Not Found")


@exception_view_config(HTTPBadRequest, decorator=log_response)
def badrequest_get(request):
    return Response("Bad Request", status="400 Bad Request")


class Fail:
    def __init__(self, request):
        self.request = request

    @view_config(route_name="fail")
    def fail(self):
        raise Exception("this is a raised Exception!")


class BadRequest:
    def __init__(self, request):
        self.request = request

    @view_config(route_name="badrequest")
    def badrequest(self):
        raise HTTPBadRequest("this request always fails", json_formatter="json")
