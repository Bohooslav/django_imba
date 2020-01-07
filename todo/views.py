from django.shortcuts import render
from django.http import JsonResponse
import json

from .models import Todo


def index(request):
    return render(request, 'todo/index.html')

def getTodos(request):
	todos_list = Todo.objects.all()
	todo = []
	for item in todos_list:
		todo.append({
				'pk': item.pk,
				'title': item.title,
				'completed': item.completed
			})
	return JsonResponse(todo, safe=False)

def saveTodo(request):
	received_json_data = json.loads(request.body)

	try:
		obj = Todo.objects.get(pk = received_json_data['pk'])
		print(obj)
		Todo.objects.filter(pk = received_json_data['pk']).update(completed = received_json_data['completed'])
	except Todo.DoesNotExist:
		newtodo = Todo(
				title = received_json_data['title'],
				completed = received_json_data['completed']
			)
		newtodo.save()

	return JsonResponse({"response": "200"}, safe=False)