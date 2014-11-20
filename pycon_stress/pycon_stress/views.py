# -*- coding: utf-8 -*-
from django.shortcuts import render_to_response
from django.template import RequestContext

from rest_framework.decorators import api_view
from rest_framework.response import Response

from pycon_stress import models
from pycon_stress import settings


def render_response(req, *args, **kwargs):
    """ Includes all the variables from the previous context.
    """
    kwargs['context_instance'] = RequestContext(req)
    return render_to_response(*args, **kwargs)


def home(request):
    """Home Page."""
    data = {}
    scores = models.Scores.objects.all().order_by("-score")[:5]
    data["scores"] = scores
    return render_response(request, 'index.html', data)


def scores(request):
    """Home Page."""
    data = {}
    scores = models.Scores.objects.all().order_by("-score")[:50]
    data["scores"] = scores
    return render_response(request, 'scores.html', data)


@api_view(['GET'])
def publish_score(request):
    token = request.GET.get('token', "")
    if token == settings.TOKEN_KEY:
        player = request.GET.get('player', "")
        score = int(request.GET.get('score', "0"))
        if player and score:
            scoredb, _ = models.Scores.objects.get_or_create(player=player)
            if scoredb and score > scoredb.score:
                scoredb.score = score
                scoredb.save()
    return Response({})