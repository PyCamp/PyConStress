from django.db import models


class Scores(models.Model):
    player = models.CharField(max_length=50, default="AAA", unique=True)
    score = models.IntegerField(default=0)
