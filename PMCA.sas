PROC IMPORT datafile='C:/Users/sfreyeue/Downloads/PCORI_PMCA.csv'
  dbms=csv
  out=pcori
  replace;
RUN;

PROC PRINT data=pcori (obs=15); RUN;

DATA pcori;
 set pcori;
 
 pulresp=0;
 neuro=0;
 progressive=0;
 musculo=0;
 genito=0;
 immuno=0;
 gastro=0;
 derm=0;
 opthal=0;
 otol=0;
 endo=0;
 malign=0;
 mh=0;
 hemato=0;
 genetic=0;
 metab=0;
 cardiac=0;
 renal=0;
 cranio=0;

 array dxc(32) $12 DX1-DX32;

 do i=1 to 32;

     if dxc(i) =:'A15'    then pulresp=1;
    if dxc(i) in: ('A171' 'A1781' 'A1783')  then neuro=1;
    if dxc(i) in: ('A170' 'A1782' 'A1789' 'A179')  then do; neuro=1; progressive=1; end;
    if dxc(i) =:'A180'   then musculo=1;
    if dxc(i) =:'A181'   then genito=1;
    if dxc(i) in:('A182' 'A1885')   then immuno=1;
    if dxc(i) =:'A183'   then gastro=1;
    if dxc(i) =:'A184'   then derm=1;
    if dxc(i) =:'A185'   then opthal=1;
    if dxc(i) =:'A186'   then otol=1;
    if dxc(i) in: ('A187' 'A1881' 'A1882')  then endo=1;
    if dxc(i) in: ('A1889' 'A19')   then pulresp=1;
    if dxc(i) =:'A30'   then neuro=1;
    if dxc(i) in: ('A50' 'A521' 'A522' 'A523' 'A527' 'A528'
        'A529' 'A53' 'A81' 'B100' 'B900' 'B91' )
        then do; neuro=1; progressive=1; end;
    if dxc(i) =:'B20'  then do; immuno=1; progressive=1; end;
    if dxc(i) =:'B901'   then genito=1;
    if dxc(i) =:'B902'   then musculo=1;
    if dxc(i) in:('B908' 'B909')   then pulresp=1;
    if dxc(i) =:'B9735'   then do; immuno=1; progressive=1; end;
    if dxc(i) in: ('C0' 'C1' 'C2' 'C3' 'C40' 'C41'
        'C43' 'C4A' 'C44' 'C46' 'C47' 'C48'
        'C49' 'C5' 'C6' 'C7' 'C8' 'C90'
        'C910' 'C911' 'C913' 'C914' 'C916'
        'C919' 'C91Z' 'C92' 'C93' 'C940'
        'C942' 'C943' 'C948' 'C95' 'C96'
        'D03' 'D45' 'D474' 'D47Z1')   then malign=1;
    if dxc(i) in: ('D510' 'D511' 'D55' 'D565' 'D568'
      'D569' 'D5744' 'D5745' 'D58'
      'D5910' 'D5911' 'D5913' 'D5919'
      'D594' 'D599' 'D600'
      'D608' 'D609' 'D63' 'D640' 'D641' 'D642' 'D643'
      'D6489' 'D680' 'D681' 'D682' 'D68312'
      'D68318' 'D685' 'D6861' 'D6862' 'D688'
      'D689' 'D691' 'D693' 'D6941' 'D6949' 'D75A' 'D7589' ) then hemato=1;
    if dxc(i) in: ('D560' 'D561' 'D570' 'D571' 'D572'
      'D5741' 'D5742' 'D5743'
      'D578' 'D610' 'D61818' 'D6182'
      'D6189' 'D619' 'D644' 'D66' 'D67'
      'D68311' 'D6942' 'D7581') then do; hemato=1; progressive=1; end;
    if dxc(i) in: ('D704' 'D720' 'D763' 'D802' 'D803'
      'D804' 'D805' 'D808' 'D838' 'D839'
      'D841' 'D842' 'D849' 'D86' 'D890' 'D891'
      'D892' 'D8989' 'D899') then immuno=1;
    if dxc(i) in: ('D700' 'D71' 'D761' 'D800' 'D801'
      'D810' 'D811' 'D812' 'D813' 'D814' 'D8189' 'D819'
      'D831' 'D89811' 'D89813') then do; immuno=1; progressive=1; end;
    if dxc(i) in: ('D820' 'D8982')   then genetic=1;
    if dxc(i) =:'D821' then do; genetic=1; progressive=1; end;
    if dxc(i) in: ('E018' 'E030' 'E031' 'E032' 'E034'
      'E038' 'E039' 'E04' 'E062' 'E063' 'E064' 'E065'
      'E069' 'E070' 'E071' 'E0789' 'E079' 'E08'
      'E09' 'E10' 'E11' 'E13' 'E209' 'E21'
      'E220' 'E228' 'E229' 'E232' 'E236' 'E243'
      'E248' 'E249' 'E25' 'E260' 'E261' 'E2681'
      'E269' 'E270' 'E271' 'E274' 'E275' 'E278'
      'E279' 'E28' 'E29' 'E310' 'E318' 'E319'
      'E45')   then endo=1;
    if dxc(i) in: ('E00' 'E230') then do; endo=1; progressive=1; end;
    if dxc(i) =: 'E312'   then malign=1;
    if dxc(i) in: ('E40' 'E43' 'E440' 'E50' 'E52' 'E53' 'E54'
        'E550' 'E643' 'E6601' 'E800' 'E8020'
        'E8029' 'E805' 'E880' 'E888')   then metab=1;
    if dxc(i) =: 'E45'   then neuro=1;
    if dxc(i) in: ('E700' 'E7021' 'E7029' 'E7040' 'E705'
      'E708' 'E710' 'E71120' 'E7119' 'E712'
      'E7131' 'E7141' 'E7142' 'E7144' 'E7150'
      'E71510' 'E71511' 'E71522' 'E71529'
      'E71548' 'E7200' 'E7203' 'E7204' 'E7209'
      'E7210' 'E7211' 'E7219' 'E7220' 'E7222'
      'E7223' 'E7229' 'E723' 'E728' 'E729' 'E7400'
      'E7401' 'E7404' 'E7409' 'E7421' 'E7439'
      'E744' 'E748' 'E749' 'E7502' 'E7519' 'E7521'
      'E7522' 'E7523' 'E75249' 'E7525' 'E7526' 'E7529'
      'E754' 'E7601' 'E7603' 'E761' 'E76219'
      'E7622' 'E7629' 'E763' 'E770' 'E771'
      'E786' 'E7870' 'E7871' 'E7872' 'E788' 'E789'
      'E791' 'E798' 'E83' 'E85' 'E881' 'E884') then do; metab=1; progressive=1; end;
    if dxc(i) in: ('E84') then do; pulresp=1; progressive=1; end;
    if dxc(i) in: ('E890' 'E894' 'E895')   then endo=1;
    if dxc(i) in: ('F04' 'F070' 'F1020' 'F1021' 'F1096'
      'F1120' 'F1121' 'F1320' 'F1321' 'F1420'
      'F1421' 'F1520' 'F1521' 'F1620' 'F1621'
      'F1820' 'F1821' 'F1920' 'F1921' 'F21'
      'F22' 'F24' 'F31' 'F32'
      'F33' 'F340' 'F341' 'F39' 'F429'
      'F444' 'F445' 'F446' 'F447' 'F448'
      'F449' 'F450' 'F4521' 'F4522' 'F60'
      'F63' 'F6812'
      'F840' 'F843' 'F845' 'F848' 'F849'
      'F88' 'F89' 'F90' 'F911' 'F912'
      'F913' 'F918' 'F919' 'F951' 'F952'
      'F981' 'F984' )   then mh=1;
    if dxc(i) in: ('F200' 'F201' 'F202' 'F203' 'F205' 'F208' 'F25'
      'F50' ) then do; mh=1; progressive=1; end;
    if dxc(i) in: ('F7' 'F801' 'F802' 'F804' 'F81' 'F82'
      'G110' 'G255' 'G371' 'G372' 'G400'
      'G401' 'G402' 'G403' 'G404' 'G405'
      'G4080' 'G4082' 'G409' 'G40A' 'G40B'
      'G474' 'G50' 'G510' 'G511' 'G512'
      'G518' 'G519' 'G52' 'G54' 'G56' 'G57'
      'G587' 'G588' 'G589' 'G600' 'G603'
      'G608' 'G609' 'G6181' 'G6189' 'G619'
      'G620' 'G621' 'G622' 'G63'  'G7000'
      'G701' 'G702' 'G7080' 'G7089' 'G709'
      'G7114' 'G7119' 'G7102' 'G722' 'G723'
      'G7289' 'G729' 'G733' 'G737' 'G801'
      'G802' 'G803' 'G804' 'G81' 'G822'
      'G825' 'G830' 'G831' 'G832' 'G833'
      'G834' 'G835' 'G8381' 'G8389' 'G839'
      'G900' 'G904' 'G905' 'G908' 'G909'
      'G910' 'G911' 'G932' 'G9389' 'G939'
      'G969' 'G990' )   then neuro=1;
    if dxc(i) in: ('F842' 'G09' 'G10' 'G111' 'G113'
      'G114' 'G118' 'G119' 'G12'
      'G14' 'G23' 'G241' 'G253' 'G2582'
      'G3181' 'G3182' 'G319' 'G320'
      'G3281' 'G35' 'G360' 'G370' 'G375'
      'G378' 'G379' 'G4081' 'G4083' 'G601' 'G7100' 'G7101' 'G7109'
      'G7111' 'G7112' 'G7113' 'G712' 'G800' 'G808'
      'G809' 'G901' 'G931' 'G950' 'G9519'
      'G9589' 'G959' 'G992'  ) then do; neuro=1; progressive=1; end;
    if dxc(i) in: ('G4730' 'G4731' 'G4733' 'G4734' 'G4736'
      'G4737' 'G4739' )   then pulresp=1;
    if dxc(i) in: ('G4735' ) then do; pulresp=1; progressive=1; end;
    if dxc(i) in: ('H150' 'H158' 'H201' 'H202'
      'H208' 'H209' 'H212' 'H2150' 'H2151'
      'H2152' 'H2154' 'H2155' 'H2156'
      'H218' 'H270' 'H2711' 'H2712' 'H2713'
      'H278' 'H300' 'H301' 'H302' 'H3081'
      'H309' 'H310' 'H3110' 'H3112' 'H312'
      'H313' 'H314' 'H318' 'H319' 'H330'
      'H3310' 'H3319' 'H332' 'H333' 'H334'
      'H338' 'H34' 'H350' 'H3515' 'H3516' 'H3517'
      'H352' 'H3530' 'H3533' 'H3534' 'H3535' 'H3536'
      'H3537' 'H3538' 'H3540' 'H3541' 'H3542'
      'H3543' 'H3545' 'H3546' 'H355' 'H357'
      'H3589' 'H36' 'H401' 'H402' 'H403'
      'H404' 'H405' 'H406' 'H408' 'H409' 'H42'
      'H430' 'H432' 'H433' 'H4381' 'H4389'
      'H4430' 'H4440' 'H4450' 'H46' 'H4701'
      'H4703' 'H4709' 'H4714' 'H472' 'H4731'
      'H4732' 'H4739' 'H474' 'H475' 'H476'
      'H479' 'H490' 'H491' 'H492' 'H493'
      'H494' )   then opthal=1;
    if dxc(i) in: ('H4981' ) then do; metab=1; progressive=1; end;
    if dxc(i) in: ('H4988' 'H5000' 'H5005' 'H5006'
      'H5007' 'H5008' 'H5010' 'H5015' 'H5016'
      'H5017' 'H5018' 'H5030' 'H5032' 'H5034'
      'H5040' 'H5042' 'H5043' 'H505' 'H5060'
      'H5069' 'H5089' 'H51' 'H540' 'H541'
      'H542' 'H543' 'H548' 'H550' 'H578' 'H579')   then opthal=1;
    if dxc(i) in: ('H71' 'H74' 'H80' 'H81' 'H83'
      'H903' 'H905' 'H906' 'H908'
      'H913' 'H918X3' 'H918X9' 'H9190'
      'H9193' 'H93093' 'H93099' 'H9313'
      'H9319' 'H9325' 'H933X3' 'H933X9')   then otol=1;
    if dxc(i) in: ('I00' 'I05' 'I06' 'I07'
      'I080' 'I088' 'I089' 'I09'
      'I10' 'I119' 'I340' 'I348' 'I35'
      'I370' 'I378' 'I44' 'I4510' 'I4519' 'I452'
      'I453' 'I454' 'I455' 'I456' 'I458'
      'I459' 'I471' 'I472' 'I48' 'I4901'
      'I517' 'I720' 'I721' 'I722' 'I723'
      'I724' 'I728' 'I729' 'I7300' 'I7301'
      'I7381' 'I7389' 'I739' 'I770' 'I771'
      'I773' 'I774' 'I775' 'I776' 'I778'
      'I779' 'I798' 'I825' 'I82211' 'I82221' 'I82291'
      'I82709' 'I82719' 'I82729' 'I82891'
      'I82A29' 'I82B29' 'I82C29' 'I890')   then cardiac=1;
    if dxc(i) in: ('I110' 'I200' 'I21' 'I24'
      'I2510' 'I252' 'I253' 'I254' 'I255'
      'I258' 'I259' 'I270' 'I271' 'I272'
      'I278' 'I279' 'I280' 'I281' 'I288' 'I289'
      'I421' 'I422' 'I423' 'I424'
      'I425' 'I426' 'I428' 'I43' 'I4902'
      'I50' 'I515' 'I712' 'I714' 'I716'
      'I719' 'I81' 'I820') then do; cardiac=1; progressive=1; end;
    if dxc(i) in: ('I150' 'I158' )   then renal=1;
    if dxc(i) in: ('I12' 'I13' ) then do; renal=1; progressive=1; end;
    if dxc(i) in: ('I69898' 'I699')   then neuro=1;
    if dxc(i) in: ('I630' 'I631' 'I632' 'I638' 'I65' 'I671'
      'I674' 'I675' 'I676' 'I677' ) then do; neuro=1; progressive=1; end;
    if dxc(i) in: ('J45' 'J47' 'J84842' 'J950'
      'J985' 'J986' )   then pulresp=1;
    if dxc(i) in: ('J840' 'J8410' 'J84111' 'J84112' 'J8417'
      'J84117' 'J842' 'J8483' 'J84841' 'J84843'
      'J84848' 'J8489' 'J849') then do; pulresp=1; progressive=1; end;
    if dxc(i) in: ('K110' 'K111' 'K117' 'K200' 'K220'
      'K224' 'K225' 'K227' 'K228' 'K254'
      'K255' 'K256' 'K257' 'K264' 'K265'
      'K266' 'K267' 'K274' 'K275' 'K276'
      'K277' 'K284' 'K285' 'K286' 'K287'
      'K3184' 'K50' 'K510' 'K512' 'K513'
      'K518' 'K519' 'K624' 'K6282' 'K632'
      'K763' 'K7689' 'K769' 'K77' 'K811'
      'K823' 'K824' 'K828' 'K833'
      'K834' 'K835' 'K838' 'K861' 'K862'
      'K863' 'K868' 'K900' 'K901' 'K902'
      'K903' 'K9081' 'K915')   then gastro=1;
    if dxc(i) in: ('K73' 'K74' 'K754' 'K761' 'K766'
      'K767' 'K8301') then do; gastro=1; progressive=1; end;
    if dxc(i) in: ('L100' 'L101' 'L102' 'L104' 'L109'
      'L120' 'L121' 'L122' 'L128' 'L13'
      'L574' 'L744' 'L89' 'L904' 'L940'
      'L943' 'L97' 'L984' 'L988')   then derm=1;
    if dxc(i) in: ('M050' 'M051' 'M0530' 'M0560' 'M060'
      'M062' 'M063' 'M068' 'M069' 'M08' 'M111'
      'M112' 'M118' 'M119' 'M120'
      'M303' 'M311' 'M313' 'M314' 'M316'
      'M33' 'M3500' 'M3501' 'M353' 'M45'
      'M461' 'M468' 'M469' 'M481')   then immuno=1;
    * [RP] Adding a space at the end of M358 b/c we *do* want M35.8 but we dont want M35.81 ;
    if dxc(i) in: ('L930' 'L932' 'M300' 'M310' 'M312'
      'M321' 'M340' 'M341' 'M349' 'M355'
      'M358 ' 'M359') then do; immuno=1; progressive=1; end;
    if dxc(i) in: ('M100' 'M103' 'M104' 'M109'
      'M1A0' 'M1A3' 'M1A4' 'M1A9')   then metab=1;
    if dxc(i) in: ('M2105' 'M2115' 'M2133' 'M2137' 'M215'
      'M216X' 'M2175' 'M2176' 'M232' 'M233'
      'M241' 'M242' 'M243' 'M2449' 'M245'
      'M246' 'M247' 'M248' 'M278' 'M400'
      'M4020' 'M41' 'M420' 'M430' 'M431'
      'M438' 'M460' 'M471' 'M4781' 'M482'
      'M483' 'M489' 'M498' 'M500' 'M502'
      'M503' 'M5106' 'M513' 'M514' 'M519'
      'M61' 'M625' 'M6289' 'M720' 'M722'
      'M816' 'M818' 'M852' 'M863' 'M864'
      'M865' 'M866' 'M870' 'M88'
      'M890' 'M894' 'M897' 'M908'
      'M918' 'M955' 'M961' 'M998')   then musculo=1;
    if dxc(i) in: ('M623' 'M906' 'N250') then do; musculo=1; progressive=1; end;
    if dxc(i) in: ('N08' 'N13' 'N1372' 'N251'
      'N2889' 'N312' 'N318' 'N319' 'N320'
      'N321' 'N322' 'N3501' 'N35028' 'N351'
      'N358' 'N359' 'N360' 'N361' 'N362'
      'N364' 'N365' 'N368' 'N37' 'N3942'
      'N3945' 'N3946' 'N39490' 'N39498')   then renal=1;
    if dxc(i) in: ('N02' 'N03' 'N04' 'N05' 'N18' 'N19') then do; renal=1; progressive=1; end;
    if dxc(i) in: ('N500' 'N80' 'N810' 'N811' 'N812'
      'N813' 'N814' 'N815' 'N816' 'N8181'
      'N8182' 'N8183' 'N8184' 'N8189' 'N819'
      'N820' 'N821' 'N824' 'N825' 'N828'
      'N829' 'N87' 'N880' 'N893' 'N894' 'N900' 'N901'
      'N904' 'N9081' 'N99110' 'N99111'
      'N99112' 'N99113' 'N99114' )   then genito=1;
    if dxc(i) in: ('P270' 'P271' 'P278' )   then pulresp=1;
    if dxc(i) in: ('P293')   then cardiac=1;
    if dxc(i) in: ('Q030' 'Q031' 'Q038' 'Q0702')   then neuro=1;
    if dxc(i) in: ('Q00' 'Q01' 'Q02' 'Q041' 'Q042'
      'Q043' 'Q045' 'Q048' 'Q05' 'Q060'
      'Q061' 'Q062' 'Q063' 'Q064' 'Q068'
      'Q0701' 'Q0703' 'Q078' 'Q079') then do; neuro=1; progressive=1; end;
    if dxc(i) in: ('Q100' 'Q103' 'Q107' 'Q110' 'Q111'
      'Q112' 'Q130' 'Q131' 'Q132' 'Q133'
      'Q134' 'Q135' 'Q1381' 'Q1389' 'Q140'
      'Q141' 'Q142' 'Q143' 'Q148' 'Q150')   then opthal=1;
    if dxc(i) in: ('Q16' 'Q171' 'Q172' 'Q174' 'Q178'
      'Q179' 'Q180' 'Q181' 'Q182' 'Q189')   then otol=1;
    if dxc(i) in: ('Q210' 'Q211' 'Q220' 'Q221' 'Q222'
      'Q223' 'Q229' 'Q230' 'Q231' 'Q232'
      'Q233' 'Q238' 'Q242' 'Q243' 'Q244'
      'Q245' 'Q246' 'Q248' 'Q251' 'Q252'
      'Q253' 'Q254' 'Q255' 'Q256' 'Q257'
      'Q269' 'Q282' 'Q283' 'Q288')   then cardiac=1;
    if dxc(i) in: ('Q200' 'Q201' 'Q202' 'Q203' 'Q204' 'Q205'
      'Q208' 'Q212' 'Q213' 'Q218' 'Q219'
      'Q225' 'Q234') then do; cardiac=1; progressive=1; end;
    if dxc(i) in: ('Q300' 'Q301' 'Q308' 'Q310' 'Q311'
      'Q318' 'Q321' 'Q324' 'Q332' 'Q338'
      'Q339' 'Q34')   then pulresp=1;
    if dxc(i) in: ('Q330' 'Q333' 'Q334' 'Q336' ) then do; pulresp=1; progressive=1; end;
    if dxc(i) in: ('Q351' 'Q353' 'Q355' 'Q359' 'Q36'
      'Q37' 'Q385')   then cranio=1;
    if dxc(i) in: ('Q382' 'Q383' 'Q384' 'Q388' 'Q390'
      'Q391' 'Q392' 'Q393' 'Q394' 'Q395'
      'Q396' 'Q398' 'Q402' 'Q409' 'Q41'
      'Q42' 'Q431' 'Q433' 'Q437' 'Q438'
      'Q441' 'Q458' 'Q459')   then gastro=1;
    if dxc(i) in: ('Q442' 'Q443' 'Q445' 'Q446' 'Q447'
      'Q450') then do; gastro=1; progressive=1; end;
    if dxc(i) in: ('Q540' 'Q541' 'Q542' 'Q543' 'Q548'
      'Q549' 'Q563' 'Q564' 'Q6101' 'Q6210'
      'Q6211' 'Q6212' 'Q6231' 'Q6239' 'Q624'
      'Q625' 'Q6261' 'Q6262' 'Q6263' 'Q628'
      'Q640' 'Q6410' 'Q6419' 'Q6431' 'Q644'
      'Q645' 'Q646' 'Q6471' 'Q6473' 'Q6474'
      'Q6475' 'Q6479' 'Q649')   then genito=1;
     if dxc(i) in: ('Q600' 'Q601' 'Q602' 'Q603' 'Q604'
      'Q605' 'Q6100' 'Q6102' 'Q6119'
      'Q612' 'Q613' 'Q614' 'Q615' 'Q618'
      'Q619') then do; genito=1; progressive=1; end;
    if dxc(i) in: ('Q650' 'Q651' 'Q652' 'Q653' 'Q654'
      'Q655' 'Q667' 'Q6689' 'Q670' 'Q671'
      'Q672' 'Q673' 'Q674' 'Q675' 'Q688'
      'Q710' 'Q711' 'Q712' 'Q713' 'Q714'
      'Q715' 'Q716' 'Q7189' 'Q719' 'Q720'
      'Q721' 'Q722' 'Q723' 'Q724' 'Q725'
      'Q726' 'Q727' 'Q7289' 'Q73' 'Q740'
      'Q760' 'Q761' 'Q762' 'Q763' 'Q764'
      'Q774' 'Q776' 'Q778' 'Q780'
      'Q781' 'Q782' 'Q783' 'Q784' 'Q788'
      'Q789' 'Q796' 'Q798' 'Q799')   then musculo=1;
    if dxc(i) in: ('Q771' 'Q790' 'Q791' 'Q792' 'Q793'
      'Q794' 'Q7959' 'Q7963') then do; musculo=1; progressive=1; end;
    if dxc(i) in: ('Q750' 'Q759') then cranio=1;
    if dxc(i) in: ('Q7951') then genito=1;
    if dxc(i) in: ('Q803' 'Q804' 'Q809' 'Q824') then do; derm=1; progressive=1; end;
    if dxc(i) in: ('Q820') then derm=1;
    if dxc(i) in: ('Q850') then neuro=1;
    if dxc(i) in: ('Q851' 'Q858' 'Q871' 'Q872' 'Q873'
      'Q8740' 'Q875' 'Q8789' 'Q897' 'Q898'
      'Q899' 'Q90' 'Q933' 'Q935' 'Q937' 'Q9381'
      'Q9389' 'Q96' 'Q970' 'Q971' 'Q972' 'Q978'
      'Q980' 'Q981' 'Q984' 'Q985' 'Q987'
      'Q988' 'Q992' 'Q998' 'Q999') then genetic=1;
    if dxc(i) in: ('Q8711' 'Q8781' 'Q8901' 'Q891' 'Q892' 'Q893'
      'Q894' 'Q913' 'Q917' 'Q928' 'Q934'
      'Q9382' 'Q9388') then do; genetic=1; progressive=1; end;
    if dxc(i) in: ('R4020' 'R403' 'S1410' 'S1411' 'S1412'
      'S1413' 'S1415' 'S2410' 'S2411' 'S2413'
      'S2415' 'S3410' 'S3411' 'S3412' 'S3413'
      'S343') then do; neuro=1; progressive=1; end;
    if dxc(i) in: ('S4801' 'S4802' 'S4811' 'S4812'
      'S4891' 'S4892' 'S5801' 'S5802'
      'S5811' 'S5812' 'S5891' 'S5892'
      'S6841' 'S6842' 'S6871' 'S6872'
      'S7801' 'S7802' 'S7811' 'S7812'
      'S7891' 'S7892' 'S8801' 'S8802'
      'S8811' 'S8812' 'S8891' 'S8892'
      'S9801' 'S9802' 'S9831' 'S9832'
      'S9891' 'S9892') then musculo=1;
    if dxc(i) in: ('Z21') then immuno=1;
    if dxc(i) in: ('Z430') then pulresp=1;
    if dxc(i) in: ('Z431' 'Z432' 'Z433' 'Z434' 'Z465') then gastro=1;
    if dxc(i) in: ('Z435' 'Z436' 'Z437') then genito=1;
    if dxc(i) in: ('Z440' 'Z441') then musculo=1;
    if dxc(i) in: ('Z450' 'Z953') then cardiac=1;
    if dxc(i) in: ('Z4531') then opthal=1;
    if dxc(i) in: ('Z45328' 'Z454' 'Z461' 'Z462') then neuro=1;
    if dxc(i) in: ('Z49' 'Z940') then do; renal=1; progressive=1; end;
    if dxc(i) in: ('Z941' 'Z95812') then do; cardiac=1; progressive=1; end;
    if dxc(i) in: ('Z942') then do; pulresp=1; progressive=1; end;
    if dxc(i) in: ('Z944' 'Z9481' 'Z9482') then do; gastro=1; progressive=1; end;
    if dxc(i) in: ('Z9483') then do; endo=1; progressive=1; end;

 end;

  pmca_sum = pulresp+neuro+musculo+genito+immuno+gastro+derm+opthal+otol+endo+mh+hemato+genetic+metab+cardiac+renal+cranio;

  if pmca_sum>1 or malign=1 or progressive=1 then pmca=3;
  else if pmca_sum=1 then pmca=2;
  else pmca=1;
   
RUN;

PROC FREQ data=pcori; table pmca pmca_sum; RUN;

DATA pcori;
 set pcori;
 keep studyid pmca pmca_sum; 
RUN;

PROC EXPORT data=pcori
 outfile='C:/Users/sfreyeue/Downloads/PMCA_values.csv'
 dbms=csv
 replace;
 RUN;



 



