import os
from llama_index.readers.file import PyMuPDFReader
from llama_index.core import StorageContext, VectorStoreIndex, load_index_from_storage


def get_index(data, index_name):
    index = None
    if not os.path.exists(index_name):
        print("building index", index_name)
        index = VectorStoreIndex.from_documents(data, show_progress=True)
        index.storage_context.persist(persist_dir=index_name)
    else:
        index = load_index_from_storage(StorageContext.from_defaults(persist_dir=index_name))
    return index


pdf_paths = os.path.join("data", "Path.pdf")
path_pdf = PyMuPDFReader().load_data(pdf_paths)
path_index = get_index(path_pdf, "path")
path_engine = path_index.as_query_engine()
