// ==========================================
// TNPSC AI Assistant - Question & Affairs Data
// ==========================================

const QUESTIONS = [
  // APTITUDE - Percentages
  {category:'aptitude',topic:'Percentages',difficulty:1,question:'What is 25% of 200?',options:['40','50','60','75'],correct:1,explanation:'25% of 200 = (25/100) × 200 = 50',shortcut:'25% = 1/4, so 200/4 = 50'},
  {category:'aptitude',topic:'Percentages',difficulty:1,question:'What is 15% of 300?',options:['35','40','45','50'],correct:2,explanation:'15% of 300 = (15/100) × 300 = 45',shortcut:'10% of 300=30, 5%=15, total=45'},
  {category:'aptitude',topic:'Percentages',difficulty:2,question:'If a number is increased by 20%, then decreased by 20%, the net change is?',options:['0%','-4%','4%','-2%'],correct:1,explanation:'Net change = -20×20/100 = -4%',shortcut:'Successive change: a+b+ab/100'},
  {category:'aptitude',topic:'Percentages',difficulty:2,question:'A student scored 280 out of 400. What is the percentage?',options:['65%','70%','72%','75%'],correct:1,explanation:'(280/400) × 100 = 70%',shortcut:'280/4 = 70%'},
  {category:'aptitude',topic:'Percentages',difficulty:3,question:'In an election, A gets 60% votes. Total votes 5000, 20% invalid. Valid votes for A?',options:['2400','2800','3000','3200'],correct:0,explanation:'Valid=80% of 5000=4000. A=60% of 4000=2400',shortcut:'Valid=Total×0.8, A=Valid×0.6'},

  // APTITUDE - Profit and Loss
  {category:'aptitude',topic:'Profit and Loss',difficulty:1,question:'CP=₹500, SP=₹600. Profit percentage?',options:['10%','15%','20%','25%'],correct:2,explanation:'Profit=100. Profit%=(100/500)×100=20%',shortcut:'Profit%=(Profit/CP)×100'},
  {category:'aptitude',topic:'Profit and Loss',difficulty:2,question:'SP=₹450, Loss=10%. Find CP.',options:['₹495','₹500','₹510','₹550'],correct:1,explanation:'CP=SP×100/(100-L%)=450×100/90=500',shortcut:'CP=SP×100/(100-L%)'},
  {category:'aptitude',topic:'Profit and Loss',difficulty:2,question:'CP=₹800, Profit=15%. Find SP.',options:['₹880','₹900','₹920','₹960'],correct:2,explanation:'SP=CP×(100+P%)/100=800×115/100=₹920',shortcut:'SP=CP×1.15'},
  {category:'aptitude',topic:'Profit and Loss',difficulty:3,question:'Buy 10 oranges for ₹50, sell 8 for ₹50. Profit%?',options:['20%','25%','30%','15%'],correct:1,explanation:'CP/orange=₹5, SP/orange=₹6.25. Profit%=(1.25/5)×100=25%',shortcut:'Profit%=(10-8)/8×100=25%'},

  // APTITUDE - Time and Work
  {category:'aptitude',topic:'Time and Work',difficulty:1,question:'A does work in 10 days, B in 15 days. Together how many days?',options:['5','6','7','8'],correct:1,explanation:'1/10+1/15=5/30=1/6. Together=6 days',shortcut:'(A×B)/(A+B)=150/25=6'},
  {category:'aptitude',topic:'Time and Work',difficulty:2,question:'A:12 days, B:18 days. Work together 4 days, A leaves. B finishes in?',options:['6','8','10','12'],correct:1,explanation:'LCM=36. A=3/day, B=2/day. 4 days=20 units. Remaining=16. B=16/2=8',shortcut:'LCM method: Total=36, together 4 days=20, rest=16, B alone=8'},

  // APTITUDE - Time and Distance
  {category:'aptitude',topic:'Time and Distance',difficulty:1,question:'Train travels 240km in 4 hours. Speed?',options:['50 km/h','55 km/h','60 km/h','65 km/h'],correct:2,explanation:'Speed=Distance/Time=240/4=60 km/h',shortcut:'S=D/T'},

  // APTITUDE - Ratio
  {category:'aptitude',topic:'Ratio and Proportion',difficulty:1,question:'Divide ₹1200 in ratio 2:3:5. What does C get?',options:['₹400','₹500','₹600','₹720'],correct:2,explanation:'Total parts=10. C=(5/10)×1200=₹600',shortcut:'C\'s fraction=5/10=1/2'},

  // APTITUDE - Average
  {category:'aptitude',topic:'Average',difficulty:1,question:'Average of 5 numbers is 20. One excluded, average becomes 18. Excluded number?',options:['24','26','28','30'],correct:2,explanation:'Sum5=100, Sum4=72. Excluded=100-72=28',shortcut:'Excluded=Total sum-Remaining sum'},

  // APTITUDE - Probability
  {category:'aptitude',topic:'Probability',difficulty:1,question:'Bag: 3 red, 5 blue, 2 green. P(blue)?',options:['1/3','2/5','1/2','3/10'],correct:2,explanation:'Total=10. P(blue)=5/10=1/2',shortcut:'P=Favorable/Total'},

  // REASONING - Number Series
  {category:'reasoning',topic:'Number Series',difficulty:1,question:'Next: 2, 6, 12, 20, 30, ?',options:['40','42','44','46'],correct:1,explanation:'Differences: 4,6,8,10,12. Next=30+12=42',shortcut:'Pattern: n(n+1). 6×7=42'},
  {category:'reasoning',topic:'Number Series',difficulty:1,question:'Next: 1, 4, 9, 16, 25, ?',options:['30','34','36','49'],correct:2,explanation:'Perfect squares: 1²,2²,3²,4²,5²,6²=36',shortcut:'n² series'},
  {category:'reasoning',topic:'Number Series',difficulty:2,question:'Next: 3, 9, 27, 81, ?',options:['162','200','243','270'],correct:2,explanation:'Each ×3. 81×3=243',shortcut:'Geometric series: ×3'},

  // REASONING - Blood Relations
  {category:'reasoning',topic:'Blood Relations',difficulty:1,question:'Woman says "His mother is my mother\'s only daughter." Relation to man?',options:['Mother','Grandmother','Sister','Aunt'],correct:0,explanation:'Only daughter of my mother = herself. She is his mother.',shortcut:'Only daughter of my mother = myself'},
  {category:'reasoning',topic:'Blood Relations',difficulty:2,question:'A is brother of B. C is daughter of A. D is sister of C. B is related to D as?',options:['Father','Uncle','Brother','Grandfather'],correct:1,explanation:'A is B\'s brother. C & D are A\'s daughters. B is their uncle.',shortcut:'Draw family tree'},

  // REASONING - Coding-Decoding
  {category:'reasoning',topic:'Coding-Decoding',difficulty:1,question:'APPLE coded as ELPPA. MANGO coded as?',options:['OGNAM','OGANM','NAMGO','GNAMO'],correct:0,explanation:'Word is reversed. MANGO→OGNAM',shortcut:'Pattern: Reverse letters'},

  // REASONING - Direction
  {category:'reasoning',topic:'Direction Sense',difficulty:1,question:'Walk 5km North, turn right 3km, turn right 5km. Distance from start?',options:['3 km','5 km','8 km','13 km'],correct:0,explanation:'N5→E3→S5. He is 3km East of start.',shortcut:'Draw path: U-shape, 3km from start'},

  // REASONING - Analogy
  {category:'reasoning',topic:'Analogy',difficulty:1,question:'Pen : Writer :: Brush : ?',options:['Painter','Canvas','Color','Art'],correct:0,explanation:'Pen is tool of Writer. Brush is tool of Painter.',shortcut:'Tool:User relationship'},

  // VERBAL - Synonyms
  {category:'verbal',topic:'Synonyms',difficulty:1,question:'Synonym of "Abundant":',options:['Scarce','Plentiful','Rare','Limited'],correct:1,explanation:'Abundant = existing in large quantities = plentiful',shortcut:''},
  {category:'verbal',topic:'Synonyms',difficulty:1,question:'Synonym of "Eloquent":',options:['Silent','Articulate','Confused','Shy'],correct:1,explanation:'Eloquent = fluent/persuasive. Articulate is closest.',shortcut:''},
  {category:'verbal',topic:'Synonyms',difficulty:2,question:'Synonym of "Benevolent":',options:['Cruel','Kind','Angry','Greedy'],correct:1,explanation:'Benevolent = well-meaning, kindly.',shortcut:'Bene=good (Latin root)'},

  // VERBAL - Antonyms
  {category:'verbal',topic:'Antonyms',difficulty:1,question:'Antonym of "Optimistic":',options:['Hopeful','Cheerful','Pessimistic','Positive'],correct:2,explanation:'Optimistic=hopeful. Opposite=pessimistic.',shortcut:''},
  {category:'verbal',topic:'Antonyms',difficulty:1,question:'Antonym of "Ancient":',options:['Old','Historic','Modern','Traditional'],correct:2,explanation:'Ancient=very old. Opposite=Modern.',shortcut:''},

  // VERBAL - Grammar
  {category:'verbal',topic:'Grammar',difficulty:1,question:'Correct sentence:',options:["He don't know nothing","He doesn't know anything","He don't knows anything","He doesn't knows nothing"],correct:1,explanation:'3rd person singular: doesn\'t + base verb. No double negatives.',shortcut:'He/She/It + doesn\'t + V1'},
  {category:'verbal',topic:'Grammar',difficulty:2,question:'Correct: "Neither he nor his friends ___ present"',options:['was','were','are','is'],correct:1,explanation:'Neither...nor: verb agrees with nearest subject. Friends=plural→were',shortcut:'Neither...nor→verb agrees with nearest'},

  // VERBAL - Fill in Blanks
  {category:'verbal',topic:'Fill in the Blanks',difficulty:1,question:'He is ___ honest man.',options:['a','an','the','no article'],correct:1,explanation:'"Honest" starts with vowel sound (silent H). Use "an".',shortcut:'Article depends on sound, not letter'},

  // === EXPANDED QUESTION BANK ===
  // APTITUDE - More Percentages
  {category:'aptitude',topic:'Percentages',difficulty:1,question:'What is 40% of 250?',options:['80','90','100','110'],correct:2,explanation:'40/100 × 250 = 100',shortcut:'40%=2/5, 250×2/5=100'},
  {category:'aptitude',topic:'Percentages',difficulty:2,question:'A price increases from ₹80 to ₹100. Percentage increase?',options:['20%','25%','30%','15%'],correct:1,explanation:'Increase=20. (20/80)×100=25%',shortcut:'Change/Original×100'},
  {category:'aptitude',topic:'Percentages',difficulty:2,question:'Population increases 10% yearly. After 2 years from 10000?',options:['12000','12100','12200','11000'],correct:1,explanation:'10000×1.1×1.1=12100',shortcut:'P(1+r/100)^n'},
  {category:'aptitude',topic:'Percentages',difficulty:3,question:'60% of a class are boys. 40% boys passed. 80% girls passed. Total pass%?',options:['52%','56%','60%','64%'],correct:1,explanation:'Boys pass=0.6×0.4=0.24. Girls pass=0.4×0.8=0.32. Total=56%',shortcut:'Weight each group'},

  // More Profit and Loss
  {category:'aptitude',topic:'Profit and Loss',difficulty:1,question:'CP=₹200, SP=₹180. Loss%?',options:['5%','8%','10%','12%'],correct:2,explanation:'Loss=20. Loss%=(20/200)×100=10%',shortcut:'Loss/CP×100'},
  {category:'aptitude',topic:'Profit and Loss',difficulty:2,question:'MP=₹500, Discount=20%. SP?',options:['₹380','₹400','₹420','₹450'],correct:1,explanation:'SP=500×80/100=₹400',shortcut:'SP=MP×(100-D%)/100'},
  {category:'aptitude',topic:'Profit and Loss',difficulty:3,question:'Two items sold at ₹600 each. One at 20% profit, other 20% loss. Net?',options:['No loss','₹50 loss','₹25 loss','₹25 profit'],correct:1,explanation:'CP1=500,CP2=750. Total CP=1250,SP=1200. Loss=₹50',shortcut:'Same SP, same% → always loss=(P%)²/100'},

  // More Time and Work
  {category:'aptitude',topic:'Time and Work',difficulty:1,question:'A completes job in 20 days. Work done in 5 days?',options:['20%','25%','30%','15%'],correct:1,explanation:'5/20 = 1/4 = 25%',shortcut:'Work=Days done/Total days'},
  {category:'aptitude',topic:'Time and Work',difficulty:2,question:'A:15 days, B:20 days. Work 5 days together. Remaining work?',options:['5/12','7/12','1/3','1/4'],correct:1,explanation:'Together 1 day=1/15+1/20=7/60. 5 days=35/60=7/12 done. Remaining=5/12',shortcut:'Remaining=1-done'},
  {category:'aptitude',topic:'Time and Work',difficulty:3,question:'Pipe A fills in 12h, B in 15h, C empties in 20h. All open, tank fills in?',options:['8h','10h','12h','15h'],correct:1,explanation:'1/12+1/15-1/20=(5+4-3)/60=6/60=1/10. Answer=10h',shortcut:'Add fill rates, subtract empty rate'},

  // More Time and Distance
  {category:'aptitude',topic:'Time and Distance',difficulty:1,question:'Speed 60km/h. Distance in 45 minutes?',options:['40km','45km','50km','55km'],correct:1,explanation:'60×45/60=45km',shortcut:'D=S×T'},
  {category:'aptitude',topic:'Time and Distance',difficulty:2,question:'72 km/h converted to m/s?',options:['15','18','20','25'],correct:2,explanation:'72×5/18=20 m/s',shortcut:'km/h to m/s: ×5/18'},
  {category:'aptitude',topic:'Time and Distance',difficulty:2,question:'Train 150m long crosses pole in 10s. Speed?',options:['12 m/s','15 m/s','18 m/s','20 m/s'],correct:1,explanation:'Speed=150/10=15 m/s',shortcut:'Crossing pole: S=Length/Time'},
  {category:'aptitude',topic:'Time and Distance',difficulty:3,question:'Two trains 100m,150m at 60,40 km/h opposite. Cross time?',options:['6s','8s','9s','10s'],correct:2,explanation:'Relative speed=100 km/h=250/9 m/s. Distance=250m. T=250/(250/9)=9s',shortcut:'Opposite: add speeds'},

  // Ratio and Proportion
  {category:'aptitude',topic:'Ratio and Proportion',difficulty:1,question:'If A:B=3:4 and B:C=2:5. Find A:C.',options:['3:5','3:10','6:20','6:5'],correct:1,explanation:'A:B=3:4, B:C=4:10. A:C=3:10',shortcut:'Make B same in both ratios'},
  {category:'aptitude',topic:'Ratio and Proportion',difficulty:2,question:'Income ratio A:B=5:3. Expenditure 4:3. Each saves ₹1000. A income?',options:['₹4000','₹5000','₹6000','₹8000'],correct:1,explanation:'5x-4y=1000, 3x-3y=1000. Solving: x=1000, A=5000',shortcut:'Set ratio variables, subtract savings'},

  // Simplification
  {category:'aptitude',topic:'Simplification',difficulty:1,question:'25 × 4 ÷ 2 + 10 = ?',options:['50','60','70','80'],correct:1,explanation:'25×4=100, 100÷2=50, 50+10=60',shortcut:'BODMAS order'},
  {category:'aptitude',topic:'Simplification',difficulty:1,question:'√144 + √81 = ?',options:['21','23','25','27'],correct:0,explanation:'12+9=21',shortcut:'√144=12, √81=9'},
  {category:'aptitude',topic:'Simplification',difficulty:2,question:'(0.5)³ = ?',options:['0.25','0.125','0.0125','1.25'],correct:1,explanation:'0.5×0.5×0.5=0.125',shortcut:'(1/2)³=1/8=0.125'},

  // Number Systems
  {category:'aptitude',topic:'Number Systems',difficulty:1,question:'HCF of 12 and 18?',options:['3','4','6','9'],correct:2,explanation:'Factors of 12:{1,2,3,4,6,12}. 18:{1,2,3,6,9,18}. HCF=6',shortcut:'Prime factorization method'},
  {category:'aptitude',topic:'Number Systems',difficulty:1,question:'LCM of 4, 6, 8?',options:['12','16','24','48'],correct:2,explanation:'LCM=24',shortcut:'2×2×2×3=24'},
  {category:'aptitude',topic:'Number Systems',difficulty:2,question:'Sum of first 20 natural numbers?',options:['190','200','210','220'],correct:2,explanation:'n(n+1)/2=20×21/2=210',shortcut:'n(n+1)/2'},

  // Average
  {category:'aptitude',topic:'Average',difficulty:1,question:'Average of 10,20,30,40,50?',options:['25','30','35','40'],correct:1,explanation:'Sum=150. Average=150/5=30',shortcut:'Middle number in AP=Average'},
  {category:'aptitude',topic:'Average',difficulty:2,question:'Average of 10 numbers is 15. If 5 is added to each, new average?',options:['15','18','20','25'],correct:2,explanation:'Adding constant to all→average increases by same. 15+5=20',shortcut:'Adding k to each: new avg=old+k'},
  {category:'aptitude',topic:'Average',difficulty:2,question:'Avg of 8 numbers is 25. Removing 17, new avg?',options:['26','27','28','29'],correct:0,explanation:'Sum=200. New sum=183. New avg=183/7≈26.14→26',shortcut:'Remove and recalculate'},

  // Simple Interest
  {category:'aptitude',topic:'Simple Interest',difficulty:1,question:'SI on ₹5000 at 8% for 3 years?',options:['₹1000','₹1100','₹1200','₹1500'],correct:2,explanation:'SI=5000×8×3/100=₹1200',shortcut:'SI=PNR/100'},
  {category:'aptitude',topic:'Simple Interest',difficulty:2,question:'Sum doubles in 8 years at SI. Rate?',options:['10%','12.5%','15%','8%'],correct:1,explanation:'SI=P, so P=P×R×8/100. R=100/8=12.5%',shortcut:'Rate=100/Time for doubling'},

  // Compound Interest
  {category:'aptitude',topic:'Compound Interest',difficulty:1,question:'CI on ₹10000 at 10% for 2 years?',options:['₹2000','₹2100','₹2200','₹2500'],correct:1,explanation:'A=10000(1.1)²=12100. CI=2100',shortcut:'CI=P(1+r/100)^n - P'},
  {category:'aptitude',topic:'Compound Interest',difficulty:2,question:'Difference between CI and SI on ₹8000 at 5% for 2 years?',options:['₹10','₹15','₹20','₹25'],correct:2,explanation:'SI=800. CI=820. Diff=₹20',shortcut:'Diff for 2 yrs=P(r/100)²'},

  // Probability
  {category:'aptitude',topic:'Probability',difficulty:1,question:'Two dice thrown. P(sum=7)?',options:['1/6','5/36','1/4','7/36'],correct:0,explanation:'Favorable: (1,6)(2,5)(3,4)(4,3)(5,2)(6,1)=6. P=6/36=1/6',shortcut:'Sum 7 always has 6 ways'},
  {category:'aptitude',topic:'Probability',difficulty:2,question:'Coin tossed 3 times. P(at least one head)?',options:['3/4','7/8','1/2','5/8'],correct:1,explanation:'P(at least 1H)=1-P(no H)=1-1/8=7/8',shortcut:'1-P(complement)'},

  // MORE REASONING
  // Number Series
  {category:'reasoning',topic:'Number Series',difficulty:1,question:'Next: 5, 10, 20, 40, ?',options:['60','70','80','100'],correct:2,explanation:'Each ×2. 40×2=80',shortcut:'GP ratio=2'},
  {category:'reasoning',topic:'Number Series',difficulty:2,question:'Next: 2, 3, 5, 7, 11, 13, ?',options:['15','17','19','21'],correct:1,explanation:'Prime number series. Next prime=17',shortcut:'Prime numbers'},
  {category:'reasoning',topic:'Number Series',difficulty:2,question:'Next: 1, 1, 2, 3, 5, 8, ?',options:['11','12','13','15'],correct:2,explanation:'Fibonacci: each=sum of previous two. 5+8=13',shortcut:'Fibonacci pattern'},
  {category:'reasoning',topic:'Number Series',difficulty:3,question:'Next: 4, 9, 25, 49, 121, ?',options:['144','169','196','225'],correct:1,explanation:'Squares of primes: 2²,3²,5²,7²,11²,13²=169',shortcut:'Prime² series'},

  // Blood Relations
  {category:'reasoning',topic:'Blood Relations',difficulty:1,question:'Pointing to a photo, "He is my father\'s only son\'s son." Who is he?',options:['Son','Nephew','Grandson','Brother'],correct:0,explanation:'Father\'s only son=myself. His son=my son.',shortcut:'Only son of my father=myself'},
  {category:'reasoning',topic:'Blood Relations',difficulty:2,question:'A is mother of B. B is sister of C. D is father of C. E is daughter of D. B is related to E as?',options:['Mother','Sister','Aunt','Daughter'],correct:1,explanation:'B and C are siblings (same parents A and D). E is D\'s daughter, so E is also sibling. B is sister of E.',shortcut:'Same parents=siblings'},
  {category:'reasoning',topic:'Blood Relations',difficulty:3,question:'If P+Q means P is father of Q, P-Q means P is wife of Q, P×Q means P is brother of Q. What does A+B-C mean?',options:['C is father of B','A is father-in-law of C','C is uncle of A','A is brother of C'],correct:1,explanation:'A is father of B. B is wife of C. So A is father-in-law of C.',shortcut:'Decode step by step'},

  // Coding-Decoding
  {category:'reasoning',topic:'Coding-Decoding',difficulty:1,question:'If CAT=3-1-20, DOG=?',options:['4-15-7','3-14-6','5-16-8','4-16-7'],correct:0,explanation:'D=4, O=15, G=7. DOG=4-15-7',shortcut:'A=1,B=2...Z=26'},
  {category:'reasoning',topic:'Coding-Decoding',difficulty:2,question:'If LION=13-9-15-14, BEAR=?',options:['2-5-1-18','3-6-2-19','1-4-0-17','2-5-1-19'],correct:0,explanation:'B=2,E=5,A=1,R=18',shortcut:'Direct letter-to-number'},
  {category:'reasoning',topic:'Coding-Decoding',difficulty:2,question:'FACE coded as HCEG (+2 shift). BALL coded as?',options:['DCNN','DCMM','ECNN','DBMM'],correct:0,explanation:'B+2=D,A+2=C,L+2=N,L+2=N. DCNN',shortcut:'+2 shift each letter'},

  // Direction Sense
  {category:'reasoning',topic:'Direction Sense',difficulty:1,question:'Facing North, turn right, then left. Which direction now?',options:['North','South','East','West'],correct:0,explanation:'North→right=East→left=North',shortcut:'Track each turn'},
  {category:'reasoning',topic:'Direction Sense',difficulty:2,question:'A walks 3km East, turns left 4km, turns left 3km. Distance from start?',options:['3km','4km','5km','10km'],correct:1,explanation:'E3→N4→W3. Forms rectangle side. 4km North of start.',shortcut:'Draw the path on paper'},

  // Analogy
  {category:'reasoning',topic:'Analogy',difficulty:1,question:'Book : Library :: Patient : ?',options:['Doctor','Medicine','Hospital','Treatment'],correct:2,explanation:'Books kept in Library. Patients kept in Hospital.',shortcut:'Place where kept'},
  {category:'reasoning',topic:'Analogy',difficulty:1,question:'Bird : Nest :: Horse : ?',options:['Barn','Stable','Farm','Field'],correct:1,explanation:'Bird lives in Nest. Horse lives in Stable.',shortcut:'Home/dwelling relationship'},
  {category:'reasoning',topic:'Analogy',difficulty:2,question:'Marathon : Race :: Hibernation : ?',options:['Winter','Sleep','Bear','Dream'],correct:1,explanation:'Marathon is a type of Race. Hibernation is a type of Sleep.',shortcut:'Type-of relationship'},

  // Logical Reasoning
  {category:'reasoning',topic:'Logical Reasoning',difficulty:1,question:'All dogs are animals. All animals are living things. Therefore:',options:['All dogs are living things','Some living things are dogs','All living things are dogs','Dogs are not animals'],correct:0,explanation:'Dogs⊂Animals⊂Living things. So Dogs⊂Living things.',shortcut:'Transitive: A⊂B⊂C → A⊂C'},
  {category:'reasoning',topic:'Logical Reasoning',difficulty:2,question:'Statement: Some pens are pencils. All pencils are erasers. Conclusion: Some pens are erasers.',options:['True','False','Cannot determine','Partially true'],correct:0,explanation:'Some pens=pencils, all pencils=erasers. So those pens are erasers too.',shortcut:'Venn diagram overlap'},

  // Syllogism
  {category:'reasoning',topic:'Syllogism',difficulty:1,question:'All roses are flowers. Some flowers are red. Conclusion: Some roses are red.',options:['Definitely true','Definitely false','Possibly true','Cannot say'],correct:2,explanation:'We cannot be certain which flowers are red. Some roses MAY be red.',shortcut:'Some+All=Some possibility only'},
  {category:'reasoning',topic:'Syllogism',difficulty:2,question:'No fish is a bird. All sparrows are birds. Conclusion?',options:['No sparrow is a fish','Some fish are sparrows','All birds are sparrows','None valid'],correct:0,explanation:'Fish∩Bird=∅. Sparrows⊂Birds. So Sparrows∩Fish=∅.',shortcut:'No A is B + All C is B → No C is A'},

  // MORE VERBAL
  // Synonyms
  {category:'verbal',topic:'Synonyms',difficulty:1,question:'Synonym of "Diligent":',options:['Lazy','Hardworking','Careless','Slow'],correct:1,explanation:'Diligent=showing careful effort=hardworking',shortcut:''},
  {category:'verbal',topic:'Synonyms',difficulty:2,question:'Synonym of "Meticulous":',options:['Careless','Thorough','Quick','Rough'],correct:1,explanation:'Meticulous=showing great attention to detail=thorough',shortcut:''},
  {category:'verbal',topic:'Synonyms',difficulty:2,question:'Synonym of "Pragmatic":',options:['Idealistic','Practical','Theoretical','Dreamy'],correct:1,explanation:'Pragmatic=dealing with things sensibly=practical',shortcut:''},
  {category:'verbal',topic:'Synonyms',difficulty:1,question:'Synonym of "Commence":',options:['End','Begin','Continue','Pause'],correct:1,explanation:'Commence=begin/start',shortcut:''},

  // Antonyms
  {category:'verbal',topic:'Antonyms',difficulty:1,question:'Antonym of "Brave":',options:['Bold','Fearless','Cowardly','Strong'],correct:2,explanation:'Brave=courageous. Opposite=cowardly.',shortcut:''},
  {category:'verbal',topic:'Antonyms',difficulty:1,question:'Antonym of "Expand":',options:['Grow','Increase','Contract','Extend'],correct:2,explanation:'Expand=make larger. Opposite=contract/shrink.',shortcut:''},
  {category:'verbal',topic:'Antonyms',difficulty:2,question:'Antonym of "Affluent":',options:['Rich','Wealthy','Destitute','Prosperous'],correct:2,explanation:'Affluent=wealthy. Opposite=destitute/poor.',shortcut:''},
  {category:'verbal',topic:'Antonyms',difficulty:2,question:'Antonym of "Tranquil":',options:['Calm','Peaceful','Turbulent','Quiet'],correct:2,explanation:'Tranquil=calm. Opposite=turbulent/chaotic.',shortcut:''},

  // Grammar
  {category:'verbal',topic:'Grammar',difficulty:1,question:'Choose correct: "She ___ to school every day."',options:['go','goes','going','gone'],correct:1,explanation:'3rd person singular present: She goes.',shortcut:'He/She/It → V+s/es'},
  {category:'verbal',topic:'Grammar',difficulty:2,question:'Choose correct: "If I ___ rich, I would travel."',options:['am','was','were','be'],correct:2,explanation:'Subjunctive mood with "if": always use "were".',shortcut:'If+were (subjunctive)'},
  {category:'verbal',topic:'Grammar',difficulty:2,question:'Choose correct: "The committee ___ divided in their opinion."',options:['was','were','is','are'],correct:1,explanation:'Committee acting as individuals=plural→were.',shortcut:'Collective noun as individuals=plural'},

  // Error Detection
  {category:'verbal',topic:'Error Detection',difficulty:1,question:'Find error: "He is more taller than his brother."',options:['He is','more taller','than his','brother'],correct:1,explanation:'Never use more+comparative. Correct: "He is taller than"',shortcut:'More+er is always wrong'},
  {category:'verbal',topic:'Error Detection',difficulty:2,question:'Find error: "Each of the boys have completed their work."',options:['Each of','the boys','have completed','their work'],correct:2,explanation:'"Each" takes singular verb. Correct: "has completed"',shortcut:'Each/Every/Either→singular verb'},

  // Idioms
  {category:'verbal',topic:'Idioms and Phrases',difficulty:1,question:'"Break the ice" means:',options:['Break something','Start a conversation','Freeze water','Stop talking'],correct:1,explanation:'Break the ice=initiate social interaction/conversation.',shortcut:''},
  {category:'verbal',topic:'Idioms and Phrases',difficulty:1,question:'"Burning the midnight oil" means:',options:['Wasting oil','Working late at night','Cooking','Being angry'],correct:1,explanation:'Burning midnight oil=working/studying late into the night.',shortcut:''},
  {category:'verbal',topic:'Idioms and Phrases',difficulty:2,question:'"A piece of cake" means:',options:['A dessert','Very easy','Expensive','Delicious'],correct:1,explanation:'Piece of cake=something very easy to do.',shortcut:''},
  {category:'verbal',topic:'Idioms and Phrases',difficulty:2,question:'"Hit the nail on the head" means:',options:['Use a hammer','Be exactly right','Hurt someone','Miss the point'],correct:1,explanation:'Hit the nail on the head=describe exactly what is causing a situation.',shortcut:''},

  // Sentence Correction
  {category:'verbal',topic:'Sentence Correction',difficulty:1,question:'Correct form: "I have been living here ___ 2010."',options:['from','since','for','by'],correct:1,explanation:'"Since" for specific point in time. "For" for duration.',shortcut:'Since=point, For=period'},
  {category:'verbal',topic:'Sentence Correction',difficulty:2,question:'Correct: "He insisted ___ going there."',options:['on','in','for','to'],correct:0,explanation:'Insist ON (doing something)',shortcut:'Insist on, consist of, depend on'},

  // Fill in Blanks
  {category:'verbal',topic:'Fill in the Blanks',difficulty:1,question:'___ you please help me?',options:['May','Can','Could','Should'],correct:2,explanation:'"Could" is the most polite form for requests.',shortcut:'Could=polite request'},
  {category:'verbal',topic:'Fill in the Blanks',difficulty:2,question:'The news ___ not true.',options:['are','is','were','have'],correct:1,explanation:'"News" is uncountable singular noun→is.',shortcut:'News/Mathematics/Physics=singular'},

  // === GENERAL KNOWLEDGE ===
  {category:'gk',topic:'Indian History',difficulty:1,question:'Who was the first President of India?',options:['Mahatma Gandhi','Dr. Rajendra Prasad','Jawaharlal Nehru','Sardar Patel'],correct:1,explanation:'Dr. Rajendra Prasad served as the first President (1950-1962).',shortcut:''},
  {category:'gk',topic:'Indian History',difficulty:1,question:'Battle of Plassey was fought in which year?',options:['1757','1764','1857','1947'],correct:0,explanation:'Battle of Plassey (1757) between British East India Company and Siraj-ud-Daulah.',shortcut:'1757=Plassey, 1764=Buxar'},
  {category:'gk',topic:'Indian History',difficulty:1,question:'Who started the Quit India Movement?',options:['Subhash Chandra Bose','Bhagat Singh','Mahatma Gandhi','Jawaharlal Nehru'],correct:2,explanation:'Gandhi launched "Quit India" on 8 Aug 1942. Slogan: "Do or Die".',shortcut:'1942=Quit India'},
  {category:'gk',topic:'Indian History',difficulty:2,question:'Jallianwala Bagh massacre occurred in which year?',options:['1917','1919','1920','1921'],correct:1,explanation:'13 April 1919, General Dyer ordered firing in Amritsar.',shortcut:''},
  {category:'gk',topic:'Indian History',difficulty:2,question:'Who founded the Indian National Congress?',options:['A.O. Hume','W.C. Bonnerjee','Dadabhai Naoroji','Surendranath Banerjee'],correct:0,explanation:'Allan Octavian Hume founded INC in 1885. First session in Bombay.',shortcut:'1885=INC founded'},
  {category:'gk',topic:'Indian History',difficulty:2,question:'Ashoka embraced Buddhism after which battle?',options:['Hydaspes','Kalinga','Talikota','Panipat'],correct:1,explanation:'Kalinga War (261 BCE). Ashoka was horrified by the bloodshed.',shortcut:''},
  {category:'gk',topic:'Indian History',difficulty:3,question:'Who wrote "Arthashastra"?',options:['Kalidasa','Chanakya','Banabhatta','Megasthenes'],correct:1,explanation:'Kautilya/Chanakya wrote Arthashastra on statecraft and economics.',shortcut:''},

  {category:'gk',topic:'Indian Polity',difficulty:1,question:'How many Fundamental Rights are in the Indian Constitution?',options:['5','6','7','8'],correct:1,explanation:'6 Fundamental Rights: Equality, Freedom, Exploitation, Religion, Cultural, Remedies.',shortcut:'Originally 7, Right to Property removed (44th Amendment)'},
  {category:'gk',topic:'Indian Polity',difficulty:1,question:'Article 21 deals with?',options:['Right to Equality','Right to Life','Right to Education','Right to Vote'],correct:1,explanation:'Article 21: Protection of Life and Personal Liberty.',shortcut:'21=Life, 14=Equality, 19=Freedom'},
  {category:'gk',topic:'Indian Polity',difficulty:1,question:'Who appoints the Chief Justice of India?',options:['Prime Minister','Parliament','President','Law Minister'],correct:2,explanation:'President appoints CJI on recommendation of outgoing CJI.',shortcut:''},
  {category:'gk',topic:'Indian Polity',difficulty:2,question:'Rajya Sabha members are elected for how many years?',options:['4','5','6','Lifetime'],correct:2,explanation:'Rajya Sabha members serve 6-year terms. 1/3 retire every 2 years.',shortcut:'RS=6 yrs, LS=5 yrs'},
  {category:'gk',topic:'Indian Polity',difficulty:2,question:'Which schedule of the Constitution deals with languages?',options:['6th','7th','8th','9th'],correct:2,explanation:'8th Schedule lists official languages. Currently 22 languages.',shortcut:'8th=Languages, 7th=Union/State/Concurrent lists'},
  {category:'gk',topic:'Indian Polity',difficulty:3,question:'42nd Amendment is known as?',options:['Mini Constitution','Basic Structure','Fundamental Amendment','Federal Amendment'],correct:0,explanation:'42nd Amendment (1976) made maximum changes. Called "Mini Constitution".',shortcut:'42nd=Mini Constitution, during Emergency'},

  {category:'gk',topic:'Geography',difficulty:1,question:'Largest state of India by area?',options:['Madhya Pradesh','Maharashtra','Rajasthan','Uttar Pradesh'],correct:2,explanation:'Rajasthan = 3,42,239 sq km (largest by area).',shortcut:'Area: RJ>MP>MH. Population: UP>MH>BR'},
  {category:'gk',topic:'Geography',difficulty:1,question:'Which river is called "Sorrow of Bengal"?',options:['Ganga','Brahmaputra','Damodar','Hooghly'],correct:2,explanation:'Damodar river caused frequent floods in Bengal.',shortcut:'Sorrow of Bihar=Kosi'},
  {category:'gk',topic:'Geography',difficulty:1,question:'Longest river in India?',options:['Yamuna','Godavari','Ganga','Brahmaputra'],correct:2,explanation:'Ganga = 2,525 km. Godavari is longest peninsular river.',shortcut:'Ganga>Godavari>Krishna>Narmada'},
  {category:'gk',topic:'Geography',difficulty:2,question:'Which soil is best for cotton cultivation?',options:['Alluvial','Red','Black/Regur','Laterite'],correct:2,explanation:'Black soil (Regur) retains moisture. Found in Deccan plateau.',shortcut:'Black=Cotton, Alluvial=Rice/Wheat'},
  {category:'gk',topic:'Geography',difficulty:2,question:'Tropic of Cancer passes through how many Indian states?',options:['6','7','8','9'],correct:2,explanation:'8 states: Gujarat, Rajasthan, MP, Chhattisgarh, Jharkhand, WB, Tripura, Mizoram.',shortcut:'GRiM CJW TM'},

  // SCIENCE
  {category:'gk',topic:'Physics',difficulty:1,question:'Unit of electric current?',options:['Volt','Watt','Ampere','Ohm'],correct:2,explanation:'Ampere (A) measures electric current.',shortcut:'V=Volt, W=Watt, A=Ampere, Ω=Ohm'},
  {category:'gk',topic:'Physics',difficulty:1,question:'Speed of light is approximately?',options:['3×10⁶ m/s','3×10⁸ m/s','3×10¹⁰ m/s','3×10⁴ m/s'],correct:1,explanation:'Speed of light ≈ 3×10⁸ m/s in vacuum.',shortcut:'c = 3×10⁸ m/s'},
  {category:'gk',topic:'Physics',difficulty:1,question:'Which mirror is used in vehicles as rear-view mirror?',options:['Concave','Convex','Plane','Cylindrical'],correct:1,explanation:'Convex mirror gives wider field of view.',shortcut:'Convex=rear view, Concave=torch/headlight'},
  {category:'gk',topic:'Physics',difficulty:2,question:'SI unit of pressure?',options:['Newton','Joule','Pascal','Watt'],correct:2,explanation:'Pascal (Pa) = N/m². 1 atm = 101325 Pa.',shortcut:'Pressure=Force/Area'},
  {category:'gk',topic:'Physics',difficulty:2,question:'Ohm\'s Law states?',options:['V=IR','F=ma','E=mc²','P=VI'],correct:0,explanation:'V=IR. Voltage equals Current times Resistance.',shortcut:'V=IR, P=VI, P=I²R'},

  {category:'gk',topic:'Chemistry',difficulty:1,question:'Chemical formula of water?',options:['H₂O','CO₂','NaCl','HCl'],correct:0,explanation:'Water = H₂O (2 hydrogen + 1 oxygen).',shortcut:''},
  {category:'gk',topic:'Chemistry',difficulty:1,question:'pH of pure water?',options:['0','5','7','14'],correct:2,explanation:'Pure water is neutral with pH=7.',shortcut:'<7=acid, 7=neutral, >7=base'},
  {category:'gk',topic:'Chemistry',difficulty:1,question:'Which gas is used in photosynthesis?',options:['Oxygen','Nitrogen','Carbon Dioxide','Hydrogen'],correct:2,explanation:'Plants absorb CO₂ and release O₂ during photosynthesis.',shortcut:'6CO₂+6H₂O→C₆H₁₂O₆+6O₂'},
  {category:'gk',topic:'Chemistry',difficulty:2,question:'Hardest natural substance?',options:['Iron','Gold','Diamond','Platinum'],correct:2,explanation:'Diamond (pure carbon) is hardest natural substance. Mohs scale=10.',shortcut:''},
  {category:'gk',topic:'Chemistry',difficulty:2,question:'Rusting of iron requires?',options:['Only water','Only oxygen','Water and oxygen','Nitrogen'],correct:2,explanation:'Rusting needs both water and oxygen. 4Fe+3O₂+6H₂O→4Fe(OH)₃.',shortcut:''},

  {category:'gk',topic:'Biology',difficulty:1,question:'Largest organ of the human body?',options:['Heart','Liver','Skin','Brain'],correct:2,explanation:'Skin is the largest organ. Liver is largest internal organ.',shortcut:''},
  {category:'gk',topic:'Biology',difficulty:1,question:'Normal human body temperature?',options:['36°C','37°C','38°C','39°C'],correct:1,explanation:'Normal body temperature = 37°C (98.6°F).',shortcut:''},
  {category:'gk',topic:'Biology',difficulty:1,question:'Red blood cells are produced in?',options:['Heart','Liver','Bone Marrow','Kidneys'],correct:2,explanation:'RBCs are produced in bone marrow. Lifespan ≈ 120 days.',shortcut:''},
  {category:'gk',topic:'Biology',difficulty:2,question:'Which vitamin is produced by sunlight?',options:['Vitamin A','Vitamin B','Vitamin C','Vitamin D'],correct:3,explanation:'Vitamin D is synthesized in skin when exposed to UV rays.',shortcut:'D=Sunlight, C=Citrus, A=Carrots, K=Blood clotting'},
  {category:'gk',topic:'Biology',difficulty:2,question:'Deficiency of Vitamin C causes?',options:['Rickets','Scurvy','Beriberi','Night Blindness'],correct:1,explanation:'Scurvy: bleeding gums, weakness. Citrus fruits prevent it.',shortcut:'A=Night Blindness, B1=Beriberi, C=Scurvy, D=Rickets'},
  {category:'gk',topic:'Biology',difficulty:2,question:'Which blood group is universal donor?',options:['A','B','AB','O'],correct:3,explanation:'O-negative is universal donor. AB+ is universal recipient.',shortcut:'O=donor, AB=recipient'},
  {category:'gk',topic:'Biology',difficulty:3,question:'DNA full form?',options:['Dioxyribo Nucleic Acid','Deoxyribo Nucleic Acid','Di Nucleic Acid','Deoxy Nucleotide Acid'],correct:1,explanation:'Deoxyribonucleic Acid. Double helix structure.',shortcut:''},

  // ECONOMICS
  {category:'gk',topic:'Economics',difficulty:1,question:'RBI was established in which year?',options:['1935','1947','1950','1969'],correct:0,explanation:'RBI established on 1 April 1935. Nationalized in 1949.',shortcut:'1935=RBI, 1969=Bank Nationalization'},
  {category:'gk',topic:'Economics',difficulty:1,question:'GST was implemented from which date?',options:['1 Jan 2017','1 Apr 2017','1 Jul 2017','1 Oct 2017'],correct:2,explanation:'GST launched midnight 1 July 2017. 101st Constitutional Amendment.',shortcut:''},
  {category:'gk',topic:'Economics',difficulty:1,question:'Current GST council chairman?',options:['RBI Governor','President','Finance Minister','PM'],correct:2,explanation:'Union Finance Minister chairs the GST Council.',shortcut:''},
  {category:'gk',topic:'Economics',difficulty:2,question:'Fiscal deficit means?',options:['Revenue-Expenditure','Total expenditure-Total receipts excluding borrowing','Imports-Exports','GDP-GNP'],correct:1,explanation:'Fiscal Deficit = Total Expenditure - Total Receipts (excluding borrowing).',shortcut:''},
  {category:'gk',topic:'Economics',difficulty:2,question:'Which Five Year Plan is called "Mahalanobis Plan"?',options:['First','Second','Third','Fourth'],correct:1,explanation:'2nd Five Year Plan (1956-61). Focus on heavy industrialization.',shortcut:'1st=Harrod-Domar, 2nd=Mahalanobis'},
  {category:'gk',topic:'Economics',difficulty:2,question:'NITI Aayog replaced which body?',options:['RBI','SEBI','Planning Commission','Finance Commission'],correct:2,explanation:'NITI Aayog replaced Planning Commission in 2015.',shortcut:''},

  // TAMIL NADU SPECIFIC
  {category:'gk',topic:'Tamil Nadu GK',difficulty:1,question:'Capital of Tamil Nadu?',options:['Madurai','Coimbatore','Chennai','Trichy'],correct:2,explanation:'Chennai (formerly Madras) is the capital of Tamil Nadu.',shortcut:''},
  {category:'gk',topic:'Tamil Nadu GK',difficulty:1,question:'How many districts in Tamil Nadu (2024)?',options:['32','36','38','40'],correct:2,explanation:'Tamil Nadu has 38 districts as of 2024.',shortcut:''},
  {category:'gk',topic:'Tamil Nadu GK',difficulty:1,question:'Official animal of Tamil Nadu?',options:['Tiger','Nilgiri Tahr','Elephant','Lion'],correct:1,explanation:'Nilgiri Tahr (Varai Aadu) is the state animal of TN.',shortcut:'State bird=Emerald Dove, Tree=Palm'},
  {category:'gk',topic:'Tamil Nadu GK',difficulty:2,question:'Who is known as "Periyar"?',options:['Kamaraj','E.V. Ramasamy','C.N. Annadurai','Bharathiar'],correct:1,explanation:'E.V. Ramasamy Naicker - social reformer, Self-Respect Movement founder.',shortcut:''},
  {category:'gk',topic:'Tamil Nadu GK',difficulty:2,question:'Highest peak in Tamil Nadu?',options:['Ooty Peak','Kodaikanal Peak','Doddabetta','Anaimudi'],correct:2,explanation:'Doddabetta (2,637m) in Nilgiris. Anaimudi is in Kerala.',shortcut:''},
  {category:'gk',topic:'Tamil Nadu GK',difficulty:2,question:'Which dynasty built the Brihadeeswarar Temple?',options:['Pallava','Pandya','Chola','Hoysala'],correct:2,explanation:'Rajaraja Chola I built it in Thanjavur (1010 CE). UNESCO site.',shortcut:''},

  // COMPUTER AWARENESS
  {category:'gk',topic:'Computer',difficulty:1,question:'Full form of CPU?',options:['Central Processing Unit','Computer Processing Unit','Central Program Unit','Control Processing Unit'],correct:0,explanation:'CPU = Central Processing Unit, "brain" of the computer.',shortcut:''},
  {category:'gk',topic:'Computer',difficulty:1,question:'1 KB equals?',options:['1000 bytes','1024 bytes','512 bytes','2048 bytes'],correct:1,explanation:'1 KB = 1024 bytes. 1 MB = 1024 KB.',shortcut:'KB→MB→GB→TB (×1024)'},
  {category:'gk',topic:'Computer',difficulty:1,question:'Which is NOT an input device?',options:['Keyboard','Mouse','Monitor','Scanner'],correct:2,explanation:'Monitor is an output device. Keyboard, mouse, scanner are input.',shortcut:''},
  {category:'gk',topic:'Computer',difficulty:2,question:'Full form of HTML?',options:['Hyper Text Markup Language','High Text Markup Language','Hyper Transfer Markup Language','Home Tool Markup Language'],correct:0,explanation:'HTML = HyperText Markup Language, used to create web pages.',shortcut:''},
  {category:'gk',topic:'Computer',difficulty:2,question:'Which generation of computers used transistors?',options:['1st','2nd','3rd','4th'],correct:1,explanation:'1st=Vacuum tubes, 2nd=Transistors, 3rd=ICs, 4th=Microprocessors.',shortcut:''},
];

const CURRENT_AFFAIRS = [
  {title:'India Launches Chandrayaan-4 Mission',content:'ISRO successfully launched Chandrayaan-4 from Sriharikota, aiming to bring back lunar soil samples from the Moon\'s south pole. India becomes the fourth country to achieve lunar sample return.',category:'Science',date:'May 2026'},
  {title:'TN Government Launches AI Skill Program',content:'Tamil Nadu launched AI & Digital Skills Development Program targeting 5 lakh youth, in collaboration with IIT Madras. Free courses in AI, ML, and Data Science with job placement assistance.',category:'Tamil Nadu',date:'May 2026'},
  {title:'RBI Maintains Repo Rate at 6.25%',content:'RBI MPC maintained repo rate at 6.25%. GDP growth projection for FY2027 set at 7.2%, CPI inflation expected around 4.5%.',category:'National',date:'May 2026'},
  {title:'India Signs FTA with European Union',content:'India and EU signed comprehensive Free Trade Agreement covering goods, services, and investments. Expected to boost bilateral trade by 30%.',category:'International',date:'Apr 2026'},
  {title:'Indian Hockey Wins Asian Champions Trophy',content:'Indian Men\'s Hockey Team won Asian Champions Trophy 2026 in Muscat, defeating Pakistan 3-1 in final. Fifth title for India.',category:'Sports',date:'Apr 2026'},
  {title:'NEP 2020 Full Implementation',content:'Ministry of Education announced full implementation of NEP 2020 undergraduate curriculum reform across all central universities from 2026-27.',category:'National',date:'Apr 2026'},
  {title:'Chennai Metro Phase 2 Opens',content:'First section of Chennai Metro Phase 2 connecting Madhavaram to CMBT inaugurated. 18.5 km stretch with 15 stations, serving 2 lakh passengers daily.',category:'Tamil Nadu',date:'Apr 2026'},
  {title:'India 3rd Largest Solar Power Producer',content:'India surpassed Japan to become world\'s third-largest solar power producer at 120 GW installed capacity. Target: 280 GW by 2030.',category:'National',date:'Mar 2026'},
  {title:'TNPSC Group 4 Notification 2026',content:'TNPSC released Group IV (CCSE) 2026 notification with 6,318 vacancies. Exam scheduled August 2026. Qualification: SSLC/10th pass.',category:'Tamil Nadu',date:'Mar 2026'},
  {title:'COP31 Climate Summit Resolutions',content:'COP31 in Sydney concluded with accelerated fossil fuel phase-out, $200B climate adaptation fund. India committed to 65% non-fossil fuel capacity by 2032.',category:'International',date:'Mar 2026'},
];

const MOTIVATIONAL_QUOTES = [
  'Keep pushing! Every question counts! 💪',
  'You\'re getting better every day! 📈',
  'Consistency is the key to success! 🔑',
  'One step at a time. You\'ll get there! 🚀',
  'Great progress today! Keep it up! ⭐',
];

const APTITUDE_TOPICS = ['Percentages','Ratio and Proportion','Profit and Loss','Time and Work','Time and Distance','Simplification','Number Systems','Average','Probability','Simple Interest','Compound Interest'];
const REASONING_TOPICS = ['Blood Relations','Coding-Decoding','Seating Arrangement','Direction Sense','Number Series','Puzzle Solving','Logical Reasoning','Syllogism','Analogy'];
const VERBAL_TOPICS = ['Synonyms','Antonyms','Grammar','Error Detection','Reading Comprehension','Sentence Correction','Fill in the Blanks','Idioms and Phrases'];
const GK_TOPICS = ['Indian History','Indian Polity','Geography','Physics','Chemistry','Biology','Economics','Tamil Nadu GK','Computer'];
