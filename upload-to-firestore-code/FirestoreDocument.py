class FirestoreDocument():

	def __init__(self):
		self.data = {}

	def add(self, name, field):
		self.data.update({name: field})

	def to_dict(self):
		return self.data