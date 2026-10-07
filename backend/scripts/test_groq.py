import os
from dotenv import load_dotenv
from groq import Groq

load_dotenv()

client = Groq(api_key=os.getenv("GROQ_API_KEY"))

response = client.chat.completions.create(
    model="openai/gpt-oss-120b",
    messages=[{"role": "user", "content": "Say hello in one short sentence."}],
    max_tokens=500,
)

# print(response.choices[0].message.content)
choice = response.choices[0]
print("Answer:", repr(choice.message.content))                  #prints the answer from the model
print("Finish reason:", choice.finish_reason)                   #prints the reason why the model stopped generating text
print("Tokens used:", response.usage.completion_tokens)         #prints the number of tokens used in the completion
