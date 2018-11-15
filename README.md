# PredictingMovieRevenues
## 주제 선정
### 약 45000개 이상의 영화를 분석한 DataSet을 이용하여 영화의 줄거리에 따른 수익을 예측해보고자 하였다.
**특정 장르에서 여떤 줄거리를 가진 영화가 얼마의 수익을 가질것 인지 예측**
* 추출한 데이터
1 genre & keyword
2 Vote Count
3 Revenue

## 사용 언어
**Matlab language**

## 분석 방법
1. 군집화 - LDA 모델링
  (문서에 포함된 단어를 빈도수에 따라 서로 연관짓고 분류한다
  
2 Keyword 분석 - Word Clouds
  (Word Clouds를 사용한 텍스트 데이터 시각화)
3 Data 추출 & Remove Outliers
  (신뢰성 구축을 위해 Outlier 제거 & 측정할 수 없는 값은 배제)
4 각 군집(Topic)에 따른 투표율 & 평점 그래프
5 Curve Fitting / 관람객 수에 따른 순수익 그래프

## 기대효과
**제작자 또는 배우의 입장에서 특정 장르의 영화를 제작 & 출연하고자 할 때. 성공하기 위해 어떤 키워드를 가진 영화를 제작 & 출연해야하는가**
