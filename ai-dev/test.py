import requests

# Define test cases
test_cases = [
    {
        "student_answer": "The operating system protects resources by requiring user authentication, access control, and isolating processes to maintain system integrity.",
        "teacher_answer": "The Operating System ensures security and protection of resources through user authentication, access control, and encryption. It isolates processes to maintain system integrity.",
    },
    {
        "student_answer": "Operating systems use methods like authentication and encryption to secure data, along with permissions to restrict file access.",
        "teacher_answer": "The Operating System ensures security and protection of resources through user authentication, access control, and encryption. It isolates processes to maintain system integrity.",
    },
    {
        "student_answer": "Security is achieved using firewalls and antivirus software, protecting the system from external threats.",
        "teacher_answer": "The Operating System ensures security and protection of resources through user authentication, access control, and encryption. It isolates processes to maintain system integrity.",
    },
    {
        "student_answer": "User authentication protects files and processes from interference.",
        "teacher_answer": "The Operating System ensures security and protection of resources through user authentication, access control, and encryption. It isolates processes to maintain system integrity.",
    },
    {
        "student_answer": "Operating systems are responsible for running applications and managing hardware like the CPU and memory.",
        "teacher_answer": "The Operating System ensures security and protection of resources through user authentication, access control, and encryption. It isolates processes to maintain system integrity.",
    },
    {
        "student_answer": "The Operating System ensures security and protection of resources through user authentication, access control, and encryption. It isolates processes to maintain system integrity.",
        "teacher_answer": "The Operating System ensures security and protection of resources through user authentication, access control, and encryption. It isolates processes to maintain system integrity.",
    },
    {
        "student_answer": "The operating system protects resources by requiring user authentication, access control, and isolating processes to maintain system integrity.",
        "teacher_answer": "The Operating System ensures security and protection of resources through user authentication, access control, and encryption. It isolates processes to maintain system integrity.",
    },
    {
        "student_answer": "Operating systems use methods like authentication and encryption to secure data, along with permissions to restrict file access.",
        "teacher_answer": "The Operating System ensures security and protection of resources through user authentication, access control, and encryption. It isolates processes to maintain system integrity.",
    },
    {
        "student_answer": "Security is achieved using firewalls and antivirus software, protecting the system from external threats.",
        "teacher_answer": "The Operating System ensures security and protection of resources through user authentication, access control, and encryption. It isolates processes to maintain system integrity.",
    },
    {
        "student_answer": "User authentication protects files and processes from interference.",
        "teacher_answer": "The Operating System ensures security and protection of resources through user authentication, access control, and encryption. It isolates processes to maintain system integrity.",
    },
    {
        "student_answer": "Operating systems are responsible for running applications and managing hardware like the CPU and memory.",
        "teacher_answer": "The Operating System ensures security and protection of resources through user authentication, access control, and encryption. It isolates processes to maintain system integrity.",
    },
    {
        "student_answer": "The Operating System ensures security and protection of resources through user authentication, access control, and encryption. It isolates processes to maintain system integrity.",
        "teacher_answer": "The Operating System ensures security and protection of resources through user authentication, access control, and encryption. It isolates processes to maintain system integrity.",
    }
]

# API endpoint
url = "http://127.0.0.1:8000/evaluate"

# Send requests and print responses
for i, case in enumerate(test_cases):
    response = requests.post(url, json=case)
    print(f"Test Case {i + 1}:")
    if response.status_code == 200:
        print(response.json())
    else:
        print(f"Error: {response.status_code}")
    print("-" * 40)
