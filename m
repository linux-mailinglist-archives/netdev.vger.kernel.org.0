Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D52120B874
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 20:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbgFZSks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 14:40:48 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:30318 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725275AbgFZSkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 14:40:47 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QIMAaP015714;
        Fri, 26 Jun 2020 11:40:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=rF1UyQA0fHAHEu++Hd6xXi8kZZ7OZ5/Sk9nP0svYc5g=;
 b=eC7DA/F5MDMCoiVLJV7XWoDnbBmDAELXz5Zo1BmnJAXIA9TiB+jFgn4JtyDl6/Xm1ITI
 ainz0XT4PTjpOicAQpV9e5YjymPnxGiTz794ozD07sQSvA1w4Ser+btOoauptxja4Fff
 Sdb104mv6Y8YAMy3sFIl75zzEMruygRQJE1WM+YHICvkLIikgnLqEnQvGV3A3X15CNO8
 M8eW1W8osVRoxy8nb4QGcl4r/fZUeIYO1CqXyG2nutPJEqKWBtFTmGHMTcbiKpZI1rGF
 B8ka6Ppq9GOJmCi28RwT/Iz0c7oBEUvvJe5KliirgD9EbKi01OF2fLLKekGo7fY7ERIW AA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 31uuqh5u7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 26 Jun 2020 11:40:46 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 26 Jun
 2020 11:40:45 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 26 Jun
 2020 11:40:45 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 26 Jun 2020 11:40:45 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 651C63F7040;
        Fri, 26 Jun 2020 11:40:43 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 1/8] net: atlantic: MACSec offload statistics checkpatch fix
Date:   Fri, 26 Jun 2020 21:40:31 +0300
Message-ID: <20200626184038.857-2-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200626184038.857-1-irusskikh@marvell.com>
References: <20200626184038.857-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_10:2020-06-26,2020-06-26 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

This patch fixes a checkpatch warning.

Fixes: aec0f1aac58e ("net: atlantic: MACSec offload statistics implementation")

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index e53ba7bfaf61..f352b206b5cf 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -124,21 +124,21 @@ static const char aq_macsec_stat_names[][ETH_GSTRING_LEN] = {
 	"MACSec OutUnctrlHitDropRedir",
 };
 
-static const char *aq_macsec_txsc_stat_names[] = {
+static const char * const aq_macsec_txsc_stat_names[] = {
 	"MACSecTXSC%d ProtectedPkts",
 	"MACSecTXSC%d EncryptedPkts",
 	"MACSecTXSC%d ProtectedOctets",
 	"MACSecTXSC%d EncryptedOctets",
 };
 
-static const char *aq_macsec_txsa_stat_names[] = {
+static const char * const aq_macsec_txsa_stat_names[] = {
 	"MACSecTXSC%dSA%d HitDropRedirect",
 	"MACSecTXSC%dSA%d Protected2Pkts",
 	"MACSecTXSC%dSA%d ProtectedPkts",
 	"MACSecTXSC%dSA%d EncryptedPkts",
 };
 
-static const char *aq_macsec_rxsa_stat_names[] = {
+static const char * const aq_macsec_rxsa_stat_names[] = {
 	"MACSecRXSC%dSA%d UntaggedHitPkts",
 	"MACSecRXSC%dSA%d CtrlHitDrpRedir",
 	"MACSecRXSC%dSA%d NotUsingSa",
-- 
2.25.1

