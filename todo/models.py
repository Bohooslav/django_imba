from django.db import models

class Todo(models.Model):
    title = models.TextField()
    completed = models.BooleanField(default=0)