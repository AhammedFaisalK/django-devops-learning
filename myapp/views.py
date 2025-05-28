from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from .models import Task

def index(request):
    try:
        tasks = Task.objects.all()
        context = {
            'tasks': tasks
        }
        # FIXED: Use render instead of JsonResponse
        return render(request, "index.html", context)
    except Exception as e:
        # Fallback for debugging
        return HttpResponse(f"<h1>Django DevOps App</h1><p>App is running! Error: {str(e)}</p>")

def health_check(request):
    return JsonResponse({'status': 'healthy', 'message': 'Django app is running'})