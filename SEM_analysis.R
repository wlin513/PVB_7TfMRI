rm(list=ls())

library('lavaan')
base_dir<-'H:/2023_Peking_DRL'
subjects<-read.table(file=file.path(base_dir,"/code/feat_batch/subject_list_n49"))
blocknames<-c("BHBL1","BHBL2","BHNL","NHBL","BHNH1","BHNH2","BLNL1","BLNL2")
biHb=c()
NAcc=c()
VTA=c()
mPFC=c()
for (is in 1:length(subjects)){
  print(subjects[is])
  for (iblk in 1:length(blocknames)){
  h<-read.delim(paste(base_dir,"/PPI/bilateral_Hb_15/",subjects[is],"/time_courses/pre_1/",blocknames[iblk],'.txt',sep=""),header = FALSE)
  h=h-mean(h$V1)
  biHb<-rbind(biHb,h)
  
  n<-read.delim(paste(base_dir,"/PPI/NAcc_resampled/",subjects[is],"/time_courses/pre_1/",blocknames[iblk],'.txt',sep=""),header = FALSE)
  n=n-mean(n$V1)
  NAcc<-rbind(NAcc,n)
  
  v<-read.delim(paste(base_dir,"/PPI/atlas-vta_hem-bi_proba-27_resampled_thr01/",subjects[is],"/time_courses/pre_1/",blocknames[iblk],'.txt',sep=""),header = FALSE)
  v=v-mean(v$V1)
  VTA<-rbind(VTA,v)
  
  m<-read.delim(paste(base_dir,"/PPI/binConjunc_PvNxDECxRECxMONxPRI_vmpfc_resampled/",subjects[is],"/time_courses/pre_1/",blocknames[iblk],'.txt',sep=""),header = FALSE)
  m=m-mean(m$V1)
  mPFC<-rbind(mPFC,m)
  }
}

BOLDdata=data.frame(NAcc,biHb,VTA,mPFC)
names(BOLDdata)=c('NAcc','biHb','VTA','mPFC')

#Hb as the origination models
model_Hb_1 <- '
    VTA ~ biHb
    NAcc ~ VTA
    mPFC ~ NAcc
'
fit_Hb_1 <- sem(model_Hb_1, data=BOLDdata)

model_Hb_2 <- '
    VTA ~ biHb
    mPFC ~ VTA
    NAcc ~ mPFC
'
fit_Hb_2 <- sem(model_Hb_2, data=BOLDdata)

model_Hb_3 <- '
    NAcc ~ biHb
    VTA ~ NAcc
    mPFC ~ VTA
'
fit_Hb_3 <- sem(model_Hb_3, data=BOLDdata)

model_Hb_4 <- '
    NAcc ~ biHb
    mPFC ~ NAcc
    VTA ~ mPFC
'
fit_Hb_4 <- sem(model_Hb_4, data=BOLDdata)

model_Hb_5 <- '
    mPFC ~ biHb
    VTA ~ mPFC
    NAcc ~ VTA
'
fit_Hb_5 <- sem(model_Hb_5, data=BOLDdata)

model_Hb_6 <- '
    mPFC ~ biHb
    NAcc ~ mPFC
    VTA ~ NAcc
'
fit_Hb_6 <- sem(model_Hb_6, data=BOLDdata)


#VTA as the origination models
model_VTA_1 <- '
    biHb ~ VTA
    NAcc ~ biHb
    mPFC ~ NAcc
'
fit_VTA_1 <- sem(model_VTA_1, data=BOLDdata)

model_VTA_2 <- '
    biHb ~ VTA
    mPFC ~ biHb
    NAcc ~ mPFC
'
fit_VTA_2 <- sem(model_VTA_2, data=BOLDdata)

model_VTA_3 <- '
    NAcc ~ VTA
    biHb ~ NAcc
    mPFC ~ biHb
'
fit_VTA_3 <- sem(model_VTA_3, data=BOLDdata)

model_VTA_4 <- '
    NAcc ~ VTA
    mPFC ~ NAcc
    biHb ~ mPFC
'
fit_VTA_4 <- sem(model_VTA_4, data=BOLDdata)

model_VTA_5 <- '
    mPFC ~ VTA
    biHb ~ mPFC
    NAcc ~ biHb
'
fit_VTA_5 <- sem(model_VTA_5, data=BOLDdata)

model_VTA_6 <- '
    mPFC ~ VTA
    NAcc ~ mPFC
    biHb ~ NAcc
'
fit_VTA_6 <- sem(model_VTA_6, data=BOLDdata)


#NAcc as the origination models
model_NAcc_1 <- '
    VTA ~ NAcc
    biHb ~ VTA
    mPFC ~ biHb
'
fit_NAcc_1 <- sem(model_NAcc_1, data=BOLDdata)

model_NAcc_2 <- '
    VTA ~ NAcc
    mPFC ~ VTA
    biHb ~ mPFC
'
fit_NAcc_2 <- sem(model_NAcc_2, data=BOLDdata)

model_NAcc_3 <- '
    biHb ~ NAcc
    VTA ~ biHb
    mPFC ~ VTA
'
fit_NAcc_3 <- sem(model_NAcc_3, data=BOLDdata)

model_NAcc_4 <- '
    biHb ~ NAcc
    mPFC ~ biHb
    VTA ~ mPFC
'
fit_NAcc_4 <- sem(model_NAcc_4, data=BOLDdata)

model_NAcc_5 <- '
    mPFC ~ NAcc
    VTA ~ mPFC
    biHb ~ VTA
'
fit_NAcc_5 <- sem(model_NAcc_5, data=BOLDdata)

model_NAcc_6 <- '
    mPFC ~ NAcc
    biHb ~ mPFC
    VTA ~ biHb
'
fit_NAcc_6 <- sem(model_NAcc_6, data=BOLDdata)


#mPFC as the origination models
model_mPFC_1 <- '
    VTA ~ mPFC
    NAcc ~ VTA
    biHb ~ NAcc
'
fit_mPFC_1 <- sem(model_mPFC_1, data=BOLDdata)

model_mPFC_2 <- '
    VTA ~ mPFC
    biHb ~ VTA
    NAcc ~ biHb
'
fit_mPFC_2 <- sem(model_mPFC_2, data=BOLDdata)

model_mPFC_3 <- '
    NAcc ~ mPFC
    VTA ~ NAcc
    biHb ~ VTA
'
fit_mPFC_3 <- sem(model_mPFC_3, data=BOLDdata)

model_mPFC_4 <- '
    NAcc ~ mPFC
    biHb ~ NAcc
    VTA ~ biHb
'
fit_mPFC_4 <- sem(model_mPFC_4, data=BOLDdata)

model_mPFC_5 <- '
    biHb ~ mPFC
    VTA ~ biHb
    NAcc ~ VTA
'
fit_mPFC_5 <- sem(model_mPFC_5, data=BOLDdata)

model_mPFC_6 <- '
    biHb ~ mPFC
    NAcc ~ biHb
    VTA ~ NAcc
'
fit_mPFC_6 <- sem(model_mPFC_6, data=BOLDdata)


results<-anova(fit_Hb_1,fit_Hb_2,fit_Hb_3,fit_Hb_4,fit_Hb_5,fit_Hb_6,fit_VTA_1,fit_VTA_2,fit_VTA_3,fit_VTA_4,fit_VTA_5,fit_VTA_6,fit_NAcc_1,fit_NAcc_2,fit_NAcc_3,fit_NAcc_4,fit_NAcc_5,fit_NAcc_6,fit_mPFC_1,fit_mPFC_2,fit_mPFC_3,fit_mPFC_4,fit_mPFC_5,fit_mPFC_6)

sink(paste(base_dir,'/code/matlab/R_SEM_results.mat',sep=""))

barplot(results$AIC-min(results$AIC))