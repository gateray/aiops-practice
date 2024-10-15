import os
import json

from openai import OpenAI

client = OpenAI(
    api_key=os.environ['OPENAI_API_KEY'],
    base_url="https://api.apiyi.com/v1"
)

def modify_config(service_name, key, value) -> str:
    result = f'''
    # Service: {service_name} config change
    | key | origin value | new value |
    | --------- | ------ | --------- |
    | {key} | old-{value} | {value} |
    '''
    return result

def restart_service(service_name) -> str:
    result = f'''
    Success to execute `systemctl restart {service_name}`
    '''
    return result

def apply_manifest(manifest) -> str:
    result = f'''cat <<EOF | kubectl apply -f -
{manifest}
EOF
'''
    return result

func_dict = {
    "modify_config": modify_config,
    "restart_service": restart_service,
    "apply_manifest": apply_manifest
}

tools = [
    {
        "type": "function",
        "function": {
            "name": "modify_config",
            "description": "修改服务配置",
            "parameters": {
                "type": "object",
                "properties": {
                    "service_name": {
                        "type": "string",
                        "description": '应用或服务名称，例如：ssh',
                    },
                    "key": {
                        "type": "string",
                        "description": '配置项的名称',
                    },
                    "value": {
                        "type": "string",
                        "description": '配置项的值',
                    },
                },
                "required": ["service_name", "key", "value"],
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "restart_service",
            "description": "重启服务",
            "parameters": {
                "type": "object",
                "properties": {
                    "service_name": {
                        "type": "string",
                        "description": '服务名称，例如：nginx',
                    }
                },
                "required": ["service_name"],
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "apply_manifest",
            "description": "根据用户对k8s资源类型、镜像、监听端口、namespace、副本数等信息的描述生成的manifest内容，可以apply到k8s集群",
            "parameters": {
                "type": "object",
                "properties": {
                    "manifest": {
                        "type": "string",
                        "description": '生成的k8s资源manifest内容',
                    }
                },
                "required": ["manifest"],
            },
        },
    }
]

def get_chat_history(messages):
    history = []
    for message in messages:
        if isinstance(message, dict):
            if message.get("role") != "tool":
                history.append(f"{message['role']}: {message['content']}")
            else:
                history.append(f"{message['role']}: call func {message['name']}(), return: \n{message['content']}")
        else:
            history.append(f"{message.role}: {message.content}")
    return '\n'.join(history)

def chat():
    messages = [
        {
            "role": "system",
            "content": "你是一个运维操作助手，你可以根据用户的需求通过调用多个函数来帮助用户执行对应的运维操作，并返回操作结果，如果不能识别用户的意图请不要编造",
        }
    ]
    while True:
        user_input = input("输入执行指令：")
        if user_input == "exit":
            break
        messages = messages[:1]
        messages.append({
            "role": "user",
            "content": user_input,
        })
        response = client.chat.completions.create(
            model="gpt-4o",
            messages=messages,
            tools=tools,
            tool_choice="auto",
            temperature=0
        )
        tool_calls_response_message = response.choices[0].message
        tool_calls = tool_calls_response_message.tool_calls
        if not tool_calls:
            print("OpenAI无法推测应该调用哪个函数，请重新输入指令！")
            continue
        print("\nOpenAI want to call function: ", tool_calls)
        print(tool_calls_response_message)
        messages.append(tool_calls_response_message)
        for tool_call in tool_calls:
            function_name = tool_call.function.name
            try:
                function_args = json.loads(tool_call.function.arguments)
            except json.JSONDecodeError:
                print("json.loads无法解析OpenAI返回的tool_call.function.arguments")
                continue
            function_to_call = func_dict.get(function_name)
            if not function_to_call:
                print(f"func_tools中无法找到{function_name}函数")
                continue
            func_ret = function_to_call(**function_args)
            messages.append({
                "tool_call_id": tool_call.id,
                "role": "tool",
                "name": function_name,
                "content": func_ret,
            })

        response = client.chat.completions.create(
            model="gpt-4o",
            messages=messages,
        )
        messages.append(response.choices[0].message)
        print("对话历史：\n", get_chat_history(messages))
    print("对话结束！")

if __name__ == '__main__':
    chat()