from django.urls import path
from .views import NmapScanView

urlpatterns = [
    path('scan/', NmapScanView.as_view(), name='nmap-scan'),
]
