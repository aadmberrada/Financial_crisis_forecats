#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Dec 20 17:48:10 2020

@author: Abdoul_Aziz_Berrada
"""

import pandas as pd

#           Suppression des colonnes inutiles et nouvelle nommenclature de la colonne Close pour chaque E/se

#                   Small Caps
DDD=pd.read_csv("/Users/utilisateur/Documents/M1_EcoStat/Cours-M1/SAS1/Projet SAS1/Data/Small_Caps_600/DDD.csv")
DDD=DDD.drop(columns=["Adj Close","Volume","High","Open","Low"])
DDD=DDD.rename(columns={'Close': 'DDD.Close'})

GBCI=pd.read_csv("/Users/utilisateur/Documents/M1_EcoStat/Cours-M1/SAS1/Projet SAS1/Data/Small_Caps_600/GBCI.csv")
GBCI=GBCI.drop(columns=["Adj Close","Volume","High","Open","Low"])
GBCI=GBCI.rename(columns={'Close': 'GBCI.Close'})

GTY=pd.read_csv("/Users/utilisateur/Documents/M1_EcoStat/Cours-M1/SAS1/Projet SAS1/Data/Small_Caps_600/GTY.csv")
GTY=GTY.drop(columns=["Adj Close","Volume","High","Open","Low"])
GTY=GTY.rename(columns={'Close': 'GTY.Close'})

GCO=pd.read_csv("/Users/utilisateur/Documents/M1_EcoStat/Cours-M1/SAS1/Projet SAS1/Data/Small_Caps_600/GCO.csv")
GCO=GCO.drop(columns=["Adj Close","Volume","High","Open","Low"])
GCO=GCO.rename(columns={'Close': 'GCO.Close'})

GIII=pd.read_csv("/Users/utilisateur/Documents/M1_EcoStat/Cours-M1/SAS1/Projet SAS1/Data/Small_Caps_600/GIII.csv")
GIII=GIII.drop(columns=["Adj Close","Volume","High","Open","Low"])
GIII=GIII.rename(columns={'Close': 'GIII.Close'})

FTRCQ=pd.read_csv("/Users/utilisateur/Documents/M1_EcoStat/Cours-M1/SAS1/Projet SAS1/Data/Small_Caps_600/FTRCQ.csv")
FTRCQ=FTRCQ.drop(columns=["Adj Close","Volume","High","Open","Low"])
FTRCQ=FTRCQ.rename(columns={'Close': 'FTRCQ.Close'})

FSS=pd.read_csv("/Users/utilisateur/Documents/M1_EcoStat/Cours-M1/SAS1/Projet SAS1/Data/Small_Caps_600/FSS.csv")
FSS=FSS.drop(columns=["Adj Close","Volume","High","Open","Low"])
FSS=FSS.rename(columns={'Close': 'FSS.Close'})

CMTL=pd.read_csv("/Users/utilisateur/Documents/M1_EcoStat/Cours-M1/SAS1/Projet SAS1/Data/Small_Caps_600/CMTL.csv")
CMTL=CMTL.drop(columns=["Adj Close","Volume","High","Open","Low"])
CMTL=CMTL.rename(columns={'Close': 'CMTL.Close'})

CNMD=pd.read_csv("/Users/utilisateur/Documents/M1_EcoStat/Cours-M1/SAS1/Projet SAS1/Data/Small_Caps_600/CNMD.csv")
CNMD=CNMD.drop(columns=["Adj Close","Volume","High","Open","Low"])
CNMD=CNMD.rename(columns={'Close': 'CNMD.Close'})


CTB=pd.read_csv("/Users/utilisateur/Documents/M1_EcoStat/Cours-M1/SAS1/Projet SAS1/Data/Small_Caps_600/CTB.csv")
CTB=CTB.drop(columns=["Adj Close","Volume","High","Open","Low"])
CTB=CTB.rename(columns={'Close': 'CTB.Close'})

x1=DDD.merge(GBCI,how="right",on="Date",left_index=False)
x2=x1.merge(GTY,how="right",on="Date",left_index=False)
x3=x2.merge(GCO,how="right",on="Date",left_index=False)
x4=x3.merge(GIII,how="right",on="Date",left_index=False)
x5=x4.merge(FTRCQ,how="right",on="Date",left_index=False)
x6=x5.merge(FSS,how="right",on="Date",left_index=False)
x7=x6.merge(CMTL,how="right",on="Date",left_index=False)
x8=x7.merge(CNMD,how="right",on="Date",left_index=False)
small_caps=x8.merge(CTB,how="right",on="Date",left_index=False)
#                   Mid Caps
NJR=pd.read_csv("/Users/utilisateur/Documents/M1_EcoStat/Cours-M1/SAS1/Projet SAS1/Data/Mid_Caps_400/NJR.csv")
NJR=NJR.drop(columns=["Adj Close","Volume","High","Open","Low"])
NJR=NJR.rename(columns={'Close': 'NJR.Close'})

NDSN=pd.read_csv("/Users/utilisateur/Documents/M1_EcoStat/Cours-M1/SAS1/Projet SAS1/Data/Mid_Caps_400/NDSN.csv")
NDSN=NDSN.drop(columns=["Adj Close","Volume","High","Open","Low"])
NDSN=NDSN.rename(columns={'Close': 'NDSN.Close'})

OII=pd.read_csv("/Users/utilisateur/Documents/M1_EcoStat/Cours-M1/SAS1/Projet SAS1/Data/Mid_Caps_400/OII.csv")
OII=OII.drop(columns=["Adj Close","Volume","High","Open","Low"])
OII=OII.rename(columns={'Close': 'OII.Close'})

NVR=pd.read_csv("/Users/utilisateur/Documents/M1_EcoStat/Cours-M1/SAS1/Projet SAS1/Data/Mid_Caps_400/NVR.csv")
NVR=NVR.drop(columns=["Adj Close","Volume","High","Open","Low"])
NVR=NVR.rename(columns={'Close': "NVR.Close"})

NEU=pd.read_csv("/Users/utilisateur/Documents/M1_EcoStat/Cours-M1/SAS1/Projet SAS1/Data/Mid_Caps_400/NEU.csv")
NEU=NEU.drop(columns=["Adj Close","Volume","High","Open","Low"])
NEU=NEU.rename(columns={'Close': "NEU.Close"})

NYT=pd.read_csv("/Users/utilisateur/Documents/M1_EcoStat/Cours-M1/SAS1/Projet SAS1/Data/Mid_Caps_400/NYT.csv")
NYT=NYT.drop(columns=["Adj Close","Volume","High","Open","Low"])
NYT=NYT.rename(columns={'Close': "NYT.Close"})

DCI=pd.read_csv("/Users/utilisateur/Documents/M1_EcoStat/Cours-M1/SAS1/Projet SAS1/Data/Mid_Caps_400/DCI.csv")
DCI=DCI.drop(columns=["Adj Close","Volume","High","Open","Low"])
DCI=DCI.rename(columns={'Close': "DCI.Close"})

DDS=pd.read_csv("/Users/utilisateur/Documents/M1_EcoStat/Cours-M1/SAS1/Projet SAS1/Data/Mid_Caps_400/DDS.csv")
DDS=DDS.drop(columns=["Adj Close","Volume","High","Open","Low"])
DDS=DDS.rename(columns={'Close': "DDS.Close"})

DLX=pd.read_csv("/Users/utilisateur/Documents/M1_EcoStat/Cours-M1/SAS1/Projet SAS1/Data/Mid_Caps_400/DLX.csv")
DLX=DLX.drop(columns=["Adj Close","Volume","High","Open","Low"])
DLX=DLX.rename(columns={'Close': "DLX.Close"})

MDU=pd.read_csv("/Users/utilisateur/Documents/M1_EcoStat/Cours-M1/SAS1/Projet SAS1/Data/Mid_Caps_400/MDU.csv")
MDU=MDU.drop(columns=["Adj Close","Volume","High","Open","Low"])
MDU=MDU.rename(columns={'Close': "MDU.Close"})

x9=NJR.merge(NDSN,how="right",on="Date",left_index=False)
x10=x9.merge(OII,how="right",on="Date",left_index=False)
x11=x10.merge(NVR,how="right",on="Date",left_index=False)
x12=x11.merge(NEU,how="right",on="Date",left_index=False)
x13=x12.merge(NYT,how="right",on="Date",left_index=False)
x14=x13.merge(DCI,how="right",on="Date",left_index=False)
x15=x14.merge(DDS,how="right",on="Date",left_index=False)
x16=x15.merge(DLX,how="right",on="Date",left_index=False)
mid_caps=x16.merge(MDU,how="right",on="Date",left_index=False)

#                   Large Caps
AAPL=pd.read_csv("/Users/utilisateur/Documents/M1_EcoStat/Cours-M1/SAS1/Projet SAS1/Data/Large_Caps_500/AAPL.csv")
AAPL=AAPL.drop(columns=["Adj Close","Volume","High","Open","Low"])
AAPL=AAPL.rename(columns={'Close': "AAPL.Close"})

ADBE=pd.read_csv("/Users/utilisateur/Documents/M1_EcoStat/Cours-M1/SAS1/Projet SAS1/Data/Large_Caps_500/ADBE.csv")
ADBE=ADBE.drop(columns=["Adj Close","Volume","High","Open","Low"])
ADBE=ADBE.rename(columns={'Close': "ADBE.Close"})

DIS=pd.read_csv("/Users/utilisateur/Documents/M1_EcoStat/Cours-M1/SAS1/Projet SAS1/Data/Large_Caps_500/DIS.csv")
DIS=DIS.drop(columns=["Adj Close","Volume","High","Open","Low"])
DIS=DIS.rename(columns={'Close': "DIS.Close"})

INTL=pd.read_csv("/Users/utilisateur/Documents/M1_EcoStat/Cours-M1/SAS1/Projet SAS1/Data/Large_Caps_500/INTC.csv")
INTL=INTL.drop(columns=["Adj Close","Volume","High","Open","Low"])
INTL=INTL.rename(columns={'Close': "INTL.Close"})

JNJ=pd.read_csv("/Users/utilisateur/Documents/M1_EcoStat/Cours-M1/SAS1/Projet SAS1/Data/Large_Caps_500/JNJ.csv")
JNJ=JNJ.drop(columns=["Adj Close","Volume","High","Open","Low"])
JNJ=JNJ.rename(columns={'Close': "JNJ.Close"})

JPM=pd.read_csv("/Users/utilisateur/Documents/M1_EcoStat/Cours-M1/SAS1/Projet SAS1/Data/Large_Caps_500/JPM.csv")
JPM=JPM.drop(columns=["Adj Close","Volume","High","Open","Low"])
JPM=JPM.rename(columns={'Close': "JPM.Close"})

MSFT=pd.read_csv("/Users/utilisateur/Documents/M1_EcoStat/Cours-M1/SAS1/Projet SAS1/Data/Large_Caps_500/MSFT.csv")
MSFT=MSFT.drop(columns=["Adj Close","Volume","High","Open","Low"])
MSFT=MSFT.rename(columns={'Close': "MSFT.Close"})

PG=pd.read_csv("/Users/utilisateur/Documents/M1_EcoStat/Cours-M1/SAS1/Projet SAS1/Data/Large_Caps_500/PG.csv")
PG=PG.drop(columns=["Adj Close","Volume","High","Open","Low"])
PG=PG.rename(columns={'Close': "PG.Close"})

UNH=pd.read_csv("/Users/utilisateur/Documents/M1_EcoStat/Cours-M1/SAS1/Projet SAS1/Data/Large_Caps_500/UNH.csv")
UNH=UNH.drop(columns=["Adj Close","Volume","High","Open","Low"])
UNH=UNH.rename(columns={'Close': "UNH.Close"})

VZ=pd.read_csv("/Users/utilisateur/Documents/M1_EcoStat/Cours-M1/SAS1/Projet SAS1/Data/Large_Caps_500/VZ.csv")
VZ=VZ.drop(columns=["Adj Close","Volume","High","Open","Low"])
VZ=VZ.rename(columns={'Close': "VZ.Close"})

x17=AAPL.merge(ADBE,how="right",on="Date",left_index=False)
x18=x17.merge(DIS,how="right",on="Date",left_index=False)
x19=x18.merge(INTL,how="right",on="Date",left_index=False)
x20=x19.merge(JNJ,how="right",on="Date",left_index=False)
x21=x20.merge(JPM,how="right",on="Date",left_index=False)
x22=x21.merge(MSFT,how="right",on="Date",left_index=False)
x23=x22.merge(PG,how="right",on="Date",left_index=False)
x24=x23.merge(UNH,how="right",on="Date",left_index=False)
large_caps=x24.merge(VZ,how="right",on="Date",left_index=False)

#                   Fusions


x1=DDD.merge(GBCI,how="right",on="Date",left_index=False)
x2=x1.merge(GTY,how="right",on="Date",left_index=False)
x3=x2.merge(GCO,how="right",on="Date",left_index=False)
x4=x3.merge(GIII,how="right",on="Date",left_index=False)
x5=x4.merge(FTRCQ,how="right",on="Date",left_index=False)
x6=x5.merge(FSS,how="right",on="Date",left_index=False)
x7=x6.merge(CMTL,how="right",on="Date",left_index=False)
x8=x7.merge(CNMD,how="right",on="Date",left_index=False)
small_caps=x8.merge(CTB,how="right",on="Date",left_index=False)

x9=NJR.merge(NDSN,how="right",on="Date",left_index=False)
x10=x9.merge(OII,how="right",on="Date",left_index=False)
x11=x10.merge(NVR,how="right",on="Date",left_index=False)
x12=x11.merge(NEU,how="right",on="Date",left_index=False)
x13=x12.merge(NYT,how="right",on="Date",left_index=False)
x14=x13.merge(DCI,how="right",on="Date",left_index=False)
x15=x14.merge(DDS,how="right",on="Date",left_index=False)
x16=x15.merge(DLX,how="right",on="Date",left_index=False)
mid_caps=x16.merge(MDU,how="right",on="Date",left_index=False)

x17=AAPL.merge(ADBE,how="right",on="Date",left_index=False)
x18=x17.merge(DIS,how="right",on="Date",left_index=False)
x19=x18.merge(INTL,how="right",on="Date",left_index=False)
x20=x19.merge(JNJ,how="right",on="Date",left_index=False)
x21=x20.merge(JPM,how="right",on="Date",left_index=False)
x22=x21.merge(MSFT,how="right",on="Date",left_index=False)
x23=x22.merge(PG,how="right",on="Date",left_index=False)
x24=x23.merge(UNH,how="right",on="Date",left_index=False)
large_caps=x24.merge(VZ,how="right",on="Date",left_index=False)

small_mid=small_caps.merge(mid_caps,how="right",on="Date",left_index=False)

s_and_p_v1= small_mid.merge(large_caps,how="right",on="Date",left_index=False)
s_and_p=s_and_p_v1.dropna()

#                   Export
s_and_p_v1.to_csv("/Users/utilisateur/Documents/M1_EcoStat/Cours-M1/SAS1/Projet SAS1/Data/S&P_v1.csv", index = False)

s_and_p.to_csv("/Users/utilisateur/Documents/M1_EcoStat/Cours-M1/SAS1/Projet SAS1/Data/S&P.csv", index = False)


