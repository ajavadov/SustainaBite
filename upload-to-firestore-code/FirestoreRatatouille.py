from FirestoreDocument import FirestoreDocument
from FirestoreTalker import FirestoreTalker

class FirestoreRatatouille(object):

	def __init__(self):
		PROJECT_NAME = "ratatouille-ae161"
		CREDENTIALS = "ratatouille-ae161-firebase-adminsdk-lmbc9-4f35929853.json"

		self.talker = FirestoreTalker(PROJECT_NAME, CREDENTIALS)

	def add_food(self, document:FirestoreDocument, id = None):
		return self.talker.add_document_to_collection(document.to_dict(), u'Food', id = id)
