from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from .models import Task

def index(request):
    tasks = Task.objects.all()
    context = {
        'tasks': tasks
    }
    return HttpResponse("<h1>Welcome to Django DevOps Learning!</h1><p>Application is running successfully.</p>")

def health_check(request):
    return JsonResponse({'status': 'healthy', 'message': 'Django app is running'})