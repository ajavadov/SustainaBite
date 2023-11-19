from google.cloud import firestore, storage
from google.oauth2 import service_account

class FirestoreTalker(object):

	def __init__(self, project_name, credentials_path):
		self.project_name = project_name
		self.credentials_path = credentials_path
		credentials = service_account.Credentials.from_service_account_file(credentials_path)
		self.db = firestore.Client(project=project_name, credentials=credentials)
		self.storage = storage.Client(project=project_name, credentials=credentials)

	def get_all_documents_from_collection(self, collection):
		return self.db.collection(collection).steam()

	def get_all_documents_from_collection_in_document_in_collection(self, parent_collection, document, child_collection):
		return self.db.collection(parent_collection).document(document).collection(child_collection).stream()

	#data is a dict with data, next ones are names of collections and documents
	def add_document_to_collection_in_document_in_collection(self, data, parent_collection, document, child_collection, id = None):
		if id is None:
			return self.db.collection(parent_collection).document(document).collection(child_collection).add(data)
		return self.db.collection(parent_collection).document(document).collection(child_collection).document(id).set(data)

	def get_id_of_document(response_from_add):
		return response_from_add[1].id

	def add_document_to_collection(self, data, collection, id = None):
		if id is None:
			return self.db.collection(collection).add(data)
		return self.db.collection(collection).document(id).set(data)

