from django.urls import path
from . import views

urlpatterns = [
    path('users/', views.getUsers),
    path('medical/', views.getMedical),
    path('login/', views.login),
    path('profile/', views.getProfile),
    path('weight/', views.dailyAnalysis),
    path('addWeight/' , views.addWeight),
    path('ments/', views.ments)
]
