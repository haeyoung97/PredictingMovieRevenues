%% *�ٰŸ� ���翡 ���� ��ȭ�� ���� ����*
%% �� *��ǥ : Ư�� �帣���� � �ٰŸ� ���縦 �����ؾ�*
%% *��ȭ�� ���൵ �� �������� â���س� �� �ִ°�*
% 
%% TMDB�� Raw Data
% 
% 
% * <internal:H_7F8A959C '��� �帣�� Word Cloud �ð�ȭ'>
%% �ؽ�Ʈ �����̼� ������ ��������
% 1. ���� �ʱ�ȭ

filename = 'Movies.csv';
delimiter = ',';
startRow = 2;
%% 
% 2. ������ ���� �ؽ�Ʈ�� �д´�.

formatSpec = '%q%q%q%q%*q%q%*q%*q%q%[^\n\r]';
%% 
% 3. �ؽ�Ʈ ������ ����.

fileID = fopen(filename,'r');
%% 
% 4. ���Ŀ� ����  ������ ���� �д´�.

dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
%% 
% 5. �ؽ�Ʈ ������ �ݴ´�.

fclose(fileID);
%% 
%% ������ �ؽ�Ʈ�� �ִ� ���� ������ ���ڷ� ��ȯ�ϱ�
% 
% 
% 1. �������� �ƴ� �ؽ�Ʈ�� NaN���� �ٲ۴�.

raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));
%% 
% 2. �Է� ���� �迭�� �ؽ�Ʈ�� ���ڷ� ��ȯ�ϰ�, �������� �ƴ� �ؽ�Ʈ�� NaN���� �ٲ۴�.

for col=[1,2,3]
     rawData = dataArray{col};
    for row=1:size(rawData, 1)
%% 
% 3. �������� �ƴ� ���λ� �� ���̻縦 �˻��ϰ� �����ϴ� ���� ǥ������ �����.

    regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
%% 
% 4. õ ������ �ƴ� ��ġ���� ��ǥ �˻��Ѵ�.

      invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^[-/+]*\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
%% 
% 5. ������ �ؽ�Ʈ�� ���ڷ� ��ȯ�Ѵ�.

             if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end
%% 
% 6. ������ ��¥ ������ ����� ��¥�� �ִ� ���� ������ MATLAB datatime������ ��ȯ�Ѵ�.

try
    dates{5} = datetime(dataArray{5}, 'Format', 'yyyy-MM-dd', 'InputFormat', 'yyyy-MM-dd');
catch
    try
        % ����ǥ�� ���� ��¥ ó��
        dataArray{5} = cellfun(@(x) x(2:end-1), dataArray{5}, 'UniformOutput', false);
        dates{5} = datetime(dataArray{5}, 'Format', 'yyyy-MM-dd', 'InputFormat', 'yyyy-MM-dd');
    catch
        dates{5} = repmat(datetime([NaN NaN NaN]), size(dataArray{5}));
    end
end

dates = dates(:,5);
%% 
% 7. �����͸� ������ ���� String�� ���� �����Ѵ�.

rawNumericColumns = raw(:, [1,2,3]);
rawStringColumns = string(raw(:, [4,6]));
%% 
% 8. �������� �ƴ� ���� NaN���� �ٲ۴�.

R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % �������� �ƴ� �� ã��
rawNumericColumns(R) = {NaN}; % �������� �ƴ� �� �ٲٱ�
%% 
% 9. <Undefined>�� �����ϴ� �ؽ�Ʈ�� <Undefined> categorical������ ��ȯ�Ǿ����� Ȯ���Ѵ�.

idx = (rawStringColumns(:, 2) == "<undefined>");
rawStringColumns(idx, 2) = "";
%% 
%% ������ �迭�� �� ���� �̸����� �Ҵ��ϱ�
% revenue1 : ��ȭ �� ����
% 
% vote_average1 : ��ȭ �� ����
% 
% vote_count1 : ��ȭ �� ������
% 
% title1 : ��ȭ ����
% 
% release_date1 : ��ȭ ������
% 
% genres1 : ��ȭ �帣

revenue1 = cell2mat(rawNumericColumns(:, 1));
vote_average1 = cell2mat(rawNumericColumns(:, 2));
vote_count1 = cell2mat(rawNumericColumns(:, 3));
title1 = rawStringColumns(:, 1);
release_date1 = dates{:, 1};
genres1 = rawStringColumns(:, 2);

for i=1:size(revenue1,1)
    if(revenue1(i,1)==0)
        revenue1(i,1)=NaN;
    end
end

k=1;

while ((release_date1(1,1)<datetime(1980,01,01)))
    
    revenue1(1)=[];
    vote_average1(1)=[];
    vote_count1(1)=[];
    title1(1)=[];
    release_date1(1)=[];
    genres1(1)=[];
    
end
%% 
% �ӽ� ���� �����

clearvars filename delimiter startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp dates blankDates anyBlankDates invalidDates anyInvalidDates rawNumericColumns rawStringColumns R idx;
%% 
%% �ؽ�Ʈ ���Ͽ��� ������ ��������
% 
% 
% 1. ���� �ʱ�ȭ

filename = 'movies_metadata_WITH_KEYWORDS.csv';
delimiter = ',';
%% 
% 2. ������ ���� �ؽ�Ʈ�� �д´�.

formatSpec = '%*q%*q%q%q%*q%*q%q%*q%*q%*q%*q%q%*q%*q%*q%*q%q%*q%*q%*q%*q%*q%*q%q%q%[^\n\r]';
%% 
% 3. �ؽ�Ʈ ������ ����.

fileID = fopen(filename,'r');
%% 
% 4. ���Ŀ� ���� ������ ���� �д´�.

dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string',  'ReturnOnError', false);
%% 
% 5. �ؽ�Ʈ ������ �ݴ´�.

fclose(fileID);
%% 
%% ������ �ؽ�Ʈ�� �ִ� ���� ������ ���ڷ� ��ȯ�ϱ�.
% 
% 
% 1 ������ �ؽ�Ʈ�� �ִ� ���� ������ ���ڷ� ��ȯ�ϰ�, �������� �ƴ� �ؽ�Ʈ�� NaN���� �ٲ۴�.

raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));
%% 
% 2. �Է� ���� �迭�� �ؽ�Ʈ�� ���ڷ� ��ȯ�ϰ�, �������� �ƴ� �ؽ�Ʈ�� NaN���� �ٲ۴�.

for col=[1,4,5,6,7]
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
%% 
% 3. �������� �ƴ� ���λ� �� ���̻縦 �˻��ϰ� �����ϴ� ���� ǥ������ �����.

        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
%% 
% 4. õ ������ �ƴ� ��ġ���� ��ǥ�� �˻��ϰ�, ������ �ؽ�Ʈ�� ���ڷ� ��ȯ�Ѵ�.

             invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^[-/+]*\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end
%% 
% 5. �����͸� ������ ���� String�� ���� �����Ѵ�.

rawNumericColumns = raw(:, [1,4,5,6,7]);
rawStringColumns = string(raw(:, [2,3]));
%% 
% 6. �������� �ƴ� ���� NaN���� �ٲ۴�.

R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % �������� �ƴ� �� ã��
rawNumericColumns(R) = {NaN}; % �������� �ƴ� �� �ٲٱ�
%% 
% 7. <undefined>�� �����ϴ� �ؽ�Ʈ�� <undefined> categorical������ ����� ��ȯ�Ǿ����� Ȯ���Ѵ�.

idx = (rawStringColumns(:, 1) == "<undefined>");
rawStringColumns(idx, 1) = "";
%% 
% 8. ������ �迭�� �� ���� �̸����� �Ҵ��Ѵ�.
% 
%     budget : ��ȭ �� ����
% 
%     genres : ��ȭ �帣
% 
%     keywords : ��ȭ �� Ű����
% 
%     popularity : ��ȭ �� ���൵
% 
%     revenue = ��ȭ ����
% 
%     vote_average : ��ȭ �� ����
% 
%     vote_count : ��ȭ �� ������

budget = cell2mat(rawNumericColumns(:, 1));
genres = rawStringColumns(:, 1);
keywords = rawStringColumns(:, 2);
popularity = cell2mat(rawNumericColumns(:, 2));
revenue = cell2mat(rawNumericColumns(:, 3));
vote_average = cell2mat(rawNumericColumns(:, 4));
vote_count = cell2mat(rawNumericColumns(:, 5));
%% 
% 9. �ӽ� ������ �����.

clearvars filename delimiter formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp rawNumericColumns rawStringColumns R idx;
%% 
%% �� ���÷� �帣�� Action���� �����Ѵ�.
%%
WantGenre = "Action";
G=["Action";"Adventure";"Comedy";"Crime";"Drama";"Fantasy";"Family";"Horror";"Romance";"Thriller";"Science"];
Gindex=0;

for i=1:length(G)
    if(G(i,1)==WantGenre)
        Gindex=i;
    end
end
%% 
% 
%% 
%% �� �帣 �� ���� �м�
% 
% 
% 1. ��ūȭ�� �������� �󵵼��� ���� ��ȭ �帣�� �����Ѵ�.

bag1=bagOfWords(tokenizedDocument(replace(genres1,","," ")));
bag1.wordcloud;
%% 
% * <internal:90E966D1 ������ ���� �� �帣�� �������>
% 
% 
% 
% �� Crime

CRcount=zeros(12,1);
CRtmp=zeros(size(genres1,1),1);
CRdate=datetime.empty;
CRrevenue=double.empty;
CRMonthR=zeros(12,1);
CRavgR=zeros(12,1);
for i=1:size(genres1,1)
    if(strfind(genres1(i,1),'Crime'))
        CRtmp(i,1)=1;
        CRdate=[CRdate;release_date1(i,1)];
        CRrevenue=[CRrevenue;revenue1(i,1)];
        if(~isnan(revenue1(i,1)))
            CRcount(CRdate(end,1).Month,1)=CRcount(CRdate(end,1).Month,1)+1;
        end
    end
    
end

for i=1:size(CRdate,1)
    if(~isnan(CRrevenue(i,1)))
        CRMonthR(CRdate(i,1).Month,1)=CRMonthR(CRdate(i,1).Month,1)+CRrevenue(i,1);
    end
end

for i=1:12
    CRavgR(i,1)=CRMonthR(i,1)/CRcount(i,1);
end
%% 
% 
% 
% 
% 
% �� Adventure

ADcount=zeros(12,1);
ADtmp=zeros(size(genres1,1),1);
ADdate=datetime.empty;
ADrevenue=double.empty;
ADMonthR=zeros(12,1);
ADavgR=zeros(12,1);
for i=1:size(genres1,1)
    if(strfind(genres1(i,1),'Adventure'))
        ADtmp(i,1)=1;
        ADdate=[ADdate;release_date1(i,1)];
        ADrevenue=[ADrevenue;revenue1(i,1)];
        
        if(~isnan(revenue1(i,1)))
            ADcount(ADdate(end,1).Month,1)=ADcount(ADdate(end,1).Month,1)+1;
        end
    end
end

for i=1:size(ADdate,1)
    if(~isnan(ADrevenue(i,1)))
        ADMonthR(ADdate(i,1).Month,1)=ADMonthR(ADdate(i,1).Month,1)+ADrevenue(i,1);
    end
end

for i=1:12
    ADavgR(i,1)=ADMonthR(i,1)/ADcount(i,1);
end
%% 
% 
% 
% 
% 
% �� Fantasy

Fcount=zeros(12,1);
Ftmp=zeros(size(genres1,1),1);
Fdate=datetime.empty;
Frevenue=double.empty;
FMonthR=zeros(12,1);
FavgR=zeros(12,1);
for i=1:size(genres1,1)
    if(strfind(genres1(i,1),'Fantasy'))
        Ftmp(i,1)=1;
        Fdate=[Fdate;release_date1(i,1)];
        Frevenue=[Frevenue;revenue1(i,1)];
        
        if(~isnan(revenue1(i,1)))
            Fcount(Fdate(end,1).Month,1)=Fcount(Fdate(end,1).Month,1)+1;
        end
    end
end

for i=1:size(Fdate,1)
    if(~isnan(Frevenue(i,1)))
        FMonthR(Fdate(i,1).Month,1)=FMonthR(Fdate(i,1).Month,1)+Frevenue(i,1);
    end
end
for i=1:12
    FavgR(i,1)=FMonthR(i,1)/Fcount(i,1);
end
%% 
% 
% 
% 
% 
% �� Horror

Hcount=zeros(12,1);
Htmp=zeros(size(genres1,1),1);
Hdate=datetime.empty;
Hrevenue=double.empty;
HMonthR=zeros(12,1);
HavgR=zeros(12,1);
for i=1:size(genres1,1)
    if(strfind(genres1(i,1),'Horror'))
        Htmp(i,1)=1;
        Hdate=[Hdate;release_date1(i,1)];
        Hrevenue=[Hrevenue;revenue1(i,1)];
        
        if(~isnan(revenue1(i,1)))
            Hcount(Hdate(end,1).Month,1)=Hcount(Hdate(end,1).Month,1)+1;
        end
        
        
    end
end

for i=1:size(Hdate,1)
    if (~isnan(Hrevenue(i,1)))
        HMonthR(Hdate(i,1).Month,1)=HMonthR(Hdate(i,1).Month,1)+Hrevenue(i,1);
    end
end
for i=1:12
    HavgR(i,1)=HMonthR(i,1)/Hcount(i,1);
end
%% 
% 
% 
% 
% 
% �� Science

Scicount=zeros(12,1);
Scitmp=zeros(size(genres1,1),1);
Scidate=datetime.empty;
Scirevenue=double.empty;
SciMonthR=zeros(12,1);
SciavgR=zeros(12,1);
for i=1:size(genres1,1)
    if(strfind(genres1(i,1),'Science'))
        Scitmp(i,1)=1;
        Scidate=[Scidate;release_date1(i,1)];
        Scirevenue=[Scirevenue;revenue1(i,1)];
        
        if(~isnan(revenue1(i,1)))
            Scicount(Scidate(end,1).Month,1)=Scicount(Scidate(end,1).Month,1)+1;
        end
    end
end

for i=1:size(Scidate,1)
    if(~isnan(Scirevenue(i,1)))
        SciMonthR(Scidate(i,1).Month,1)=SciMonthR(Scidate(i,1).Month,1)+Scirevenue(i,1);
    end
end
for i=1:12
    SciavgR(i,1)=SciMonthR(i,1)/Scicount(i,1);
end
%% 
% 
% 
% 
% 
% �� Family

FMcount=zeros(12,1);
FMtmp=zeros(size(genres1,1),1);
FMdate=datetime.empty;
FMrevenue=double.empty;
FMMonthR=zeros(12,1);
FMavgR=zeros(12,1);
for i=1:size(genres1,1)
    if(strfind(genres1(i,1),'Family'))
        FMtmp(i,1)=1;
        FMdate=[FMdate;release_date1(i,1)];
        FMrevenue=[FMrevenue;revenue1(i,1)];
        
        
        if(~isnan(revenue1(i,1)))
            FMcount(FMdate(end,1).Month,1)=FMcount(FMdate(end,1).Month,1)+1;
        end
        
        
    end
end

for i=1:size(FMdate,1)
    if(~isnan(FMrevenue(i,1)))
        FMMonthR(FMdate(i,1).Month,1)=FMMonthR(FMdate(i,1).Month,1)+FMrevenue(i,1);
    end
end
for i=1:12
    FMavgR(i,1)=FMMonthR(i,1)/FMcount(i,1);
end
%% 
% 
% 
% 
% 
% �� Drama

Dcount=zeros(12,1);
Dtmp=zeros(size(genres1,1),1);
Ddate=datetime.empty;
Drevenue=double.empty;
DMonthR=zeros(12,1);
DavgR=zeros(12,1);
for i=1:size(genres1,1)
    if(strfind(genres1(i,1),'Drama'))
        Dtmp(i,1)=1;
        Ddate=[Ddate;release_date1(i,1)];
        Drevenue=[Drevenue;revenue1(i,1)];
        %       DMonthR(Ddate(i,1).Month,1)=DMonthR(Ddate(i,1).Month,1)+Drevenue(i,1);
        
        if(~isnan(revenue1(i,1)))
            Dcount(Ddate(end,1).Month,1)=Dcount(Ddate(end,1).Month,1)+1;
        end
        
    end
end

for i=1:size(Ddate,1)
    if(~isnan(Drevenue(i,1)))
        DMonthR(Ddate(i,1).Month,1)=DMonthR(Ddate(i,1).Month,1)+Drevenue(i,1);
    end
end

for i=1:12
    DavgR(i,1)=DMonthR(i,1)/Dcount(i,1);
end
%% 
% 
% 
% 
% 
% �� Comedy

Ccount=zeros(12,1);
Ctmp=zeros(size(genres1,1),1);
Cdate=datetime.empty;
Crevenue=double.empty;
CMonthR=zeros(12,1);
CavgR=zeros(12,1);
for i=1:size(genres1,1)
    if(strfind(genres1(i,1),'Comedy'))
        Ctmp(i,1)=1;
        Cdate=[Cdate;release_date1(i,1)];
        Crevenue=[Crevenue;revenue1(i,1)];
        
        if(~isnan(revenue1(i,1)))
            Ccount(Cdate(end,1).Month,1)=Ccount(Cdate(end,1).Month,1)+1;
        end
        
        
    end
end

for i=1:size(Cdate,1)
    if(~isnan(Crevenue(i,1)))
        CMonthR(Cdate(i,1).Month,1)=CMonthR(Cdate(i,1).Month,1)+Crevenue(i,1);
    end
end

for i=1:12
    CavgR(i,1)=CMonthR(i,1)/Ccount(i,1);
end
%% 
% 
% 
% 
% 
% �� Thriller

Tcount=zeros(12,1);
Ttmp=zeros(size(genres1,1),1);
Tdate=datetime.empty;
Trevenue=double.empty;
TMonthR=zeros(12,1);
TavgR=zeros(12,1);
for i=1:size(genres1,1)
    if(strfind(genres1(i,1),'Thriller'))
        Ttmp(i,1)=1;
        Tdate=[Tdate;release_date1(i,1)];
        Trevenue=[Trevenue;revenue1(i,1)];
        
        if(~(isnan(revenue1(i,1))))
            Tcount(Tdate(end,1).Month,1)=Tcount(Tdate(end,1).Month,1)+1;
        end
        
        
    end
end

for i=1:size(Tdate,1)
    if(~isnan(Trevenue(i,1)))
        TMonthR(Tdate(i,1).Month,1)=TMonthR(Tdate(i,1).Month,1)+Trevenue(i,1);
    end
end

for i=1:12
    TavgR(i,1)=TMonthR(i,1)/Tcount(i,1);
end
%% 
% 
% 
% 
% 
% �� Action

Acount=zeros(12,1);
Atmp=zeros(size(genres1,1),1);
Adate=datetime.empty;
Arevenue=double.empty;
AMonthR=zeros(12,1);
AavgR=zeros(12,1);
for i=1:size(genres1,1)
    if(strfind(genres1(i,1),'Action'))
        Atmp(i,1)=1;
        Adate=[Adate;release_date1(i,1)];
        Arevenue=[Arevenue;revenue1(i,1)];
        
        if(~isnan(revenue1(i,1)))
            Acount(Adate(end,1).Month,1)=Acount(Adate(end,1).Month,1)+1;
        end
        
        
    end
end

for i=1:size(Adate,1)
    if(~isnan(Arevenue(i,1)))
        
        AMonthR(Adate(i,1).Month,1)=AMonthR(Adate(i,1).Month,1)+Arevenue(i,1);
    end
end

for i=1:12
    AavgR(i,1)=AMonthR(i,1)/Acount(i,1);
end
%% 
% 
% 
% 
% 
% �� Romance

Rcount=zeros(12,1);
Rtmp=zeros(size(genres1,1),1);
Rdate=datetime.empty;
Rrevenue=double.empty;
RMonthR=zeros(12,1);
RavgR=zeros(12,1);
for i=1:size(genres1,1)
    if(strfind(genres1(i,1),'Romance'))
        Rtmp(i,1)=1;
        Rdate=[Rdate;release_date1(i,1)];
        Rrevenue=[Rrevenue;revenue1(i,1)];
        
        if(isnan(revenue1(i,1)))
            Rcount(Rdate(end,1).Month,1)=Rcount(Rdate(end,1).Month,1)+1;
        end
        
        
    end
end

for i=1:size(Rdate,1)
    if(~isnan(Rrevenue(i,1)))
        RMonthR(Rdate(i,1).Month,1)=RMonthR(Rdate(i,1).Month,1)+Rrevenue(i,1);
    end
end

for i=1:12
    RavgR(i,1)=RMonthR(i,1)/Rcount(i,1);
end
%% 
% 
% 
% 2. �� �帣�� ���� ��� ������ ����ȭ�Ѵ�.

rNorA=normalize(AMonthR);
rNorAD=normalize(ADMonthR);
rNorC=normalize(CMonthR);
rNorCR=normalize(CRMonthR);
rNorD=normalize(DMonthR);
rNorF=normalize(FMonthR);
rNorFM=normalize(FMMonthR);
rNorH=normalize(HMonthR);
rNorR=normalize(RMonthR);
rNorT=normalize(TMonthR);
rNorSci=normalize(SciMonthR);

NoravgA=normalize(AavgR);
NoravgAD=normalize(ADavgR);
NoravgC=normalize(CavgR);
NoravgCR=normalize(CRavgR);
NoravgD=normalize(DavgR);
NoravgF=normalize(FavgR);
NoravgFM=normalize(FMavgR);
NoravgH=normalize(HavgR);
NoravgR=normalize(RavgR);
NoravgT=normalize(TavgR);
NoravgSci=normalize(SciavgR);
%% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 

AVGs=[AavgR,ADavgR,CavgR,CRavgR,DavgR,FavgR,FMavgR,HavgR,RavgR,TavgR,SciavgR];
NAVGs=[NoravgA,NoravgAD,NoravgC,NoravgCR,NoravgD,NoravgF,NoravgFM,NoravgH,NoravgR,NoravgT,NoravgSci];

clear title;
%% 
% * <internal:2979E98F ���� ���� ��� 3D �𵨸�> 
% 
% 3. �� �帣�� ���� ���� ��� ����

figure
plot(AavgR,'DisplayName','AavgR');hold on;plot(ADavgR,'DisplayName','ADavgR');plot(CavgR,'DisplayName','CavgR');plot(CRavgR,'DisplayName','CRavgR');plot(DavgR,'DisplayName','DavgR');plot(FavgR,'DisplayName','FavgR');plot(HavgR,'DisplayName','HavgR');plot(RavgR,'DisplayName','RavgR');plot(SciavgR,'DisplayName','SciavgR');plot(TavgR,'DisplayName','TavgR');plot(FMavgR,'DisplayName','FMavgR');
title('���� ���� ���');
xlabel('��') 
ylabel('���� ��� (���� �ջ�/��ȭ ��)')
legend('Action','Adventure','Comedy','Crime','Drama','Fantasy','Family','Horror','Romance','Thriller','Science')
hold off;

%%

figure
surf(AVGs);
hold on;
title('�� �帣�� ���� ���� ���');
xlabel('�帣')
ylabel('��') 
zlabel('���� ���(���� �ջ�/��ȭ ��)')
hold off;
%% 
% 
% 
% 4. �� �帣�� ���� ����ȭ�� ���� ��� ����

figure
bar3(NAVGs,0.8);hold on;
title('����ȭ - ���� ���� ���');
ylabel('��')
xlabel('�帣')
zlabel('���� ��� (���� �ջ�/��ȭ ��) ����ȭ ')
legend('Action','Adventure','Comedy','Crime','Drama','Fantasy','Family','Horror','Romance','Thriller','Science')
hold off;
%% 
% 

figure
pcolor(NAVGs);
ylabel('��')
xlabel('�帣')
%% 
% 
% 
% * <internal:138F81CA �� �帣�� ���⼺ �ľ�>
% 
% 5. Horror, Romance, WantGenre�� ���� ��� ����

subplot(3,1,1)
plot(AVGs(:,8),'b','linewidth',3);hold on;
title('ȣ�� ��ȭ�� ���� ��� ����');
xlabel('��')
ylabel('���� ��� (���� �ջ�/��ȭ ��)')
hold off;
%% 
% 

subplot(3,1,2)
plot(AVGs(:,9),'m','linewidth',3);hold on;
title('�θǽ� ��ȭ�� ���� ��� ����');
xlabel('��')
ylabel('���� ��� (���� �ջ�/��ȭ ��)')
hold off;
%% 
% 

subplot(3,1,3)
plot(AVGs(:,Gindex),'g','linewidth',3);hold on;
title(WantGenre+' ��ȭ�� ���� ��� ����');
xlabel('��')
ylabel('���� ��� (���� �ջ�/��ȭ ��)')
hold off;
%% �� Ű���� �� ������
% 

WantGenre = "Action";
%% 
% * <internal:4EF9BFA1 Word Cloud�� �̿��� WantGenre �� �ٰŸ� ���� �ð�ȭ>
%% �� Ư�� �帣�� Ű���带 �����Ѵ�.
% 
% 
% 1. �ش� �帣�� ���ϴ� Ű���带 �����Ѵ�.

genres = erasePunctuation(genres);
genres = erase(genres, 'id');
genres = erase(genres, 'name');
genres = regexprep(genres, '\d+(?:_(?=\d))?', '');
SpecificGenre = zeros(size(genres));
for a = 1:size(genres)
    if(contains(genres(a),WantGenre))
        SpecificGenre(a) = 1;
    end
end
Defgenres = genres;
genres = tokenizedDocument(genres);
%% 
% 
% 
% 2. Ư�� �帣�� Keyword data�� �����Ѵ�.

keywords = erasePunctuation(keywords);
keywords = erase(keywords, 'id');
keywords = erase(keywords, 'name');
keywords = erase(keywords, 'woman');
keywords = erase(keywords, 'independent');
keywords = erase(keywords, 'film');
keywords = erase(keywords, 'director');
keywords = erase(keywords, 'based');
keywords = regexprep(keywords, '\d+(?:_(?=\d))?', '');
keywords = tokenizedDocument(keywords);

SpecificGenre = logical(SpecificGenre);
SpecificKeywords = keywords(SpecificGenre);
%% 
% 
% 
% 3. Ư�� �帣�� all data�� �����Ѵ�.

DefIncome = revenue - budget; % �� ����
DefSpecificIncome = zeros(size(DefIncome)); % ���� = 1
DefKeyword = keywords;

for a = 1:size(DefIncome)
    if(SpecificGenre(a) == 1)
        DefSpecificIncome(a) = 1; % Ư�� �帣 ����
    end
end

for a = 1:size(DefIncome)
    if(DefIncome(a) > 0)
        DefIncome(a) = 0;
    end
    if(DefIncome(a) > 0 && DefSpecificIncome(a) == 1)
        DefSpecificIncome(a) = 0;
    end
end

DefIncome(isnan(DefIncome)) = 0;
DefSpecificIncome = logical(DefSpecificIncome); 
DefKeyword = DefKeyword(DefSpecificIncome); % ������ Ű���� ����

vote_average = vote_average(SpecificGenre);
vote_average(isnan(vote_average)) = 0;

popularity = popularity(SpecificGenre);
popularity(isnan(popularity)) = 0;

revenue = revenue(SpecificGenre);
revenue(isnan(revenue)) = 0;

budget = budget(SpecificGenre);
budget(isnan(budget)) = 0;

vote_count = vote_count(SpecificGenre);
vote_count(isnan(vote_count)) = 0;

SpecificKeywords = removeStopWords(SpecificKeywords);
SpecificKeywords = removeShortWords(SpecificKeywords, 2);
SpecificKeywords = removeLongWords(SpecificKeywords, 15);

DefKeyword = removeStopWords(DefKeyword);
DefKeyword = removeShortWords(DefKeyword, 2);
DefKeyword = removeLongWords(DefKeyword, 15);
%% 
% 
% 
% �� Specific Genre�� LDA Modeling ����
% 
% 1. ��ü Ű���带 ����ȭ�Ѵ�.

bag = bagOfNgrams(SpecificKeywords);
figure
wordcloud(bag);
title(WantGenre+" genre")
numTopics =6;
mdl = fitlda(bag,numTopics,'Verbose',0);
%% 
% * <internal:013C61DA 6���� Topic����  ����ȭ> 
%
% 
% 
% 2. LDA Topic ���� ����ȭ�Ѵ�.

figure
for topicIdx = 1:numTopics
    subplot(2,3,topicIdx)
    wordcloud(mdl,topicIdx);
    title("Topic: " + topicIdx)
end
%% 
% * <internal:6A627ABA �� ������ ���Ͱ� ������ ���� ��� �׷���>
% 
% �� Topic ���� �� ����, ����, ���൵, �������� ��� ����
% 
% 1. ����, ��������, ���൵, ������ ����Ѵ�.

SpecificTopicAverage=zeros(1,numTopics);
SpecificTopicCounts=zeros(1,numTopics);
SpecificTopicPopularity=zeros(1,numTopics);
SpecificTopicRevenue=zeros(1,numTopics);
SpecificTopicMovie=zeros(1,numTopics);

for a=1:bag.NumDocuments
    if(vote_average(a,1)>0 && vote_average(a,1)<=10)
        Topic=find(mdl.DocumentTopicProbabilities(a,:)==max(mdl.DocumentTopicProbabilities(a,:)));
        SpecificTopicAverage(1,Topic)=SpecificTopicAverage(1,Topic)+vote_average(a,1);
        SpecificTopicCounts(1,Topic)=SpecificTopicCounts(1,Topic)+vote_count(a,1);
        SpecificTopicPopularity(1,Topic)=SpecificTopicPopularity(1,Topic)+popularity(a,1);
        SpecificTopicRevenue(1,Topic)=SpecificTopicRevenue(1,Topic)+revenue(a,1);
        SpecificTopicMovie(1,Topic)=SpecificTopicMovie(1,Topic)+1;
    end
end
%% 
% 
% 
% 2. �ش� ������ ���ϴ� ��ȭ ���� ����Ѵ�.

for a=1:numTopics
    if(SpecificTopicMovie(1,a)~=0)
        SpecificTopicAverage(1,a)=SpecificTopicAverage(1,a)/SpecificTopicMovie(1,a);
        SpecificTopicCounts(1,a)=SpecificTopicCounts(1,a)/SpecificTopicMovie(1,a);
        SpecificTopicPopularity(1,a)=SpecificTopicPopularity(1,a)/SpecificTopicMovie(1,a);
        SpecificTopicRevenue(1,a)=SpecificTopicRevenue(1,a)/SpecificTopicMovie(1,a);
    end
end
%% 
% 
% 
% �� �� �׷����� ��ȭ
% 
% 1 Topic �� ���൵ ���

figure
plot(SpecificTopicPopularity(1,:), 'b','linewidth', 3)
xticks([1 2 3 4 5 6])
title('Topic �� ���൵ ���','fontsize',20)
ylabel('���൵','fontsize',15)
%% 
% 
% 2. Topic �� �������� ���

figure
plot(SpecificTopicCounts(1,:), 'r','linewidth', 3)
xticks([1 2 3 4 5 6])
title('Topic �� ������ �� ���','fontsize',20)
ylabel('������ ��','fontsize',15)
%% 
% 
% 
% 3. Topic �� ��� ����

figure
plot(SpecificTopicRevenue(1,:), 'm','linewidth', 3)
xticks([1 2 3 4 5 6])
title('Topic �� ���� ���','fontsize',20)
ylabel('����','fontsize',15)
%% 
% * <internal:B8159769 Remove Outlier>
% 
% �� �ش� �帣�� ��ȭ �� ����

m = size(SpecificKeywords);
sz = m(1);
%% 
% 
% 
% �� 6���� Topic �� ���� 3�� ����

TopRank = zeros(6,1);
for a = 1:numTopics
    [m,n] = max(SpecificTopicCounts);
    TopRank(a,1) = n;
    SpecificTopicCounts(n) = 0;
end
%% 
% 
% 
% �� Topic ���� �� ����, ��������, ���� �ݾ� ���

test = [zeros(sz,1) zeros(sz,1) zeros(sz,1) zeros(sz,1) zeros(sz,1) zeros(sz,1)];
for a = 1:sz
    Topic=find(mdl.DocumentTopicProbabilities(a,:)==max(mdl.DocumentTopicProbabilities(a,:)));
    for b = 1:numTopics
        if(Topic == TopRank(b,1))
            test(a,b) = 1;
        end
    end
end

test = logical(test);
TopRevenue = [zeros(sz,1) zeros(sz,1) zeros(sz,1) zeros(sz,1) zeros(sz,1) zeros(sz,1)];
TopBudget = [zeros(sz,1) zeros(sz,1) zeros(sz,1) zeros(sz,1) zeros(sz,1) zeros(sz,1)];
TopVoteCount = [zeros(sz,1) zeros(sz,1) zeros(sz,1) zeros(sz,1) zeros(sz,1) zeros(sz,1)];
TopIncome = [zeros(sz,1) zeros(sz,1) zeros(sz,1) zeros(sz,1) zeros(sz,1) zeros(sz,1)];

for a = 1:numTopics
    for b = 1:sz
        TopRevenue(b,a) = revenue(b)*test(b,a);
        TopBudget(b,a) = budget(b)*test(b,a);
        TopVoteCount(b,a) = vote_count(b)*test(b,a);
        TopIncome(b,a) = TopRevenue(b,a) - TopBudget(b,a);
    end
end

TopRevenue(isnan(TopRevenue)) = 0;
TopBudget(isnan(TopBudget)) = 0;
TopVoteCount(isnan(TopVoteCount)) = 0;
TopIncome(isnan(TopIncome)) = 0;
%% 
% 
% 
% �� Remove Outlier
% 
% 1 ������ ���� ���� �̻� �� ����

for a = 1:numTopics
    %figure % ������ ���� ���� �̻� ����
    h = histogram(TopVoteCount(:,a),10); % Histogram
    N = max(h.Values); % Maximum bin count
    mu3 = mean(TopVoteCount(:,a)); % Data mean
    sigma3 = std(TopVoteCount(:,a)); % Data standard deviation
    hold on
    plot([mu3 mu3],[0 N],'r','LineWidth',2); % Mean
    X = repmat(mu3+(1:2)*sigma3,2,1);
    Y = repmat([0;N],1,2);
    plot(X,Y,'Color',[255 153 51]./255,'LineWidth',2); % Standard deviations
    legend('Data','Mean','Stds');
    hold off
    outliers = (TopVoteCount(:,a) - mu3) > 4*sigma3;
    for b = 1:sz
        if(outliers(b) == 0)
            TopVoteCount(b,a) = NaN; % Add NaN values
        end
    end
end

TopVoteCount(isnan(TopVoteCount)) = 0;
%% 
% * <internal:65A7C485 Curve Fitting>
% 
% 2. Income ���� ����

for a = 1:numTopics
    for b = 1:sz
        if(TopIncome(b,a) < 0)
            TopIncome(b,a) = 0;
        end
    end
end
%% 
% 
% 
% 3. ������ ���� ���� �����Ͱ� ��� �����ϴ� ���� ����

for a = 1:numTopics
    for b = 1:sz
        if(TopVoteCount(b,a) == 0)
            TopIncome(b,a) = 0;
        end
    end
end

for a = 1:numTopics
    for b = 1:sz
        if(TopIncome(b,a) == 0)
            TopVoteCount(b,a) = 0;
        end
    end
end
%% 
% 
% �� Curve Fitting
% 
%     Topic �� ��ǥ���� ���� �������� Curve Fitting Plot

INcome = zeros(sz,1);
VC = zeros(sz,1);
color = ['r';'g';'b';'m';'k';'y'];
cnt = 0;
figure
for a = 1:numTopics
    try
        INcome = TopIncome(:,a);
        VC = TopVoteCount(:,a);
        INcome(INcome==0) = [];
        VC(VC==0) = [];
        f = fit(VC, INcome, 'poly2');
        hL1=plot(f,VC,INcome);
        set(hL1(2),'color',color(a))
        hold on
        cnt = cnt+1;
        if(cnt == 3)
            break
        end
    catch
        continue
    end
end
title('Topic �� ��ǥ���� ���� ������','fontsize',20)
xlabel('��ǥ��','fontsize',15)
ylabel('����','fontsize',15)
legend('','Rank : 1','','Rank : 2' ,'','Rank : 3');
hold off
%% 
% 
% 
% �� ���� Topic 3�� ���� ���� 25�� Ű���� ����

tbl1 = topkwords(mdl, 25, TopRank(1));
tbl2 = topkwords(mdl, 25, TopRank(2));
tbl3 = topkwords(mdl, 22, TopRank(3));
figure
subplot(2,3,1)
wordcloud(tbl1.Word, tbl1.Score);
title("Rank 1: Topic " + TopRank(1));
subplot(2,3,2)
wordcloud(tbl2.Word, tbl2.Score);
title("Rank 2: Topic " + TopRank(2));
subplot(2,3,3)
wordcloud(tbl3.Word, tbl3.Score);
title("Rank 3: Topic " + TopRank(3));
%% 
% * <internal:H_77ACC942 ���� ����� �ٰŸ� ���簡 ���ϴ� LDA Modeling>
% 
% 
%% 
%% �� ���� ����� �ٰŸ� ���簡 ���ϴ� Topic �𵨸�
% 
% 
% 1. ���� ����� �ٰŸ� ���簡 ���ϴ� Topic �𵨸�

newDocuments = tokenizedDocument(" lost loved one experiment vigilante serum based on comic super power spider bite masked genetic engineering social outcast");
topicIdx = predict(mdl,newDocuments);


figure
wordcloud(mdl,topicIdx(1));
title("���� ����� �ٰŸ� ���簡 ���ϴ� TopicNo : " + topicIdx(1))
%% 
% * <internal:32E814A1 ���� ����� ������ ����> 

% 
% 2. ���� ����� �ٰŸ� ������ ��ǥ���� ���� ������

SpecificINcome = zeros(sz,1);
SpecificVC = zeros(sz,1);
figure
SpecificINcome = TopIncome(:,topicIdx);
SpecificVC = TopVoteCount(:,topicIdx);
SpecificINcome(SpecificINcome==0) = [];
SpecificVC(SpecificVC==0) = [];
Specificf = fit(SpecificVC, SpecificINcome, 'poly2');
SpecifichL1=plot(Specificf,SpecificVC,SpecificINcome);
hold on
%% 
% 

title('���� ����� �ٰŸ� ������ ��ǥ���� ���� ������','fontsize',15)
xlabel('��ǥ��','fontsize',15)
ylabel('����','fontsize',15)
line([9088 9088],[0 660000000])
hold off
%% **
%% *���� ���*
% * T*itle : �����¡ �����̴���*
% * *������ : $ 6�� 6000�� �޷�  ( �ѱ���ȭ : �� 7400��)*
% * *������ �� : 9088*
% * *Genre : �׼�, ����, ��Ÿ��*
% * *Keywords :  lost loved one experiment vigilante serum based on comic super 
% power spider bite masked genetic engineering social outcast*

% 
%% �� ������ ��ȭ �帣 LDA �𵨸�
% 
% 
% 1. Ư�� �帣�� ���� Ű���� LDA �𵨸� ����

rng=('default');

bag11 = bagOfWords(DefKeyword);

mdl11 = fitlda(bag11,1,'Verbose',0);
tbl11 = topkwords(mdl11, 25, 1); %%���� 25��

figure
wordcloud(tbl11.Word, tbl11.Score);
title(WantGenre + " Genre")
%% 
% 
% 
% 2. ���� ���
% 
% * Title : R.I.P.D : ��. ����. ��. ��  
% * ������ : $ -68,351,500 (�ѱ� ��ȭ : ��  -700��)
% * Genre : ��Ÿ��, �׼�, �ڹ̵�, ����
% * Keywords : detective, gold, wife, police operation, investigation, partner, 
% love, revenge, undead, death, husband, ghost, police department
% 
