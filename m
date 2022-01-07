Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3889487336
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 07:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbiAGGzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 01:55:14 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:32002 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232115AbiAGGzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 01:55:13 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2072KCCY025955;
        Thu, 6 Jan 2022 22:55:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=aXEwZdZsVfFzwMv+JVouaucje3pzslbF0BLHmgeehAs=;
 b=EsuRYVdC0FuYftRPOi5NPApz2sSGdZ71lXzUscEba9w/Bc/PbTMS9p3qisl6Ds7UekN4
 wEEDviSHfRetXH83zhfy+MBq57GCTj3z0DKOEaJDTzjTfFfWV5Tze39kjhr4dGLRigsv
 NNT6HLrI3NExrAdSM3TKkp6DKCyxkLGDl7k25SKn5QnJgUVvwVklkP/3cw/FWVrCgZvE
 2dPYaOuOqwU9UrrNNv0GjeFv2JqqtGky7Uj6jB8dC7gf6hNJ8N+rN+9RioLc6Cm0RTsW
 u9tJAyRbt5jKBdzRKKyC2pJfpv8qiptvIIewkQM872zvAc6fDt+nlpQkvXz6BOrnx1xH 6g== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3de4vqt5wa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 06 Jan 2022 22:55:11 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 6 Jan
 2022 22:55:10 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 6 Jan 2022 22:55:10 -0800
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 012663F7068;
        Thu,  6 Jan 2022 22:55:07 -0800 (PST)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <hkelam@marvell.com>, <gakula@marvell.com>, <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net PATCH] octeontx2-af: Fix interrupt name strings
Date:   Fri, 7 Jan 2022 12:25:05 +0530
Message-ID: <1641538505-28367-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 0n96uP6GT5nLcbeZ2Nep8fXWcAoX4_y9
X-Proofpoint-ORIG-GUID: 0n96uP6GT5nLcbeZ2Nep8fXWcAoX4_y9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-07_02,2022-01-06_01,2021-12-02_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Fixed interrupt name string logic which currently results
in wrong memory location being accessed while dumping
/proc/interrupts.

Fixes: 4826090719d4 ("octeontx2-af: Enable CPT HW interrupts")
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c     | 5 ++---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c | 2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index 45357de..a73a801 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -172,14 +172,13 @@ static int cpt_10k_register_interrupts(struct rvu_block *block, int off)
 {
 	struct rvu *rvu = block->rvu;
 	int blkaddr = block->addr;
-	char irq_name[16];
 	int i, ret;
 
 	for (i = CPT_10K_AF_INT_VEC_FLT0; i < CPT_10K_AF_INT_VEC_RVU; i++) {
-		snprintf(irq_name, sizeof(irq_name), "CPTAF FLT%d", i);
+		sprintf(&rvu->irq_name[(off + i) * NAME_SIZE], "CPTAF FLT%d", i);
 		ret = rvu_cpt_do_register_interrupt(block, off + i,
 						    rvu_cpt_af_flt_intr_handler,
-						    irq_name);
+						    &rvu->irq_name[(off + i) * NAME_SIZE]);
 		if (ret)
 			goto err;
 		rvu_write64(rvu, blkaddr, CPT_AF_FLTX_INT_ENA_W1S(i), 0x1);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index 70bacd3..d0ab8f2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -41,7 +41,7 @@ static bool rvu_common_request_irq(struct rvu *rvu, int offset,
 	struct rvu_devlink *rvu_dl = rvu->rvu_dl;
 	int rc;
 
-	sprintf(&rvu->irq_name[offset * NAME_SIZE], name);
+	sprintf(&rvu->irq_name[offset * NAME_SIZE], "%s", name);
 	rc = request_irq(pci_irq_vector(rvu->pdev, offset), fn, 0,
 			 &rvu->irq_name[offset * NAME_SIZE], rvu_dl);
 	if (rc)
-- 
2.7.4

