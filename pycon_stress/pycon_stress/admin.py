# -*- coding: utf-8 -*-
from django.contrib import admin

from pycon_stress.models import Scores


class ScoresAdmin(admin.ModelAdmin):
    list_display = ('id', 'player', 'score')
    list_filter = ('id', 'player', 'score')


admin.site.register(Scores, ScoresAdmin)
