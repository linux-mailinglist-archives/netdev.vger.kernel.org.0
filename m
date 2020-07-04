Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F38E221442A
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 06:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgGDEnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 00:43:55 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:20260 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725710AbgGDEny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 00:43:54 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0644agVm009138;
        Fri, 3 Jul 2020 21:43:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=yBljFtK1Tdc1ja60PqMSMjPsP9NHTm2Ms7C2Ptfqonc=;
 b=oqx2YVIAlFDMUeX/VTJf5eLzdj5C7c/vt5kcZODdyQM+QfKMujr5uGstfuSKDJGB8NFj
 nE+8lIqW66vP36ZdO08KyyLjq/tyPDGNBHmEqrRTuSis7h2g3Me7+1tWpgvLa4Pcnt9y
 i5oZY0s0tPmAOFWRgsVDjllAwzHk5vUx9D+79I4qp4sC39w8avpp8LCpa6DKXJ7IngQt
 BzY0Hjlv0aztS4X4FybzDd/wI9D8xCk6LrnPVO27TrRrAqswcGMzdj83DWpXQHEf2x77
 Ja5j5wQnEN0lm8KHRFRlvBwkDz0OxcoGSAlkFC3yLXgvq4uI41VIu0JSOvCuuUmL+pSZ aw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 321m92xay7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 21:43:53 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 3 Jul
 2020 21:43:52 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 3 Jul
 2020 21:43:52 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 3 Jul 2020 21:43:52 -0700
Received: from sudarshana-rh72.punelab.qlogic.com. (unknown [10.30.45.63])
        by maili.marvell.com (Postfix) with ESMTP id B840E3F703F;
        Fri,  3 Jul 2020 21:43:50 -0700 (PDT)
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>, <mkalderon@marvell.com>
Subject: [PATCH net-next v3 1/3] bnx2x: Add Idlechk related register definitions.
Date:   Sat, 4 Jul 2020 10:13:42 +0530
Message-ID: <1593837824-26657-2-git-send-email-skalluru@marvell.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593837824-26657-1-git-send-email-skalluru@marvell.com>
References: <1593837824-26657-1-git-send-email-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-04_03:2020-07-02,2020-07-04 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch adds register definitions required for Idlechk implementation.

Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h | 78 ++++++++++++++++++++++++-
 1 file changed, 76 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h
index a43dea2..bfc0e45 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h
@@ -7639,6 +7639,82 @@
 	(0x80 | ((_type)&0xf << 3) | ((CDU_CRC8(_cid, _region, _type)) & 0x7))
 #define CDU_RSRVD_INVALIDATE_CONTEXT_VALUE(_val) ((_val) & ~0x80)
 
+/* IdleChk registers */
+#define PXP_REG_HST_VF_DISABLED_ERROR_VALID			 0x1030bc
+#define PXP_REG_HST_VF_DISABLED_ERROR_DATA			 0x1030b8
+#define PXP_REG_HST_PER_VIOLATION_VALID				 0x1030e0
+#define PXP_REG_HST_INCORRECT_ACCESS_VALID			 0x1030cc
+#define PXP2_REG_RD_CPL_ERR_DETAILS				 0x120778
+#define PXP2_REG_RD_CPL_ERR_DETAILS2				 0x12077c
+#define PXP2_REG_RQ_GARB					 0x120748
+#define PBF_REG_DISABLE_NEW_TASK_PROC_Q0			 0x15c1bc
+#define PBF_REG_DISABLE_NEW_TASK_PROC_Q1			 0x15c1c0
+#define PBF_REG_DISABLE_NEW_TASK_PROC_Q2			 0x15c1c4
+#define PBF_REG_DISABLE_NEW_TASK_PROC_Q3			 0x15c1c8
+#define PBF_REG_DISABLE_NEW_TASK_PROC_Q4			 0x15c1cc
+#define PBF_REG_DISABLE_NEW_TASK_PROC_Q5			 0x15c1d0
+#define PBF_REG_CREDIT_Q2					 0x140344
+#define PBF_REG_CREDIT_Q3					 0x140348
+#define PBF_REG_CREDIT_Q4					 0x14034c
+#define PBF_REG_CREDIT_Q5					 0x140350
+#define PBF_REG_INIT_CRD_Q2					 0x15c238
+#define PBF_REG_INIT_CRD_Q3					 0x15c23c
+#define PBF_REG_INIT_CRD_Q4					 0x15c240
+#define PBF_REG_INIT_CRD_Q5					 0x15c244
+#define PBF_REG_TASK_CNT_Q0					 0x140374
+#define PBF_REG_TASK_CNT_Q1					 0x140378
+#define PBF_REG_TASK_CNT_Q2					 0x14037c
+#define PBF_REG_TASK_CNT_Q3					 0x140380
+#define PBF_REG_TASK_CNT_Q4					 0x140384
+#define PBF_REG_TASK_CNT_Q5					 0x140388
+#define PBF_REG_TASK_CNT_LB_Q					 0x140370
+#define QM_REG_BYTECRD0						 0x16e6fc
+#define QM_REG_BYTECRD1						 0x16e700
+#define QM_REG_BYTECRD2						 0x16e704
+#define QM_REG_BYTECRD3						 0x16e7ac
+#define QM_REG_BYTECRD4						 0x16e7b0
+#define QM_REG_BYTECRD5						 0x16e7b4
+#define QM_REG_BYTECRD6						 0x16e7b8
+#define QM_REG_BYTECRDCMDQ_0					 0x16e6e8
+#define QM_REG_BYTECRDERRREG					 0x16e708
+#define MISC_REG_GRC_TIMEOUT_ATTN_FULL_FID			 0xa714
+#define QM_REG_VOQCREDIT_2					 0x1682d8
+#define QM_REG_VOQCREDIT_3					 0x1682dc
+#define QM_REG_VOQCREDIT_5					 0x1682e4
+#define QM_REG_VOQCREDIT_6					 0x1682e8
+#define QM_REG_VOQINITCREDIT_3					 0x16806c
+#define QM_REG_VOQINITCREDIT_6					 0x168078
+#define QM_REG_FWVOQ0TOHWVOQ					 0x16e7bc
+#define QM_REG_FWVOQ1TOHWVOQ					 0x16e7c0
+#define QM_REG_FWVOQ2TOHWVOQ					 0x16e7c4
+#define QM_REG_FWVOQ3TOHWVOQ					 0x16e7c8
+#define QM_REG_FWVOQ4TOHWVOQ					 0x16e7cc
+#define QM_REG_FWVOQ5TOHWVOQ					 0x16e7d0
+#define QM_REG_FWVOQ6TOHWVOQ					 0x16e7d4
+#define QM_REG_FWVOQ7TOHWVOQ					 0x16e7d8
+#define NIG_REG_INGRESS_EOP_PORT0_EMPTY				 0x104ec
+#define NIG_REG_INGRESS_EOP_PORT1_EMPTY				 0x104f8
+#define NIG_REG_INGRESS_RMP0_DSCR_EMPTY				 0x10530
+#define NIG_REG_INGRESS_RMP1_DSCR_EMPTY				 0x10538
+#define NIG_REG_INGRESS_LB_PBF_DELAY_EMPTY			 0x10508
+#define NIG_REG_EGRESS_MNG0_FIFO_EMPTY				 0x10460
+#define NIG_REG_EGRESS_MNG1_FIFO_EMPTY				 0x10474
+#define NIG_REG_EGRESS_DEBUG_FIFO_EMPTY				 0x10418
+#define NIG_REG_EGRESS_DELAY0_EMPTY				 0x10420
+#define NIG_REG_EGRESS_DELAY1_EMPTY				 0x10428
+#define NIG_REG_LLH0_FIFO_EMPTY					 0x10548
+#define NIG_REG_LLH1_FIFO_EMPTY					 0x10558
+#define NIG_REG_P0_TX_MNG_HOST_FIFO_EMPTY			 0x182a8
+#define NIG_REG_P0_TLLH_FIFO_EMPTY				 0x18308
+#define NIG_REG_P0_HBUF_DSCR_EMPTY				 0x18318
+#define NIG_REG_P1_HBUF_DSCR_EMPTY				 0x18348
+#define NIG_REG_P0_RX_MACFIFO_EMPTY				 0x18570
+#define NIG_REG_P0_TX_MACFIFO_EMPTY				 0x18578
+#define NIG_REG_EGRESS_DELAY2_EMPTY				 0x1862c
+#define NIG_REG_EGRESS_DELAY3_EMPTY				 0x18630
+#define NIG_REG_EGRESS_DELAY4_EMPTY				 0x18634
+#define NIG_REG_EGRESS_DELAY5_EMPTY				 0x18638
+
 /******************************************************************************
  * Description:
  *	   Calculates crc 8 on a word value: polynomial 0-1-2-8
@@ -7697,6 +7773,4 @@ static inline u8 calc_crc8(u32 data, u8 crc)
 
 	return crc_res;
 }
-
-
 #endif /* BNX2X_REG_H */
-- 
1.8.3.1

