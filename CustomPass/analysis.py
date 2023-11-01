import re
import matplotlib.pyplot as plt
from collections import Counter

stop_words = ["adding", "calls", "for", ":"]

with open("output.txt", "r") as file:
    text = file.read()

words = re.findall(r'\w+', text)

words = [word.lower() for word in words]

filtered_words = [word for word in words if word not in stop_words]

# Создаем счетчик для подсчета частоты каждого слова
word_counter = Counter(filtered_words)

top_words = word_counter.most_common(10)

# Разделяем слова и их частоту
top_words, top_frequencies = zip(*top_words)

# Создаем график
plt.figure(figsize=(10, 5))
plt.bar(top_words, top_frequencies)
plt.xlabel("Instructions")
plt.ylabel("Frequncy")
plt.title("Top-10 most frequent instructions")
plt.xticks(rotation=45)
plt.tight_layout()

plt.savefig("graph.png")

plt.show()
