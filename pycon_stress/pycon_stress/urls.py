from django.conf.urls import patterns, include, url
from django.contrib import admin

urlpatterns = patterns(
    '',
    url(r'^api/publish_score/$',
        'pycon_stress.views.publish_score', name='publish_score'),
    url(r'^admin/', include(admin.site.urls)),
    url(r'^scores/$', 'pycon_stress.views.scores', name='scores'),
    url(r'^$', 'pycon_stress.views.home', name='home'),
)
