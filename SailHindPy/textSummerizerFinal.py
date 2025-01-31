#!/usr/bin/env python
# -*- coding: utf-8 -*- 
# coding: latin-1
import re
import math
import os,sys,io
# for reading input file
text = open(sys.argv[1], encoding="utf8").read()

# for removing punctuation from sentences

text = re.sub(r'(\d+)', r'', text)
text = text.replace('\n', '')
text = text.replace(u',', '')
text = text.replace(u'"', '')
text = text.replace(u'(', '')
text = text.replace(u')', '')
text = text.replace(u'"', '')
text = text.replace(u':', '')
text = text.replace(u"'", '')
text = text.replace(u"’", '')
text = text.replace(u"‘", '')
text = text.replace(u"‘‘", '')
text = text.replace(u"’’", '')
text = text.replace(u"''", '')
text = text.replace(u".", '')
text = text.replace(u'?', u'।')

sentences = text.split(u"।")
# print(sentences)
tokens = []
for each in sentences:
    word_list = each.split()
    tokens = tokens + word_list

# print(tokens)
stop_removed_tokens = []
f = open(sys.argv[2], encoding="utf8")
stopwords = [x.strip() for x in f.readlines()]
tokens = [i for i in tokens if i not in stopwords]
stop_removed_tokens = set(tokens)


#print(stop_removed_tokens)
def generate_stem_words(word):
    suffixes = {1: [u"ो", u"े", u"ू", u"ु", u"ी", u"ि", u"ा"],
                2: [u"कर", u"ाओ", u"िए", u"ाई", u"ाए", u"ने", u"नी", u"ना", u"ते", u"ीं", u"ती", u"ता", u"ाँ", u"ां",u"ों",u"ें"],
                3: [u"ाकर", u"ाइए", u"ाईं", u"ाया", u"ेगी", u"ेगा", u"ोगी", u"ोगे", u"ाने", u"ाना", u"ाते", u"ाती",u"ाता",u"तीं", u"ाओं", u"ाएं", u"ुओं", u"ुएं", u"ुआं"],
                4: [u"ाएगी", u"ाएगा", u"ाओगी", u"ाओगे", u"एंगी", u"ेंगी", u"एंगे", u"ेंगे", u"ूंगी", u"ूंगा", u"ातीं",u"नाओं", u"नाएं", u"ताओं", u"ताएं", u"ियाँ", u"ियों", u"ियां"],
                5: [u"ाएंगी", u"ाएंगे", u"ाऊंगी", u"ाऊंगा", u"ाइयाँ", u"ाइयों", u"ाइयां"],
                }
    for L in 5, 4, 3, 2, 1:
        if len(word) > L + 1:
            for suf in suffixes[L]:
                if word.endswith(suf):
                    return word[:-L]
    return word


def generate_stem_dict():
    stem_word = {}
    stemmed_word = []
    for each_token in tokens:
        temp = generate_stem_words(each_token)
        stem_word[each_token] = temp
        stemmed_word.append(temp)
    return stem_word


generate_stem_dict()
tokens = stop_removed_tokens
#print(tokens)
tokens = list (set(tokens))#Enable by Sailandra Harsha
# Making word frequency  in dictinary datastructure
freqTable = dict()
for word in tokens:
    if word in freqTable:
        freqTable[word] += 1
    else:
        freqTable[word] = 1
# printing the Frequency of Words

# Tokenizing The Sentences
sentences = text.split(u"।")

# making sentenceValue dictionary and giving a sentenceValue(rank) through freqTable dictionary of words.
sentenceValue = dict()
for sentence in sentences:
    for wordValue in freqTable:
        if sentence in sentenceValue:
            sentenceValue[sentence] += freqTable[wordValue]
        else:
            sentenceValue[sentence] = freqTable[wordValue]

# Normalize the value of sentence rank as 0 to 1
for sentence in sentenceValue:
    sentenceValue[sentence] = (sentenceValue[sentence] * (1.000000)) / max(sentenceValue.values())

# sentence length feature

sentenceLength = dict()


def sentence_length(sentences):
    MinL = 4  # minm len of sentence
    MaxL = 18  # maxm len of sentence
    Mintheta = 0  # minm angle theta
    Maxtheta = 180  # maxm angle theta
    for sentence in sentences:
        L = sentence.split()
        L = len(L)
        if ((L < MinL) or (L > MaxL)):  # if senLength less than MinLength or Grtr than MaxLen then ignore the sentence
            sentenceLength[sentence] = 0
        else:
            Sl = math.sin((L - MinL) * ((Maxtheta - Mintheta) / (MaxL - MinL)))  # calculate the sentence
            sentenceLength[sentence] = Sl
    return sentenceLength


sentence_length(sentences)  # calling sentence_length function

# sentence position feature
sentencePosition = dict()
sentenceNumber = dict()


def sentence_position(sentences):
    TRSH = 0.01
    Mintheta = 0
    Maxtheta = 360
    CP = 1
    MinV = len(sentences) * TRSH
    MaxV = len(sentences) * (1 - TRSH)
    for sentence in sentences:
        if ((CP == 1) or (CP == len(sentences))):  # if sentence postion is 1st or last then its important
            sentencePosition[sentence] = 1
            sentenceNumber[sentence] = CP
        else:
            SP = math.cos((CP - MinV) * ((Maxtheta - Mintheta) / (MaxV - MinV)))  # calculating sentence position
            sentencePosition[sentence] = SP
            sentenceNumber[sentence] = CP
        CP = CP + 1
    return sentencePosition


sentence_position(sentences)

#print(sentenceNumber)
# sentence Similarity feature by Graph
sentToken = []  # each sentence containg token
for sent in sentences:
    temp = sent.split()
    f = open(sys.argv[2], encoding="utf8")
    stopwords = [x.strip() for x in f.readlines()]
    token = [i for i in temp if i not in stopwords]
    sentToken.append(token)


# print(sentToken)
# retuen weight of two sentences
def weight(i, j):
    sent1 = sentToken[i]
    sent2 = sentToken[j]
    return len(list(set(sent1).intersection(sent2)))


sentLen = len(sentences)

sentencesGraph = [[0 for x in range(sentLen)] for y in range(sentLen)]
for i in range(0, sentLen):
    for j in range(0, sentLen):
        if i != j:
            sentencesGraph[i][j] = weight(i, j)
        else:
            sentencesGraph[i][j] = 0

senSimlariy = []
sum = 0
for i in range(0, sentLen):
    for j in range(0, sentLen):
        sum += sentencesGraph[i][j]
    senSimlariy.append(sum)
    sum = 0
sentencesSimilarity = dict()
i = 0  # indexing the sentence similarity sentences
for sentence in sentences:
    sentencesSimilarity[sentence] = senSimlariy[i] / max(senSimlariy)
    i += 1

# sentence Feature add for ranking of sentences
sentenceRanking = dict()


def sentence_ranking(sentences):
    f4 = sentencesSimilarity
    f1 = sentenceValue
    f2 = sentenceLength
    f3 = sentencePosition
    for sentence in sentences:
        temp = abs(f1[sentence]) + abs(f2[sentence]) + abs(f3[sentence])  + abs(f4[sentence])
        sentenceRanking[sentence] = temp
    return sentenceRanking


sentence_ranking(sentences)

# function to calculate summary
sentenceSummary = dict()



def summary():
    senLength = len(sentences)
    percent = int(sys.argv[3])
    count = int(senLength * (percent / 100))
    if count > senLength:
        print("Wrong Input..must be less than original sentence length.")

    temp = 0
    sentence_Ranking = sorted(sentenceRanking.items(), key=lambda t: t[1],reverse=True)  # sorting sentence_Rank dict in reverse order
    for k in sentence_Ranking:
        if temp < count:
            sentenceSummary[sentenceNumber[k[0]]] = k[0]
			#print(sentenceNumber[k[0]])
            temp = temp + 1
        else:
            return 0




summary()

sentence_summary = sorted(sentenceSummary.items())
encoding = 'utf8'
file = open(sys.argv[4],"w", encoding=encoding) 
for x in sentence_summary:
	file.write(x[1]+"|")
 
file.close()	


  # calling summary function

# print(sentenceSummary)

print("OK")