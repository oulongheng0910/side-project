function word_prediction_system()
    % Entry point to run the Word Prediction GUI
    wordPredictionSystemGUI();
end

%% === 1. READ AND CLEAN TEXT ===
function [tokens, vocab, wordCounts, totalWords] = readAndCleanText(filename)
    % Read, clean, tokenize, and count words
    text = lower(fileread(filename)); %read
    text = regexprep(text, '[^\w\s]', ''); % prepare by regexprep
    tokens = regexp(text, '\w+', 'match'); % Splits the cleaned text into individual words using regexp.
    totalWords = length(tokens);  % Add total word count
    vocab = unique(tokens);
    
    % Count word frequencies
    [uniqueWords, ~, idx] = unique(tokens);
    counts = accumarray(idx, 1); % number of indice
    wordCounts = containers.Map(uniqueWords, counts); % count words
end

%% === 2. BUILD LANGUAGE MODELS ===
function unigramModel = buildUnigram(tokens)
    [uniqueWords, ~, idx] = unique(tokens);
    counts = accumarray(idx, 1);
    total = sum(counts);
    probs = counts / total;
    unigramModel = containers.Map(uniqueWords, probs);
end

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

    % get a bucnch of list after biagramcount then group each word to find
    % the unique one and total index
    keysList = keys(bigramCounts);
    bigramModel = containers.Map();
    for i = 1:length(keysList)
        nextWords = bigramCounts(keysList{i});
        [uniqueWords, ~, idx] = unique(nextWords);
        counts = accumarray(idx, 1) + 1;
        [~, maxIdx] = max(counts);
        probDist = counts / sum(counts);
        bigramModel(keysList{i}) = struct('word', uniqueWords{maxIdx}, ...
                                          'prob', probDist(maxIdx));
    end
end

function trigramModel = buildTrigram(tokens)
    trigramCounts = containers.Map('KeyType', 'char', 'ValueType', 'any');
    % create empty map for dictionary
    % to find the total triagramcounts
    for i = 1:length(tokens)-2
        key = sprintf('%s %s', tokens{i}, tokens{i+1});
        next = tokens{i+2};
        if isKey(trigramCounts, key)
            trigramCounts(key) = [trigramCounts(key), {next}];
        else
            trigramCounts(key) = {next};
        end
    end
% to find make it as a list and find the most word and pro
    keysList = keys(trigramCounts);
    trigramModel = containers.Map();
    for i = 1:length(keysList)
        nextWords = trigramCounts(keysList{i});
        [uniqueWords, ~, idx] = unique(nextWords);
        counts = accumarray(idx, 1) + 1;
        [~, maxIdx] = max(counts);
        probDist = counts / sum(counts);
        trigramModel(keysList{i}) = struct('word', uniqueWords{maxIdx}, ...
                                           'prob', probDist(maxIdx));
    end
end

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

function [word, prob] = predictFromCoMatrix(coMatrix, vocab, inputWords)
    word2idx = containers.Map(vocab, 1:length(vocab));
    
    if isempty(inputWords)
        word = 'no input';
        prob = 0;
        return;
    end
    
    lastWord = inputWords{end};
    if ~isKey(word2idx, lastWord)
        word = 'unknown word';
        prob = 0;
        return;
    end

    idx = word2idx(lastWord);
    rowSum = sum(coMatrix(idx, :));
    if rowSum == 0
        word = 'no co-occurrence';
        prob = 0;
        return;
    end
    
    probs = coMatrix(idx, :) / rowSum;
    [maxProb, maxIdx] = max(probs);
    word = vocab{maxIdx};
    prob = maxProb;
end

%% === 3. GUI ===
function wordPredictionSystemGUI()
    fig = uifigure('Name', 'Word Prediction System', 'Position', [100, 100, 1000, 700]);

    % Input fields
    uilabel(fig, 'Text', 'Unigram:', 'Position', [20, 620, 70, 20]);
    txtInput1 = uieditfield(fig, 'text', 'Position', [90, 620, 250, 30]);

    uilabel(fig, 'Text', 'Bigram:', 'Position', [20, 580, 70, 20]);
    txtInput2 = uieditfield(fig, 'text', 'Position', [90, 580, 250, 30]);

    uilabel(fig, 'Text', 'Trigram:', 'Position', [20, 540, 70, 20]);
    txtInput3 = uieditfield(fig, 'text', 'Position', [90, 540, 250, 30]);

    % Buttons
    uibutton(fig, 'Text', 'Load Text File', 'Position', [370, 620, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) loadTextCallback(fig));

    uibutton(fig, 'Text', 'Predict All', 'Position', [370, 580, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) predictCallback(fig));
    
    % New buttons for save/load models
    uibutton(fig, 'Text', 'Save Models', 'Position', [500, 620, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) saveModelsCallback(fig));
    
    uibutton(fig, 'Text', 'Load Models', 'Position', [500, 580, 120, 30], ...
        'ButtonPushedFcn', @(btn, event) loadModelsCallback(fig));

    % Output area
    uilabel(fig, 'Text', 'Predictions:', 'Position', [20, 500, 100, 20]);
    txtOutput = uitextarea(fig, 'Position', [20, 300, 470, 190]);

    % Axes to show co-occurring word heatmap
    ax = uiaxes(fig, 'Position', [500, 250, 450, 300]);
    title(ax, 'Top Co-occurring Words');

    % Output for most frequent words and stats
    uilabel(fig, 'Text', 'Dataset Statistics:', 'Position', [20, 260, 200, 20]);
    txtStats = uitextarea(fig, 'Position', [20, 180, 470, 70], 'Editable', 'off');
    
    uilabel(fig, 'Text', 'Top Words in Dataset:', 'Position', [20, 160, 200, 20]);
    txtTopWords = uitextarea(fig, 'Position', [20, 50, 470, 100], 'Editable', 'off');

    % Store handles
    fig.UserData.txtInput1 = txtInput1;
    fig.UserData.txtInput2 = txtInput2;
    fig.UserData.txtInput3 = txtInput3;
    fig.UserData.txtOutput = txtOutput;
    fig.UserData.ax = ax;
    fig.UserData.txtTopWords = txtTopWords;
    fig.UserData.txtStats = txtStats;
end

function loadTextCallback(fig)
    [file, path] = uigetfile('*.txt', 'Select a Text File');
    if isequal(file, 0)
        uialert(fig, 'No file selected.', 'Warning');
        return;
    end

    fullpath = fullfile(path, file);
    [tokens, vocab, wordCounts, totalWords] = readAndCleanText(fullpath);

    % Build models
    fig.UserData.tokens = tokens;
    fig.UserData.vocab = vocab;
    fig.UserData.wordCounts = wordCounts;
    fig.UserData.unigramModel = buildUnigram(tokens);
    fig.UserData.bigramModel = buildBigram(tokens);
    fig.UserData.trigramModel = buildTrigram(tokens);
    fig.UserData.coMatrix = buildCoOccurrence(tokens, vocab, 2);
    fig.UserData.totalWords = totalWords;
    fig.UserData.uniqueWords = length(vocab);

    % Show statistics
    statsText = {
        sprintf('Total words: %d', totalWords);
        sprintf('Unique words: %d', length(vocab));
        sprintf('File: %s', file);
    };
    fig.UserData.txtStats.Value = statsText;

    % Show top 10 words
    keysList = keys(wordCounts);
    valuesList = cell2mat(values(wordCounts));
    [~, topIdx] = maxk(valuesList, 10);
    topWords = keysList(topIdx);
    topCounts = valuesList(topIdx);
    topText = strings(1, length(topWords));
    for i = 1:length(topWords)
        topText(i) = sprintf('%s (%d)', topWords{i}, topCounts(i));
    end
    fig.UserData.txtTopWords.Value = topText;

    uialert(fig, 'Text file loaded successfully!', 'Success');
end

function saveModelsCallback(fig)
    % Check if models exist
    if ~isfield(fig.UserData, 'unigramModel')
        uialert(fig, 'No models to save. Please load a text file first.', 'Warning');
        return;
    end
    
    [file, path] = uiputfile('*.mat', 'Save Models As');
    if isequal(file, 0)
        return; % User cancelled
    end
    
    % Collect all models and data to save
    models = struct();
    models.unigramModel = fig.UserData.unigramModel;
    models.bigramModel = fig.UserData.bigramModel;
    models.trigramModel = fig.UserData.trigramModel;
    models.coMatrix = fig.UserData.coMatrix;
    models.vocab = fig.UserData.vocab;
    models.wordCounts = fig.UserData.wordCounts;
    models.totalWords = fig.UserData.totalWords;
    models.uniqueWords = fig.UserData.uniqueWords;
    
    save(fullfile(path, file), 'models');
    uialert(fig, 'Models saved successfully!', 'Success');
end

function loadModelsCallback(fig)
    [file, path] = uigetfile('*.mat', 'Select Model File');
    if isequal(file, 0)
        return; % User cancelled
    end
    
    try
        loaded = load(fullfile(path, file));
        models = loaded.models;
        
        % Store loaded models in figure UserData
        fig.UserData.unigramModel = models.unigramModel;
        fig.UserData.bigramModel = models.bigramModel;
        fig.UserData.trigramModel = models.trigramModel;
        fig.UserData.coMatrix = models.coMatrix;
        fig.UserData.vocab = models.vocab;
        fig.UserData.wordCounts = models.wordCounts;
        fig.UserData.totalWords = models.totalWords;
        fig.UserData.uniqueWords = models.uniqueWords;
        
        % Update statistics display
        statsText = {
            sprintf('Total words: %d', models.totalWords);
            sprintf('Unique words: %d', models.uniqueWords);
            sprintf('File: %s (pre-saved models)', file);
        };
        fig.UserData.txtStats.Value = statsText;
        
        % Show top 10 words from loaded models
        keysList = keys(models.wordCounts);
        valuesList = cell2mat(values(models.wordCounts));
        [~, topIdx] = maxk(valuesList, 10);
        topWords = keysList(topIdx);
        topCounts = valuesList(topIdx);
        topText = strings(1, length(topWords));
        for i = 1:length(topWords)
            topText(i) = sprintf('%s (%d)', topWords{i}, topCounts(i));
        end
        fig.UserData.txtTopWords.Value = topText;
        
        uialert(fig, 'Models loaded successfully!', 'Success');
    catch
        uialert(fig, 'Error loading models. File might be corrupted.', 'Error');
    end
end

function predictCallback(fig)
    % Check if models are loaded
    if ~isfield(fig.UserData, 'unigramModel')
        uialert(fig, 'No models loaded. Please load a text file first.', 'Warning');
        return;
    end
    
    txt1 = lower(fig.UserData.txtInput1.Value);
    txt2 = lower(fig.UserData.txtInput2.Value);
    txt3 = lower(fig.UserData.txtInput3.Value);

    input1 = regexp(txt1, '\w+', 'match');
    input2 = regexp(txt2, '\w+', 'match');
    input3 = regexp(txt3, '\w+', 'match');

    % Unigram
    unigramModel = fig.UserData.unigramModel;
    keysU = keys(unigramModel);
    valsU = cell2mat(values(unigramModel));
    [maxP, maxIdx] = max(valsU);
    unigramWord = keysU{maxIdx};
    unigramProb = maxP;

    % Bigram
    bigramWord = 'No prediction'; bigramProb = 0;
    if ~isempty(input2)
        key = input2{end};
        if isKey(fig.UserData.bigramModel, key)
            res = fig.UserData.bigramModel(key);
            bigramWord = res.word;
            bigramProb = res.prob;
        end
    end

    % Trigram
    trigramWord = 'No prediction'; trigramProb = 0;
    if length(input3) >= 2
        key = sprintf('%s %s', input3{end-1}, input3{end});
        if isKey(fig.UserData.trigramModel, key)
            res = fig.UserData.trigramModel(key);
            trigramWord = res.word;
            trigramProb = res.prob;
        end
    end

    % Vector
    [vecWord, vecProb] = predictFromCoMatrix(fig.UserData.coMatrix, ...
                                             fig.UserData.vocab, ...
                                             input3);

    % Display predictions
    output = {
        sprintf('Unigram Prediction: %s (%.2f%%)', unigramWord, 100*unigramProb)
        sprintf('Bigram Prediction: %s (%.2f%%)', bigramWord, 100*bigramProb)
        sprintf('Trigram Prediction: %s (%.2f%%)', trigramWord, 100*trigramProb)
        sprintf('Vector Prediction: %s (%.2f%%)', vecWord, 100*vecProb)
    };
    fig.UserData.txtOutput.Value = output;

    % Co-occurrence chart
    if ~isempty(input3)
        word2idx = containers.Map(fig.UserData.vocab, 1:length(fig.UserData.vocab));
        last = input3{end};
        if isKey(word2idx, last)
            idx = word2idx(last);
            vec = fig.UserData.coMatrix(idx, :);
            [vals, inds] = maxk(vec, 5);
            bar(fig.UserData.ax, vals);
            xticklabels(fig.UserData.ax, fig.UserData.vocab(inds));
            fig.UserData.ax.XTickLabelRotation = 30;
        end
    end
end