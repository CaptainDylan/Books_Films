#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
from gensim.corpora import Dictionary
import gensim
import datetime


# In[2]:


reviews = pd.read_csv("../Data_Processing/cleaned.csv",encoding="utf-8")


# In[8]:


reviews[0:1]


# ## Create a corpus (list of lists of strings) and use it to create a Gensim Dictionary object

# In[3]:


documents = reviews["cleaned"].apply(lambda s: s.split(' '))


# In[4]:


dictionary = Dictionary(documents)


# ## Get the most common words

# In[38]:


len(dictionary.token2id.keys())


# In[39]:


#dictionary.dfs[dictionary.token2id["character"]]
#sortedcounts = list(dictionary.dfs.values())


# In[49]:


#sortedcounts.sort()


# In[50]:


#top20 = sortedcounts[-20:]


# In[51]:


#top20


# In[52]:


#for k,v in dictionary.dfs.items():
#    if v in top20:
#        print (list(dictionary.token2id.keys())[k],v)


# In[ ]:


## Use dictionary functionality to remove word extremes
# Remove words that occur in fewer than 10 documents or more than 60% of documents
print('Dictionary length before pruning: ' + str(len(dictionary)))
dictionary.filter_extremes(no_below=10, no_above=0.6)
print('Dictionary length after pruning: ' + str(len(dictionary)))


# ## Create a corpus that is the vectorized version of the list of list of words

# In[5]:


#%%time 
corpus = [dictionary.doc2bow(text) for text in documents]


# In[47]:


## This functionality is not supported with multicore
# Create callbacks so we get metrics during progress
#from gensim.models.callbacks import PerplexityMetric
#from gensim.models.callbacks import DiffMetric
#from gensim.models.callbacks import CoherenceMetric
#from gensim.models.callbacks import ConvergenceMetric

#callbacklist = [PerplexityMetric(corpus=corpus2, logger='shell'),
#           DiffMetric(logger='shell'),
#           CoherenceMetric(corpus=corpus2, dictionary = dictionary, logger='shell'),
#           ConvergenceMetric(logger='shell')]


# In[52]:


#%%time
#lda = gensim.models.ldamodel.LdaModel(corpus=corpus2, id2word=dictionary, num_topics=20, update_every=0, passes=20, callbacks =callbacklist)
#lda = gensim.models.LdaMulticore(workers=2,corpus=corpus2, id2word=dictionary, num_topics=20, iterations=20)


# ## Save the results so they can be used to display interactively later

# In[ ]:


import pickle
pickle.dump(corpus, open('movies_corpus.pkl', 'wb'))
dictionary.save('movies_dictionary.gensim')
##lda.save('movies20topics.gensim')


# In[54]:


#%%time
#lda = gensim.models.ldamodel.LdaModel(corpus=corpus2, id2word=dictionary, num_topics=20, update_every=0, passes=20, callbacks =callbacklist)
#lda50 = gensim.models.LdaMulticore(workers=2,corpus=corpus2, id2word=dictionary, num_topics=50, iterations=20)


# In[55]:


#topics_20 = lda.print_topics(num_words=10)
#for topic in topics_20:
#    print(topic)


# In[56]:


#topics_50 = lda50.print_topics(num_words=10)
#for topic in topics_50:
#    print(topic)


# In[59]:


from gensim.models.coherencemodel import CoherenceModel
#cm = CoherenceModel(model=lda50, corpus=corpus2, coherence='u_mass')
#coherence = cm.get_coherence()
#coherence
## -1.607074887186608 for 20
## -2.708791945194641


# In[ ]:


TOPIC_SIZES = [12, 15, 20, 25, 30, 35, 40, 45, 50, 60, 70, 80]
results = []
for topic_size in TOPIC_SIZES:
    print(datetime.datetime.today(), 'Process model for ' + str(topic_size) + ' topics')
    ldatmp = gensim.models.LdaMulticore(workers=None,corpus=corpus, id2word=dictionary, passes=20, num_topics=topic_size, iterations=20)
    print(datetime.datetime.today(), 'Model created for ' + str(topic_size) + ' topics')
    ldatmp.save('movies_topics_' + str(topic_size) + '.gensim')
    cm = CoherenceModel(model=ldatmp, corpus=corpus, coherence='u_mass')
    coherence_um = cm.get_coherence()
    cm = CoherenceModel(model=ldatmp, texts=documents, coherence='c_v')
    coherence_cv = cm.get_coherence()
    print(datetime.datetime.today())
    print(topic_size, coherence_um, coherence_cv)
    results.append((topic_size, coherence_um, coherence_cv))

print(results)


# In[1]:


pickle.dump(results, open('lda_results.pkl','wb'))


# In[8]:





# In[ ]:




