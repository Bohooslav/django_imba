import {vbox, completed} from './styles/index.css'

var store = {
	title: ""
	items: []
}

tag App
	def build
		let url = 'get-todos/'
		let fetched_data = await fetchData url
		data:items = fetched_data
		Imba.commit

	def fetchData url
		let res = await window.fetch url
		return res.json

	def sendItemToDjango title, completed, pk = -1
		window.fetch("/save-todo/", {
			method: "POST",
			cache: "no-cache",
			headers: {
				'X-CSRFToken': get_cookie('csrftoken'),
				"Content-Type": "application/json"
			},
			body: JSON.stringify({
				pk: pk,
				title: title,
				completed: completed,
			}),
		})
		.then(do |response| 
			try 
				response.json()			
			catch error
				log error
			)
		.then(do |data| console.log data)

	def get_cookie name
		let cookieValue = null
		if document:cookie && document:cookie !== ''
			let cookies = document:cookie.split(';')
			for i in cookies
				let cookie = i.trim()
				if (cookie.substring(0, name:length + 1) === (name + '='))
					cookieValue = window.decodeURIComponent(cookie.substring(name:length + 1))
				break
			return cookieValue

	def addItem
		sendItemToDjango data:title, no
		data:items.push(title: data:title)
		data:title = ""

	def completeItem item
		console.log "clicked,{item:completed}, {item:pk}"
		item:completed = !item:completed
		sendItemToDjango item:title, item:completed, item:pk
		
	def render
		<self.{vbox}>
			<header>
				<input[data:title] placeholder="New..." :keyup.enter.addItem>
				<button :tap.addItem> 'Add item'
			<ul> for item in data:items
				<li .{item:completed and completed} :tap.completeItem(item)> item:title

Imba.mount <App[store]>
