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
plt.figure(figsize=(15, 10))
plt.bar(top_words, top_frequencies)
plt.ylabel("Frequncy")
plt.title("Top-10 most frequent for WS = 1")
plt.xticks(rotation=0)
plt.tight_layout()

plt.savefig("graph1.png")


# Создаем график для наиболее часто встречающихся пар слов
bigrams = [filtered_words[i] + "\n" + filtered_words[i + 1] for i in range(len(filtered_words) - 1)]
bigram_counter = Counter(bigrams)

top_bigrams = bigram_counter.most_common(10)

# Разделяем пары слов и их частоту
top_bigram_words, top_bigram_frequencies = zip(*top_bigrams)

# Создаем график для пар слов
plt.figure(figsize=(15, 10))
plt.bar(top_bigram_words, top_bigram_frequencies)
plt.ylabel("Frequency")
plt.title("Top-10 most frequent for WS = 2")
plt.xticks(rotation=0)

plt.savefig("graph2.png")

# Создаем график для наиболее часто встречающихся троек слов
trigrams = [filtered_words[i] + "\n" + filtered_words[i + 1] + "\n" + filtered_words[i + 2] for i in range(len(filtered_words) - 2)]
trigram_counter = Counter(trigrams)

top_trigrams = trigram_counter.most_common(10)

# Разделяем тройки слов и их частоту
top_trigram_words, top_trigram_frequencies = zip(*top_trigrams)

# Создаем график для троек слов
plt.figure(figsize=(15, 10))
plt.bar(top_trigram_words, top_trigram_frequencies)
plt.ylabel("Frequency")
plt.title("Top-10 most frequent for WS = 3")
plt.xticks(rotation=0)

# Сохраняем график в файл
plt.savefig("graph3.png")

# Создаем график для наиболее часто встречающихся четверок слов
quadgrams = [filtered_words[i] + "\n" + filtered_words[i + 1] + "\n" + filtered_words[i + 2] + "\n" + filtered_words[i + 3] for i in range(len(filtered_words) - 3)]
quadgram_counter = Counter(quadgrams)

top_quadgrams = quadgram_counter.most_common(10)

# Разделяем четверки слов и их частоту
top_quadgram_words, top_quadgram_frequencies = zip(*top_quadgrams)

# Создаем график для четверок слов
plt.figure(figsize=(15, 10))
plt.bar(top_quadgram_words, top_quadgram_frequencies)
plt.ylabel("Frequency")
plt.title("Top-10 most frequent for WS = 4")
plt.xticks(rotation=0)

# Сохраняем график в файл
plt.savefig("graph4.png")

# Создаем график для наиболее часто встречающихся пятерок слов
pentagrams = [filtered_words[i] + "\n" + filtered_words[i + 1] + "\n" + filtered_words[i + 2] + "\n" + filtered_words[i + 3] + "\n" + filtered_words[i + 4] for i in range(len(filtered_words) - 4)]
pentagram_counter = Counter(pentagrams)

top_pentagrams = pentagram_counter.most_common(10)

# Разделяем пятерки слов и их частоту
top_pentagram_words, top_pentagram_frequencies = zip(*top_pentagrams)

# Создаем график для пятерок слов
plt.figure(figsize=(15, 10))
plt.bar(top_pentagram_words, top_pentagram_frequencies)
plt.ylabel("Frequency")
plt.title("Top-10 most frequent for WS = 5")
plt.xticks(rotation=0)

# Сохраняем график в файл
plt.savefig("graph5.png")





