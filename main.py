from dotenv import load_dotenv
import os
import pandas as pd
from llama_index.core.query_engine import PandasQueryEngine
from prompts import new_prompt, instruction_str, context
from note_engine import note_engine
from llama_index.core.tools import QueryEngineTool, ToolMetadata
from llama_index.core.agent import ReActAgent
from llama_index.llms.openai import OpenAI
from pdf import path_engine


load_dotenv()

college_path = os.path.join("data", "College.csv")
college_df = pd.read_csv(college_path)

college_query_engine = PandasQueryEngine(df=college_df, verbose=True, instruction_str=instruction_str)
college_query_engine.update_prompts({"new_prompt": new_prompt})

tools = [
    note_engine,
    QueryEngineTool(query_engine=college_query_engine, metadata=ToolMetadata(name="college_query_engine",
                                                                             description="Gives information about "
                                                                                         "every college")),
    QueryEngineTool(query_engine=path_engine, metadata=ToolMetadata(name="PATH_query_engine",
                                                                        description="Gives information about getting "
                                                                                    "into college as a first gen high "
                                                                                    "school student")),
]
llm = OpenAI(model="gpt-3.5-turbo")
agent = ReActAgent.from_tools(tools, llm=llm, verbose=True, context=context)

while (prompt := input("Enter a prompt: ")) != "exit":
    result = agent.query(prompt)
    print(result)
