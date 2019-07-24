Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E80A724B2
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 04:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727643AbfGXCdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 22:33:02 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:5960 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726130AbfGXCdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 22:33:01 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x6O2UBJO014221;
        Tue, 23 Jul 2019 19:32:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=l0l+AxcD/epRqZ2+VSZos8NSS06wgQclXMyKs6ciDYo=;
 b=yFQntE+n5AQFTyqzPojQH/tEIZau2U3VusCsP2BPx55VI7m6uxOIHHmiBU/ZqkixbPya
 W9cdfbcCyY3ModrQTwdlXEbdGwkZDXvl1E/BglCjQRGyc7nR8ACfK10H3zvO/2vB+6z3
 YgmYDqFQF6KGlaByP0IdsDpXuTVBSTeVEa1hQqbEzO1oLVsdVt2QERLoazOyNf5GTdM8
 r2UnfRCN92OePurhMhrKnIWFXr5Oxla4Bl2bgcEeLqUk2JB5Bn80TKvwijBCnDQMR1ty
 XBiOZPdhEtL2IhQNhPof+UJ9saVJxnpMeUmlqOIeBttv1CHNl/N72zDXq+56NFh06J0a 4g== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2tx61ra50p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 23 Jul 2019 19:32:59 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 23 Jul
 2019 19:32:58 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 23 Jul 2019 19:32:58 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 4232E3F703F;
        Tue, 23 Jul 2019 19:32:58 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x6O2WwcQ024832;
        Tue, 23 Jul 2019 19:32:58 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x6O2WvMB024831;
        Tue, 23 Jul 2019 19:32:57 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <manishc@marvell.com>,
        <mkalderon@marvell.com>
Subject: [PATCH net 1/1] bnx2x: Disable multi-cos feature.
Date:   Tue, 23 Jul 2019 19:32:41 -0700
Message-ID: <20190724023241.24794-1-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-07-24_01:2019-07-23,2019-07-24 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 3968d38917eb ("bnx2x: Fix Multi-Cos.") which enabled multi-cos
feature after prolonged time in driver added some regression causing
numerous issues (sudden reboots, tx timeout etc.) reported by customers.
We plan to backout this commit and submit proper fix once we have root
cause of issues reported with this feature enabled.

Fixes: 3968d38917eb ("bnx2x: Fix Multi-Cos.")
Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Manish Chopra <manishc@marvell.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index e2be5a6..e47ea92 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -1934,8 +1934,7 @@ u16 bnx2x_select_queue(struct net_device *dev, struct sk_buff *skb,
 	}
 
 	/* select a non-FCoE queue */
-	return netdev_pick_tx(dev, skb, NULL) %
-	       (BNX2X_NUM_ETH_QUEUES(bp) * bp->max_cos);
+	return netdev_pick_tx(dev, skb, NULL) % (BNX2X_NUM_ETH_QUEUES(bp));
 }
 
 void bnx2x_set_num_queues(struct bnx2x *bp)
-- 
1.8.3.1

