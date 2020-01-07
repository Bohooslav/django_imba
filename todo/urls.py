from django.urls import path
from . import views

urlpatterns = [
	path('', views.index, name = 'index'),
	path('get-todos/', views.getTodos, name = 'getTodos'),
	path('save-todo/', views.saveTodo, name = 'saveTodo')
]