
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import web
import json


urls = ('/get_example', 'get_example_class')



class get_example_class:
	def POST(self):
		web.header('Access-Control-Allow-Origin', '*')
		web.header('Access-Control-Allow-Credentials', 'true')
		print(str(web.data())[2:-1])
		temp = str(web.data())[2:-1]
		data = json.loads(temp)
		input_text = data['input-text']
		print(input_text)
		return json.dumps('{"result":"Success"}')



if __name__ == "__main__":

	app = web.application(urls, globals()) 
	app.run()
	
	pass
