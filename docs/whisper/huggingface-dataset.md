We will create two audio 🤗 datasets, one for the preliminar evaluation and other one for the Whisper fine-tunning. We can share any dataset with anyone by creating a dataset repository on the Hugging Face Hub. 


## *prEval* dataset

??? abstract "prEval preview"
    | audio | description | AQ | CSl |IB | palo | quejios | region | sex | WER |
    | ----- | ----------- | -- | --- |-- | ---- | ------- | ------ | --- | --- |
    | <audio controls autoplay> <source src="/files/whisper/prEval/data/caracol.mp3" type="audio/mpeg"> </audio>  | [*Venganza*](https://youtu.be/9nVqUubzfcQ), <br> Manolo Caracol | 1 | 0.00 | 0 | fandango | 0 | sevilla | male | ? |
    | <audio controls autoplay> <source src="/files/whisper/prEval/data/camaron.mp3" type="audio/mpeg"> </audio>  | [*De una mina de la Union*](https://youtu.be/VnKJnIU-8iY), <br> Camarón de la Isla | 5 | 0.00 | 1 | minera | 0.40 | cadiz | male | ? |
    | <audio controls autoplay> <source src="/files/whisper/prEval/data/estrella.mp3" type="audio/mpeg"> </audio>  | [*En lo alto del cerro de Palomares*](https://www.youtube.com/watch?v=G_omDdH1Fyw), <br> Estrella Morente | 5 | 0.07 | 2 | tangos de granada | 0.26 | granada | female | ? |


### Create :material-open-in-new: 
When creating our repository, we will make sure we are in an environment *huggingface_hub CLI* and *Datasets* library (see *Working env* section) installed and we will follow the instructions on [🤗 Docs](https://huggingface.co/docs/datasets/share#clone-the-repository) (*all the commands below apply to my own setup*):

1. Login using Hugging Face Hub credentials:

    ```
    huggingface-cli login
    ```

2. Install [Git-LFS](https://github.com/git-lfs/git-lfs/blob/main/INSTALLING.md), which will be needed if we manage large files, and create new dataset repository:

    ```
    huggingface-cli repo create prEval --type dataset
    ```

3. Clone our repository:

    ```
    git clone https://huggingface.co/datasets/namespace/your_dataset_name
    ```

4. Move our dataset files (for the moment, two empty files and one folder) to the repository directory, then commit and push our files:

    ```
    git add .
    git commit -m "First version of prEval dataset for preliminar evaluation of pre-trained Whisper"
    git push
    ```

Once created our dataset structure looks like this: 

```
my_dataset/
├── README.md
├── metadata.csv
└── data/
```


### Update :material-update: 
When updating *prEval*, we are interested in obtaining as diverse flamenco songs as possible, so our selected features are balanced and we can capture valuable insights from the preliminar evaluation. For this purpose, it is useful to take a look at the dataset from time to time and check the distribution of our features, to ensure that they are diverse enough and do not form unbalanced distributions. ==[I do it with R (Rstudio) like this]==. If some feature has a strange distribution, we should try to balance it with the next audio files we add to the dataset. 

This is the workflow I used for adding new files to *prEval* dataset: 

!!! example

    In this steps I will be using the song *De una mina de la Union*, from Camaron de la Isla ("Son tus ojos dos estrellas", 1971), available [here](https://youtu.be/VnKJnIU-8iY).

1. **Activate *whisper* env, go to dataset path** (`/home/jcalle/whisper/datasets/prEval`) **and create `extended_metadata.csv` file**, manually writing the column names (first line): 

    ```
    file_name,song,author,album,year,link,transcription,AQ_w,AQ_i,AQ_b,AQ_o,CSl,IB_guitar,IB_percussion,IB_jaleos,IB_others,palo,quejios,region,sex
    ```

2. **Generate a hash (ID) for the audio file** using `sha1.py`. 

    ``` hl_lines="1"
    $ python3 ../../scripts/sha1.py extended_metadata.csv 
    Enter the song name: De una mina de la Union
    Enter the author name: Camaron de la Isla
    Enter the album name: Son tus ojos dos estrellas
    Enter the year: 1971
    Enter the link: https://youtu.be/VnKJnIU-8iY
    ```

    > *Prompts must be filled without any spanish accentuation or punctuation marks (except for links). Uppercase letters must be used when it corresponds.*

    ??? info "*sha1.py* script and expected output"

        === "*sha1.py*"

            This python script serves two functions:  
                - On one hand, it prompts you for information related to the audio sample and generates an unique ID, which is a truncated SHA-1 hash that takes as input: song title + author.  
                - On the other hand, it takes the `metadata.csv` file (which stores relevant information and features about the audio sample) as an argument when calling the script and automatically appends the provided information as a single line in comma separated values.

            ``` python  
            import hashlib
            import sys

            # Function to generate SHA-1 hash
            def generate_sha1_hash(input_string):
                return hashlib.sha1(input_string.encode()).hexdigest()

            # Prompt for input variables
            song = input("Enter the song name: ")
            author = input("Enter the author name: ")
            album = input("Enter the album name: ")
            year = input("Enter the year: ")
            link = input("Enter the link: ")

            # Generate hash from song + author
            song_author = song + author
            song_author_hash = generate_sha1_hash(song_author)

            # Add prefix and suffix to hash
            song_author_hash = "data/" + song_author_hash[:10] + ".mp3"

            # Output variables in specific order
            output = f"{song_author_hash},{song},{author},{album},{year},{link}"

            # Append output to specified CSV file
            csv_file = sys.argv[1]
            with open(csv_file, "a") as file:
                file.write(output + "\n")
            ```

        === "Output `extended_metadata.csv`"

            | file_name           | song                    | author             | album                      | year | link                         | transcription | AQ_w | AQ_i | AQ_b | AQ_o | AQ | CSl | IB_guitar | IB_percussion | IB_jaleos | IB_others | IB | palo | quejios | region | sex |
            |---------------------|-------------------------|--------------------|----------------------------|------|-----------------------------|---------------|------|------|------|------|----|-----|-----------|---------------|-----------|-----------|----|------|---------|--------|-----|
            | data/d7f36ef3e7.mp3 | De una mina de la Union | Camaron de la Isla | Son tus ojos dos estrellas | 1971 | https://youtu.be/VnKJnIU-8iY |               |             |      |      |      |      |    |     |           |               |           |           |    |      |         |        |     | 

            *Last fields are still empty, we will fill them in step 4.*

3. **Obtain and save the audio file.** I have to ways of doing this: (i) digitally recording a vynil record or (ii) downloading it from Youtube using [youtube-dl](https://github.com/ytdl-org/youtube-dl):

    ```
    youtube-dl -x --audio-format mp3 -o data/d7f36ef3e7.mp3 https://youtu.be/VnKJnIU-8iY
    ```

4. **Run pre-trained Whisper and obtain original transcription.** Since we will have to ultimately run Whisper on each audio file, I do it at this point since it is a nice starting point for manually transcribing the song. If there are words I can not understand, I try visiting other sources to complete the correct transcription.

    ??? note "For the first time..."
    
        Create a folder for pre-trained Whisper outputs:

        ```
        mkdir pre-whisper.out
        ```

    - Run pre-trained Whisper: 

    ```
    nohup whisper data/d7f36ef3e7.mp3 --model medium --task transcribe --language es -f txt -o pre-whisper.out/d7f36ef3e7 &
    ```

    - Manually correct transcription in a copy of Whisper TXT output (`original_d7f36ef3e7.txt`):
    
    ```
    cd pre-whisper.out/d7f36ef3e7
    cp d7f36ef3e7.txt original_d7f36ef3e7.txt
    ```

    - Format correct transcription to remove punctuation marks and convert line breaks to white spaces:

    ```
    bash ../../../../scripts/outformat_whisper.sh original_d7f36ef3e7.txt
    ```

    ??? info "*outformat_whisper.sh*"

        ``` bash
        #!/bin/bash

        # Check if a file name is provided
        if [ $# -eq 0 ]; then
            echo "Please provide the file name as an argument."
            exit 1
        fi

        # Check if the file exists
        if [ ! -f "$1" ]; then
            echo "File '$1' not found."
            exit 1
        fi

        # Process the file
        temp_file="temp.txt"
        sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g' -e 's/[[:punct:]]//g' -e 's/.*/\L&/' "$1" > "$temp_file"
        mv "$temp_file" "$1"

        echo "File '$1' has been processed and overwritten."
        ```

5. **Manually extract features from the audio file.** I use the [*Edit CSV*](https://marketplace.visualstudio.com/items?itemName=janisdd.vscode-edit-csv) VSCode extension to comfortably fill out the `extended_metadata.csv` file. 

    1. **Transcription.** Copy transcription from `original_d7f36ef3e7.txt` to the *transcription* field of the `extended_metadata.csv` file.

    2. **Audio quality (AQ).** Try to identify each type of sound imperfection one at a time, and put "1" if we detect each (we can put 2 if the imperfection is exagerated): 

        - *White noise (AQ_w):* static background noises ([example](https://www.youtube.com/watch?v=9nVqUubzfcQ)).

        - *Impulse noise (AQ_i):* unwanted instantaneous sharp sounds, like clicks and pops ([example](https://www.youtube.com/watch?v=9nVqUubzfcQ)).

        - *Background noise (AQ_b):* any other sound besides the ones being monitored (we can include echo in this category) ([example](https://www.youtube.com/watch?v=hr0WqjKXgys)).

        - *Oversaturation:* vocals are so loud that sound is distorted ([example](https://www.youtube.com/watch?v=raQ9jjPaZSs)).

    3. **Cultural-specific lyrics (CSl).** Use `word_count.sh` to determine total number of unique words and manually look the list for cultural-specific lyrics. Divide the later by the first to obtain the score. 

        === "Running `word_count.sh`"
        
            ```
            bash ../../../../scripts/word_count.sh original_d7f36ef3e7.txt
            ```

        === "`word_count.sh`"

            ```bash
            #!/bin/bash 
            # Check if a file name is provided
            if [ $# -eq 0 ]; then
                echo "Please provide the file name as an argument."
                exit 1
            fi

            # Check if the file exists
            if [ ! -f "$1" ]; then
                echo "File '$1' not found."
                exit 1
            fi

            # Process the file
            word_count=$(tr -s '[:space:]' '\n' < "$1" | tr '[:upper:]' '[:lower:]' | tr -d '[:punct:]' | sort | uniq -c)

            # Output the number of unique words
            echo "Number of unique words: $(echo "$word_count" | wc -l)"

            # Output the count of occurrences for each word
            echo "Word occurrences:"
            echo "$word_count"
            ```

        === "Output exploration"
            
            There are a total of 24 unique words. There is no cultural-specific word, so the score would be:
            
            $CSl = (\frac{\text{# cultural-specific words}}{\text{# unique words}}) = \frac{0}{24} = 0$ 

            ``` hl_lines="1"
            Number of unique words: 24
            Word occurrences:
                2 a
                5 ay
                1 barrenero
                1 compañeros
                2 de
                1 dinero
                1 entre
                1 farol
                1 hacer
                2 la
                1 las
                2 me
                1 minas
                1 mis
                1 no
                1 porque
                1 que
                1 regalar
                1 tengo
                1 todos
                1 un
                2 unión
                2 van
                1 y
            ```

    4. **Instrumental background (IB).** Check for different instrumental backgrounds **at the same time as the vocals**, and add "1" to each one we detect (we will add "2" if it impairs lyrics understanding):
    
        - *IB_guitar:* check the presence of a guitar ([example](https://www.youtube.com/watch?v=WpighLFNLto)).

        - *IB_percussion:* check the presence of percussion (claps, *caja flamenca*, etc.) ([example](https://www.youtube.com/watch?v=bRjuEE2K4uw)).

        - *IB_jaleos:* check the presence of *jaleos* ([example](https://www.youtube.com/watch?v=bRjuEE2K4uw)).

        - *IB_others:* check the presence of other instruments (flute, piano, etc.) ([example](https://www.youtube.com/watch?v=zL1o4vMnfcE))

    5. **Palo.** Indicates the subgenre of flamenco to which the song belongs.

    6. **_Quejíos._** Refers to the proportion sorrow moans in the audio sample. To measure it, we use an [online tool](https://es.online-timers.com/varios-cronometros) with two simultaneos clocks: with one we measure the duration of the whole vocal part, and with the other the duration of the *quejíos* within the vocals. Finally, this feature is calculated like: 

        $\text{quejíos} = (\frac{\text{duration of quejíos (s)}}{\text{duration of vocals (s)}}) = \frac{31 (s)}{77 (s)} = 0.40 (s)$


    7. **Region and sex.** Fill out these fields according to the region of origin and the sex of the author. 


6. **Summarize metadata.** Summarize the variables AQ and IB of the `extended_metadata.csv` file to `metadata.csv`, which will be the one that we will use with 🤗:

    === "Running `summarize_metadata.py`"
    
        ```
        cd /home/jcalle/whisper/datasets/prEval
        python3 /home/jcalle/whisper/scripts/summarize_metadata.py extended_metadata.csv
        ```

    === "`summarize_metadata.py`"

        ```py
        import csv
        import sys

        # Function to combine AQ columns
        def combine_aq(aq_w, aq_i, aq_b, aq_o):
            aq_sum = aq_w + aq_i + aq_b + aq_o
            aq_combined = 5 - aq_sum
            aq_combined = max(aq_combined, 0)
            aq_combined = min(aq_combined, 5)
            return aq_combined

        # Function to combine IB columns
        def combine_ib(ib_guitar, ib_percussion, ib_jaleos, ib_others):
            ib_combined = ib_guitar + ib_percussion + ib_jaleos + ib_others
            ib_combined = min(ib_combined, 5)
            ib_combined = max(ib_combined, 0)
            return ib_combined

        # Check if a file name is provided as a command-line argument
        if len(sys.argv) < 2:
            print("Please provide the input CSV file as an argument.")
            sys.exit(1)

        # Specify output file name
        output_file = "metadata.csv"

        # Read input file and combine columns
        with open(sys.argv[1], "r") as csvfile_in, open(output_file, "w", newline="") as csvfile_out:
            reader = csv.DictReader(csvfile_in)
            fieldnames_out = ['file_name', 'song', 'author', 'album', 'year', 'link', 'transcription',
                            'AQ', 'CSl', 'IB', 'palo', 'quejios', 'region', 'sex']
            writer = csv.DictWriter(csvfile_out, fieldnames=fieldnames_out)
            writer.writeheader()

            for row in reader:
                aq_combined = combine_aq(float(row['AQ_w']), float(row['AQ_i']), float(row['AQ_b']), float(row['AQ_o']))
                ib_combined = combine_ib(float(row['IB_guitar']), float(row['IB_percussion']), float(row['IB_jaleos']), float(row['IB_others']))

                output_row = {
                    'file_name': row['file_name'],
                    'song': row['song'],
                    'author': row['author'],
                    'album': row['album'],
                    'year': row['year'],
                    'link': row['link'],
                    'transcription': row['transcription'],
                    'AQ': aq_combined,
                    'CSl': row['CSl'],
                    'IB': ib_combined,
                    'palo': row['palo'],
                    'quejios': row['quejios'],
                    'region': row['region'],
                    'sex': row['sex']
                }

                writer.writerow(output_row)

        print("Output file has been created: " + output_file)
        ```

    === "Output `metadata.csv`"
        
        | file_name           | song                    | author             | album                      | year | link                         | transcription                                                                                                                                               | AQ  | CSl | IB  | palo   | quejios | region | sex  |
        |---------------------|-------------------------|--------------------|----------------------------|------|------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|-----|-----|-----|--------|---------|--------|------|
        | data/d7f36ef3e7.mp3 | De una mina de la Union | Camaron de la Isla | Son tus ojos dos estrellas | 1971 | https://youtu.be/VnKJnIU-8iY | ay ay ay que ay la unión me van a hacer barrenero de las minas de la unión y entre todos mis compañeros ay me van a regalar un farol porque no tengo dinero | 5.0 |   0 | 1.0 | minera |    0.40 | Cadiz  | male |


7. **Push changes** to the 🤗 repository

    ```
    cd /home/jcalle/whisper/datasets/prEval/
    git add .
    git commit -m 'New files added to the dataset"
    git push
    ```