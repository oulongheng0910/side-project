# Visualization and Explanation: Word Prediction System in MATLAB

## Introduction

Hello, teacher! I’m here to explain how my **Word Prediction System** in MATLAB works, focusing on what each function does, how they connect, and what the program looks like when running. This system predicts the next word you might type, like autocomplete on a phone, using a text file’s patterns. I’ll describe the **GUI’s appearance**, explain each function with examples, and show how they work together with a **workflow visualization**. Since I can’t show live images, I’ll use text to paint a clear picture, including a pseudo-screenshot and a connection map. I’ll also highlight key points for my presentation and anticipate your questions.

### Goals
- Show what the program looks like (GUI layout).
- Explain each function’s role and output using a sample text.
- Visualize how functions connect to produce predictions.
- Prepare for your questions to demonstrate understanding.

### Sample Text
I’ll use a sample file, `sample.txt`, with:
```
The cat jumps. The dog runs.
```

### Note on Images
I’ll describe visuals textually (GUI layout, workflow). If you want a diagram, I can provide a **Mermaid flowchart** (Markdown-compatible) or guide you to draw one in PowerPoint. Let me know!

---

## Visualization: What Does the Program Look Like?

The program runs in a **Graphical User Interface (GUI)**, a window where you interact with the system. Here’s a text-based description of how it looks, like a pseudo-screenshot:

### Pseudo-Screenshot of the GUI
```
+------------------------------------------------------------+
| Word Prediction System                                     |
+------------------------------------------------------------+
| Unigram: [_________]                                       |
| Bigram:  [_________]                                       |
| Trigram: [_________]                                       |
| [Load Text File] [Predict All] [Save Models] [Load Models] |
+------------------------------------------------------------+
| Predictions Output:                                        |
| Unigram: [word (prob%)]                                    |
| Bigram:  [word (prob%) or "No prediction"]                 |
| Trigram: [word (prob%) or "No prediction"]                 |
| Co-occurrence: [word (prob%) or "No prediction"]           |
+------------------------------------------------------------+
| Statistics:                                                |
| Total words: X, Unique words: Y                            |
+------------------------------------------------------------+
| Top 5 Words:                                               |
| word1: count, word2: count, ...                            |
+------------------------------------------------------------+
| [Co-occurrence Chart: Bar plot of top word pairs]          |
+------------------------------------------------------------+
```

**Description**:
- **Window**: A 1000x700 pixel window titled “Word Prediction System.”
- **Top Section**: Three text fields labeled “Unigram,” “Bigram,” “Trigram” for input (e.g., type “the” or “the cat”).
- **Buttons**: Four buttons below:
  - **Load Text File**: Opens a file picker to load `sample.txt`.
  - **Predict All**: Runs predictions for all inputs.
  - **Save Models**: Saves models to a `.mat` file.
  - **Load Models**: Loads saved models.
- **Middle Section**: A text area showing predictions (e.g., “Bigram: cat (100%)”).
- **Bottom Left**:
  - **Statistics**: Shows “Total words: 6, Unique words: 4” (for our sample).
  - **Top 5 Words**: Lists words like “the: 2, cat: 1, dog: 1, jumps: 1, runs: 1.”
- **Bottom Right**: A bar chart showing top co-occurring word pairs (e.g., “the-cat,” “cat-jumps”).

**What to Say**:
- “When you run the program, a window pops up with text fields to type words, buttons to load files or predict, and areas for results. The chart shows which words appear together, like ‘the’ and ‘cat.’ It’s user-friendly—no coding needed!”

---

## How Each Function Works

Let’s break down each function, explaining its purpose, mechanics, and output using the sample text: “The cat jumps. The dog runs.” I’ll keep it simple, like explaining to a classmate, and include examples.

### 1. Entry Point: `word_prediction_system`

**Code**:
```matlab
function word_prediction_system()
    % Entry point to run the Word Prediction GUI
    wordPredictionSystemGUI();
end
```

**Purpose**:
- Starts the program by launching the GUI.

**How It Works**:
- Calls `wordPredictionSystemGUI()` to create the window with text fields, buttons, etc.
- It’s like flipping the “on” switch.

**Output**:
- Opens the GUI window (see pseudo-screenshot above).

**Example**:
- Run `word_prediction_system` in MATLAB → GUI appears, empty until a file is loaded.

**What to Say**:
- “This is the starting point. It runs the GUI function to open the prediction window.”

### 2. Text Processing: `readAndCleanText`

**Code** (simplified):
```matlab
function [tokens, vocab, wordCounts, totalWords] = readAndCleanText(filename)
    text = lower(fileread(filename));
    text = regexprep(text, '[^\w\s]', '');
    tokens = regexp(text, '\w+', 'match');
    totalWords = length(tokens);
    vocab = unique(tokens);
    [uniqueWords, ~, idx] = unique(tokens);
    counts = accumarray(idx, 1);
    wordCounts = containers.Map(uniqueWords, counts);
end
```

**Purpose**:
- Reads a text file, cleans it, and prepares data for models.

**How It Works**:
- **Read**: Loads file with `fileread`.
- **Clean**: Makes lowercase (`lower`), removes punctuation (`regexprep`).
- **Tokenize**: Splits into words (`regexp`).
- **Count**: Creates `tokens` (all words), `vocab` (unique words), `wordCounts` (frequencies), and `totalWords`.

**Output**:
- For `sample.txt`: “The cat jumps. The dog runs.”
  - `tokens = {"the", "cat", "jumps", "the", "dog", "runs"}`
  - `vocab = {"cat", "dog", "jumps", "runs", "the"}`
  - `wordCounts`: `the: 2, cat: 1, dog: 1, jumps: 1, runs: 1`
  - `totalWords = 6`

**Example**:
- Input: “The cat jumps.”
- Output: `tokens = {"the", "cat", "jumps"}`, `vocab = {"cat", "jumps", "the"}`, `wordCounts`: `the: 1, cat: 1, jumps: 1`, `totalWords = 3`

**What to Say**:
- “This function reads the text file, cleans it by removing punctuation and making it lowercase, and turns it into a list of words and their counts. It’s like preparing a recipe’s ingredients before cooking.”

### 3. Unigram Model: `buildUnigram`

**Code** (simplified):
```matlab
function unigramModel = buildUnigram(tokens)
    [uniqueWords, ~, idx] = unique(tokens);
    counts = accumarray(idx, 1);
    total = sum(counts);
    probs = counts / total;
    unigramModel = containers.Map(uniqueWords, probs);
end
```

**Purpose**:
- Predicts words based on their frequency, ignoring context.

**How It Works**:
- Counts each word’s occurrences.
- Divides by `totalWords` to get probabilities.
- Stores in `unigramModel` (a dictionary).

**Output**:
- For `tokens = {"the", "cat", "jumps", "the", "dog", "runs"}`:
  - `unigramModel`: `the: 2/6 = 0.333, cat: 1/6 = 0.167, dog: 0.167, jumps: 0.167, runs: 0.167`

**Example**:
- Predict: Highest probability is “the” (0.333).

**What to Say**:
- “The unigram model predicts words based on how common they are, like picking a word from a bag where ‘the’ is twice as likely because it appears twice.”

### 4. Bigram Model: `buildBigram`

**Code** (simplified):
```matlab
function bigramModel = buildBigram(tokens)
    bigramCounts = containers.Map('KeyType', 'char', 'ValueType', 'any');
    for i = 1:length(tokens)-1
        key = tokens{i};
        next = tokens{i+1};
        if isKey(bigramCounts, key)
            bigramCounts(key) = [bigramCounts(key), {next}];
        else
            bigramCounts(key) = {next};
        end
    end
    keysList = keys(bigramCounts);
    bigramModel = containers.Map();
    for i = 1:length(keysList)
        nextWords = bigramCounts(keysList{i});
        [uniqueWords, ~, idx] = unique(nextWords);
        counts = accumarray(idx, 1);
        [~, maxIdx] = max(counts);
        probDist = counts / sum(counts);
        bigramModel(keysList{i}) = struct('word', uniqueWords{maxIdx}, ...
                                          'prob', probDist(maxIdx));
    end
end
```

**Purpose**:
- Predicts the next word based on the previous word.

**How It Works**:
- Builds `bigramCounts`: Maps each word to its following words.
- Calculates probabilities for next words.
- Stores the most likely next word in `bigramModel`.

**Output**:
- For `tokens = {"the", "cat", "jumps", "the", "dog", "runs"}`:
  - Bigrams: (“the”, “cat”), (“cat”, “jumps”), (“jumps”, “the”), (“the”, “dog”), (“dog”, “runs”)
  - `bigramModel`: `the: {"cat" or "dog", 0.5}, cat: {"jumps", 1.0}, jumps: {"the", 1.0}, dog: {"runs", 1.0}`

**Example**:
- Input: “the” → Predict “cat” (0.5) or “dog” (0.5).

**What to Say**:
- “Bigrams predict based on the previous word, like knowing ‘the’ is followed by ‘cat’ or ‘dog.’ It only keeps the top prediction.”

### 5. Trigram Model: `buildTrigram`

**Code** (simplified):
```matlab
function trigramModel = buildTrigram(tokens)
    trigramCounts = containers.Map('KeyType', 'char', 'ValueType', 'any');
    for i = 1:length(tokens)-2
        key = sprintf('%s %s', tokens{i}, tokens{i+1});
        next = tokens{i+2};
        if isKey(trigramCounts, key)
            trigramCounts(key) = [trigramCounts(key), {next}];
        else
            trigramCounts(key) = {next};
        end
    end
    keysList = keys(trigramCounts);
    trigramModel = containers.Map();
    for i = 1:length(keysList)
        nextWords = trigramCounts(keysList{i});
        [uniqueWords, ~, idx] = unique(nextWords);
        counts = accumarray(idx, 1);
        [~, maxIdx] = max(counts);
        probDist = counts / sum(counts);
        trigramModel(keysList{i}) = struct('word', uniqueWords{maxIdx}, ...
                                           'prob', probDist(maxIdx));
    end
end
```

**Purpose**:
- Predicts based on the previous two words.

**How It Works**:
- Maps two-word sequences to next words.
- Stores the most likely next word.

**Output**:
- Trigrams: (“the cat”, “jumps”), (“cat jumps”, “the”), (“jumps the”, “dog”), (“the dog”, “runs”)
- `trigramModel`: `the cat: {"jumps", 1.0}, cat jumps: {"the", 1.0}, jumps the: {"dog", 1.0}, the dog: {"runs", 1.0}`

**Example**:
- Input: “the cat” → Predict “jumps” (1.0).

**What to Say**:
- “Trigrams use two previous words for more context, like ‘the cat’ predicting ‘jumps.’ It’s accurate but needs more data.”

### 6. Co-Occurrence Matrix: `buildCoOccurrence`

**Code** (simplified):
```matlab
function coMatrix = buildCoOccurrence(tokens, vocab, windowSize)
    N = length(vocab);
    coMatrix = zeros(N);
    word2idx = containers.Map(vocab, 1:N);
    for i = 1:length(tokens)
        center = tokens{i};
        if ~isKey(word2idx, center), continue; end
        centerIdx = word2idx(center);
        for j = max(1, i-windowSize):min(length(tokens), i+windowSize)
            if j == i, continue; end
            context = tokens{j};
            if isKey(word2idx, context)
                contextIdx = word2idx(context);
                coMatrix(centerIdx, contextIdx) = coMatrix(centerIdx, contextIdx) + 1;
            end
        end
    end
end
```

**Purpose**:
- Counts how often words appear near each other (within `windowSize`).

**How It Works**:
- Creates an NxN matrix (`N = length(vocab)`).
- For each word, counts neighbors within `windowSize`.
- Updates `coMatrix` with counts.

**Output** (for `windowSize = 1`):
- Vocab: `{"cat", "dog", "jumps", "runs", "the"}`
- Matrix (simplified):
  ```
      cat  dog  jumps  runs  the
  cat   0    0     1     0    1
  dog   0    0     0     1    1
  jumps 1    0     0     0    1
  runs  0    1     0     0    1
  the   1    1     1     1    0
  ```

**Example**:
- “cat” is near “jumps” (1 time), “the” (1 time).

**What to Say**:
- “This builds a matrix showing which words are ‘friends,’ appearing near each other. It’s like a chart of who hangs out together.”

### 7. Co-Occurrence Prediction: `predictFromCoMatrix`

**Code** (simplified):
```matlab
function [word, prob] = predictFromCoMatrix(coMatrix, vocab, inputWords)
    word2idx = containers.Map(vocab, 1:length(vocab));
    if isempty(inputWords)
        word = 'no input'; prob = 0; return;
    end
    lastWord = inputWords{end};
    if ~isKey(word2idx, lastWord)
        word = 'unknown word'; prob = 0; return;
    end
    idx = word2idx(lastWord);
    rowSum = sum(coMatrix(idx, :));
    if rowSum == 0
        word = 'no co-occurrence'; prob = 0; return;
    end
    probs = coMatrix(idx, :) / rowSum;
    [maxProb, maxIdx] = max(probs);
    word = vocab{maxIdx};
    prob = maxProb;
end
```

**Purpose**:
- Predicts the next word based on co-occurrences.

**How It Works**:
- Takes the last word’s row in `coMatrix`.
- Normalizes to probabilities.
- Picks the top word.

**Output**:
- Input: `{"cat"}`
- Row: `[0, 0, 1, 0, 1]`, Probabilities: `jumps: 0.5, the: 0.5`
- Predict: “jumps” (0.5)

**What to Say**:
- “This uses the matrix to predict words that often appear near the input, like ‘jumps’ after ‘cat’ because they’re close in the text.”

### 8. GUI: `wordPredictionSystemGUI`

**Code** (simplified):
```matlab
function wordPredictionSystemGUI()
    fig = uifigure('Name', 'Word Prediction System', 'Position', [100, 100, 1000, 700]);
    uilabel(fig, 'Text', 'Unigram:', 'Position', [20, 620, 70, 20]);
    txtInput1 = uieditfield(fig, 'text', 'Position', [90, 620, 250, 30]);
    % Similar for Bigram, Trigram
    uibutton(fig, 'Text', 'Load Text File', 'Position', [370, 620, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) loadTextCallback(fig));
    txtOutput = uitextarea(fig, 'Position', [20, 300, 470, 190]);
    ax = uiaxes(fig, 'Position', [500, 250, 450, 300]);
    txtStats = uitextarea(fig, 'Position', [20, 180, 470, 70], 'Editable', 'off');
    txtTopWords = uitextarea(fig, 'Position', [20, 50, 470, 100], 'Editable', 'off');
    fig.UserData.txtInput1 = txtInput1; % Store handles
end
```

**Purpose**:
- Creates the GUI window for user interaction.

**How It Works**:
- Uses `uifigure`, `uibutton`, `uitextarea`, etc., to build the interface.
- Stores handles in `fig.UserData` for callbacks.

**Output**:
- The GUI window (see pseudo-screenshot).

**What to Say**:
- “This sets up the GUI where users load files, type words, and see predictions. It’s like a dashboard for the system.”

### 9. Callbacks

#### 9.1 `loadTextCallback`
- **Purpose**: Loads a file, processes it, builds models, shows stats.
- **How**: Calls `readAndCleanText`, `buildUnigram`, etc., updates `txtStats`, `txtTopWords`.
- **Output**: Stats like “Total words: 6, Unique words: 4”.

#### 9.2 `saveModelsCallback`
- **Purpose**: Saves models to a `.mat` file.
- **How**: Stores models in a `struct` and saves.

#### 9.3 `loadModelsCallback`
- **Purpose**: Loads saved models.
- **How**: Restores `fig.UserData`.

#### 9.4 `predictCallback`
- **Purpose**: Makes predictions and shows a chart.
- **How**: Queries models, displays in `txtOutput`, plots top co-occurrences in `ax`.

**What to Say**:
- “Callbacks handle user actions. `loadTextCallback` processes the file, `predictCallback` shows predictions, and others save or load models.”

---

## How Functions Connect: Workflow Visualization

Here’s a text-based **workflow map** showing how functions connect, like a flowchart. It traces the program’s operation from start to prediction.

### Workflow Map
```
[Start]
   |
   v
[word_prediction_system]
   | Calls
   v
[wordPredictionSystemGUI]
   | Creates GUI, stores handles in fig.UserData
   | User clicks "Load Text File"
   v
[loadTextCallback]
   | Calls
   v
[readAndCleanText]
   | Outputs: tokens, vocab, wordCounts, totalWords
   | Calls (using outputs)
   v
+-----------------------------------+
| [buildUnigram] -> unigramModel    |
| [buildBigram]  -> bigramModel     |
| [buildTrigram] -> trigramModel    |
| [buildCoOccurrence] -> coMatrix   |
+-----------------------------------+
   | Stores models in fig.UserData
   | Updates txtStats, txtTopWords
   | User types input, clicks "Predict All"
   v
[predictCallback]
   | Queries models:
   | - unigramModel (direct lookup)
   | - bigramModel (last word)
   | - trigramModel (last two words)
   | - predictFromCoMatrix (coMatrix, last word)
   | Updates txtOutput with predictions
   | Plots co-occurrence chart in ax
   v
[End: User sees predictions and chart]
```

**Explanation**:
1. **Start**: Run `word_prediction_system`, which opens the GUI (`wordPredictionSystemGUI`).
2. **Load File**: User clicks “Load Text File,” triggering `loadTextCallback`.
3. **Process Text**: `loadTextCallback` calls `readAndCleanText` to get `tokens`, `vocab`, etc.
4. **Build Models**: `loadTextCallback` uses `tokens` and `vocab` to call:
   - `buildUnigram` → `unigramModel`
   - `buildBigram` → `bigramModel`
   - `buildTrigram` → `trigramModel`
   - `buildCoOccurrence` → `coMatrix`
5. **Store and Display**: Models are stored in `fig.UserData`; stats and top words update in the GUI.
6. **Predict**: User types words (e.g., “the cat” in trigram field) and clicks “Predict All,” triggering `predictCallback`.
7. **Show Results**: `predictCallback` queries models, shows predictions in `txtOutput`, and plots a co-occurrence chart.

**Data Flow**:
- `tokens` and `vocab` from `readAndCleanText` feed into all model-building functions.
- `fig.UserData` acts as a central hub, storing models and GUI handles.
- `predictCallback` uses `fig.UserData` to access models and inputs.

**What to Say**:
- “The functions work like a pipeline: the program starts with the GUI, processes a text file to get words, builds four models, and uses them to predict when the user clicks a button. `fig.UserData` connects everything by storing the models and GUI parts.”

---

## Key Points for Your Presentation

Here’s how to present to your teacher (5-10 minutes):
1. **Introduce the System** (1 min):
   - “This is a Word Prediction System, like autocomplete. It reads a text file, builds models, and predicts words in a GUI. I’ll use ‘The cat jumps. The dog runs.’ to explain.”
   - Show the pseudo-screenshot or describe the GUI.
2. **Explain Functions** (3-4 min):
   - **Entry/GUI**: “`word_prediction_system` starts the GUI, which has text fields and buttons.”
   - **Text Processing**: “`readAndCleanText` turns the text into words and counts, like `the: 2`.”
   - **Models**: “Unigram predicts by frequency, bigram by one word, trigram by two, and co-occurrence by nearby words.”
   - **Callbacks**: “`predictCallback` shows predictions, like ‘jumps’ after ‘the cat’.”
   - Use the example: “For ‘the cat,’ trigram predicts ‘jumps’ (100%).”
3. **Show Connections** (1-2 min):
   - “The workflow is: start → load file → process text → build models → predict. `fig.UserData` links everything.”
   - Reference the workflow map (draw it on a whiteboard if possible).
4. **Highlight Limitation** (1 min):
   - “The models don’t use Laplace smoothing, so unseen inputs like ‘cat sleeps’ give ‘No prediction.’ Smoothing would give a small chance to every word.”
5. **Conclude** (1 min):
   - “This project shows text processing, n-grams, and GUIs in MATLAB. I can demo it or answer questions!”

**Visual Aid**:
- **Whiteboard**: Draw the workflow map:
  ```
  Start -> GUI -> Load File -> readAndCleanText -> [Unigram, Bigram, Trigram, Co-Occurrence] -> Predict -> Results
  ```
- **GUI Demo**: If possible, run the code and show the GUI with `sample.txt`.

---

## Anticipated Teacher Questions and Answers

Here are questions your teacher might ask, with answers to prepare you:

1. **Q**: Can you walk me through what happens when I click “Load Text File”?
   - **A**: Clicking “Load Text File” runs `loadTextCallback`. It calls `readAndCleanText` to read and clean the file, producing `tokens` and `vocab`. Then it builds the unigram, bigram, trigram, and co-occurrence models using these, stores them in `fig.UserData`, and updates the GUI with stats like “Total words: 6.”

2. **Q**: Why does the program sometimes say “No prediction”?
   - **A**: It happens when the input (e.g., “cat sleeps” for bigram) wasn’t in the training text. The models use maximum likelihood estimation without smoothing, so unseen sequences get zero probability. Laplace smoothing could fix this by adding 1 to all counts.

3. **Q**: How does the co-occurrence matrix differ from n-grams?
   - **A**: N-grams (bigrams, trigrams) predict based on exact word sequences (e.g., “the” → “cat”). The co-occurrence matrix counts words near each other, regardless of order, like “cat” near “jumps” within a window. It captures broader relationships.

4. **Q**: What’s the role of `fig.UserData`?
   - **A**: It’s like a shared storage space. It holds the GUI components (text fields, buttons) and models (unigram, bigram, etc.), so callbacks like `predictCallback` can access them to show predictions or update the screen.

5. **Q**: How would you add Laplace smoothing?
   - **A**: For `buildBigram`, I’d add 1 to the count of every possible next word in the vocabulary and add the vocabulary size to the denominator. For example, if “cat” is followed by “jumps” once, instead of `P(jumps|cat) = 1`, it’d be `(1+1)/(1+vocab_size)`, giving unseen words like “sleeps” a small chance.

6. **Q**: Why clean the text (lowercase, remove punctuation)?
   - **A**: Cleaning ensures consistency. Lowercase makes “Cat” and “cat” the same word, and removing punctuation prevents “jumps!” and “jumps” from being different. It makes the models more accurate.

7. **Q**: How does `windowSize` affect the co-occurrence matrix?
   - **A**: A larger `windowSize` counts words farther apart, making the matrix denser but less focused. A smaller `windowSize` (e.g., 1) only counts immediate neighbors, like bigrams, for tighter relationships.

---

## Optional: Mermaid Flowchart

If your presentation platform supports Mermaid (e.g., GitHub, some Markdown editors), here’s a flowchart you can include:

```mermaid
graph TD
    A[Start: word_prediction_system] --> B[GUI: wordPredictionSystemGUI]
    B -->|User clicks Load| C[loadTextCallback]
    C --> D[readAndCleanText]
    D -->|tokens, vocab| E[buildUnigram]
    D -->|tokens| F[buildBigram]
    D -->|tokens| G[buildTrigram]
    D -->|tokens, vocab| H[buildCoOccurrence]
    E -->|unigramModel| I[fig.UserData]
    F -->|bigramModel| I
    G -->|trigramModel| I
    H -->|coMatrix| I
    I -->|User clicks Predict| J[predictCallback]
    J -->|Queries models| K[Predictions in txtOutput]
    J -->|Plots| L[Co-occurrence Chart in ax]
    K --> M[End]
    L --> M
```

**To Use**:
- Copy this into a Mermaid-compatible editor.
- Or describe it: “The flowchart starts at `word_prediction_system`, goes to the GUI, processes text, builds models, and ends with predictions.”

---

## Preparation Tips

1. **Practice the Explanation**:
   - Use the workflow map and function descriptions.
   - Time your talk (5-10 minutes).
   - Example: “The program starts with the GUI, processes ‘The cat jumps’ into words, builds models, and predicts ‘jumps’ after ‘the cat.’”

2. **Test the Code**:
   - Run `word_prediction_system` with `sample.txt`.
   - Try inputs: Unigram (blank), Bigram (“the”), Trigram (“the cat”).
   - Note “No prediction” for unseen inputs (e.g., “cat sleeps”).

3. **Visualize for Teacher**:
   - **Whiteboard**: Draw the workflow map or co-occurrence matrix:
     ```
     the  cat  jumps
     the   0    1     1
     cat   1    0     1
     jumps 1    1     0
     ```
   - **GUI Demo**: Show the GUI live, pointing out text fields, buttons, and outputs.

4. **Highlight Smoothing**:
   - “The models don’t use Laplace smoothing, so unseen inputs fail. Smoothing would add 1 to all counts, giving every word a chance.”

5. **Prepare for Questions**:
   - Review the questions above, especially about smoothing, `fig.UserData`, and model differences.

---

## Conclusion

This guide visualizes the Word Prediction System’s GUI and workflow, explaining each function’s role and how they connect. The system starts with a GUI, processes text, builds four models, and predicts words based on user input. The workflow map shows the flow from text to predictions, with `fig.UserData` linking everything. I’ve highlighted the lack of smoothing as a limitation and suggested fixes like Laplace smoothing. I’m ready to demo the GUI, draw the workflow, or answer your questions!

**Key Takeaways**:
- The GUI makes the system user-friendly.
- Functions are modular: text processing, model building, predictions.
- No smoothing causes “No prediction” for unseen inputs.

Thank you, teacher, for listening! I can show the program or explain more if you’d like.