# Preliminar evaluation of pre-trained Whisper model on flamenco

In order to properly build a fune-tunned Whisper model for flamenco transcription, first we have to evaluate the performance of the pre-trained Whisper model on flamenco songs. A previous zero-shot test (even though using a biased limited and biased), by [Max Hilsdorf](https://twitter.com/max_hilsdorf) concluded that background instrumental is not a great challenge for Whisper[^1]. 

We will create a dataset of flamenco songs with different features in order to perform an [**error analysis**](https://towardsdatascience.com/error-analysis-in-neural-networks-6b0785858845), which will allow us to focus on the most relevant optimization steps. 



## *prEval* dataset 
==[DESCRIPTION OF THE DATASET]==


### Features
Inspired by Max's test, who defines four levels of difficulty  by taking into account presence of vocals and how noisy the backgroung is, I decided to define **XX features** with the aim of evaluating what are the most challenging features of *cante* flamenco for Whisper. For that purpose, I will run a TEST ANALYSIS on XX flamenco songs.

**Description**  
A short description of the audio file. Must indicate the singer and the origin of the file: if it is a manual recording (from a vynil, for example), album and year should be provided at least, while if it is a downloaded file, the link should be provided.

**Audio quality (AQ, numerical: 0 to 5)**  
Flamenco is a traditional music genre, and many songs were recorded in vynil records from the moment this technology was available -around 1900-. We will define *audio quality* as the combination of different types of sound imperfections. Starting at the highest possible score (5), we will remove one *audio quality point* for each sound imperfection present in the audio file (if the imperfection is considerable, we could substract two points): 

- *White noise*: random signal having equal intensity at different frequencies, giving it a constant power spectral density[^2]. Vynil crackling is included in this feature [*Example*](https://upload.wikimedia.org/wikipedia/commons/9/98/White-noise-sound-20sec-mono-44100Hz.ogg).
- *Impulse noise*: includes unwanted, almost instantaneous (thus impulse-like) sharp sounds (like clicks and pops)[^3]. They can appear from electro-acoustic sources (damaged cables, hits on the microphone while singing, etc.) or digital ones (clocking issues, size of audio buffer, etc.). [*Example*](https://www.youtube.com/watch?v=ydclhhfQlt0).
- *Background noise*: any sound other than the sound being monitored (primary sound), which includes vocals and instrumentals[^4]. 
- *Oversaturation*: it refers to the vocal sounds being so loud at recording that the sound is distorted and difficults the understanding of the lyrics. 

**Cultural-specific lyrics (CSl, numerical: 0 to 1)**
Some lyrics are very cultural-specific, making reference to traditions, sayings or places of the south of Spain (either of present or ancient times). They are measured as the proportion of the cultural-specific words $(\frac{\text{# cultural-specific words}}{\text{# unique words}})$.

**Instrumental background (IB, numerical: 0 to 5)**
*Cante* flamenco is usually accompanied with guitar, precussion -clapping, *cajón*- or *jaleos* among other background sounds which might impair the speech recognition. Contrary to audio quality feature, we will start at the lowest score for instrumental background (0), and will add one *instrumental background point* for each instrumental sound present at the same time as the vocals, setting a maximum score of 5. 

**_Palo_ (string: many)**
*Cante flamenco* has different subgenres, which vary in rhythm, theme and forms. This feature will be a string indicating the *palo* of the sample: *alegrías*, *bulerías*, *soleá*, *tangos*, *fandangos*, *seguiriyas*, *tarantos*, *tientos*, *malagueñas*, *peteneras*, *zambra*, *caña* and *granaína*, among others.

**_Quejíos_ (numerical: 1 to 5)**
Laments are very common to *cante flamenco*, even though they are more common in some *palos* than for others. They are an expression of pain and sorrow which are also expressed differently in each *palo*. Even though they are expressive and meaningful, they are not relevant lyrics and may impair speech recognition, both for themselves and for actual lyrics. In an attempt for avoiding as much subjectivity as possible, we will measure this feature as the proportion of *quejíos* (its duration), relative to the duration of the vocal audio. 

**Region (string: may)**
As every language, spanish has many different accents. Even within the south of Spain, we can find different pronunciations for the same letters. Some of them could be more difficult to correctly identify than others. This feature will be a string indicating the region of procedence of the singer ==[CIUDAD, COMARCA, PROVINCIA?]==

**Sex (string: male OR female OR mix)**
Sex of the main singer. If singers of different sex participate in the song, we will indicate "mix".





??? note "Collapsed"
    ``` ruby hl_lines="3"
    if yr % 400 == 0
    	puts "#{yr} is a leap year"
    elsif yr % 4 == 0 && yr % 100 !=0
    	puts "#{yr} is a leap year"
    else
    	puts "#{yr} is not a leap year"
    end
    ```





## Evaluation metric

To evaluate how good was the performance of pre-trained Whisper, we need an evaluation metric. 

[**INVESTIGAR QUE METRICA PODEMOS USAR - ver Word Error Rate [WER](https://huggingface.co/spaces/evaluate-metric/wer)**]


## Evaluation results

Here I display the results of the preliminar evaluation on the presented test audios using different whisper checkpoints. 

[*INSERTAR TABLA CON LOS RESULTADOS DE LA EVALUACIÓN PRELIMINAR*]

## References

[^1]: Zero-Shot Song Lyrics Transcription Using Whisper. [Go to website](https://medium.com/mlearning-ai/zero-shot-song-lyrics-transcription-using-whisper-3f360499bcfe)

[^2]: Wikipedia: White noise. [Go to website](https://en.wikipedia.org/wiki/White_noise)

[^3]: Wikipedia: Impulse noise (acoustics). [Go to website](https://en.wikipedia.org/wiki/Impulse_noise_(acoustics))

[^4]: Wikipedia: Background noise. [Go to website](https://en.wikipedia.org/wiki/Background_noise)
