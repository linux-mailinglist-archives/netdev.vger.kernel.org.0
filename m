Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39F1F33F05B
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 13:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbhCQMa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 08:30:27 -0400
Received: from m12-18.163.com ([220.181.12.18]:38583 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhCQMaK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 08:30:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=TiHdS
        zAyVBOUsnYE4b7ebCRqdXM/3rAuYaKbUU1aazk=; b=gjzR7y5H1zrAxVUbOaZb6
        Gso7STroQLoSRdpCbbAP4dbHKQAB3CLGs4SiFlOSeld/SCJN72M6kp3P+RNFCLQn
        3g4ceOrG5WZuaBjo4PGqabl5ZLbQEczkxJes/ZsH8GQHfeh6gx/tM+piVEbzHPxs
        U/hO06Q6AohbIxknoVYXhs=
Received: from COOL-20201222LC.ccdomain.com (unknown [218.94.48.178])
        by smtp14 (Coremail) with SMTP id EsCowADHTIE99lFg2qQrZQ--.46900S2;
        Wed, 17 Mar 2021 20:29:53 +0800 (CST)
From:   dingsenjie@163.com
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dingsenjie <dingsenjie@yulong.com>
Subject: [PATCH v2] ethernet/broadcom:remove unneeded variable: "ret"
Date:   Wed, 17 Mar 2021 20:29:33 +0800
Message-Id: <20210317122933.68980-1-dingsenjie@163.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EsCowADHTIE99lFg2qQrZQ--.46900S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrur43XF4xKw1rur4xAF1UZFb_yoWkXwbEgr
        18Xw1fKr4UJr9ayrWjyrsxu3sagayqv34v9F129rW3WrsrZw18AayqkF9xJw1rWF48JFnx
        Cry3KayIywn0kjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8imRUUUUUU==
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 5glqw25hqmxvi6rwjhhfrp/1tbiHhtRyFSItLX6jwABs1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: dingsenjie <dingsenjie@yulong.com>

remove unneeded variable: "ret".

Signed-off-by: dingsenjie <dingsenjie@yulong.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 28069b2..f30193f 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -1395,7 +1395,6 @@ int bnx2x_send_final_clnup(struct bnx2x *bp, u8 clnup_func, u32 poll_cnt)
 	u32 op_gen_command = 0;
 	u32 comp_addr = BAR_CSTRORM_INTMEM +
 			CSTORM_FINAL_CLEANUP_COMPLETE_OFFSET(clnup_func);
-	int ret = 0;
 
 	if (REG_RD(bp, comp_addr)) {
 		BNX2X_ERR("Cleanup complete was not 0 before sending\n");
@@ -1420,7 +1419,7 @@ int bnx2x_send_final_clnup(struct bnx2x *bp, u8 clnup_func, u32 poll_cnt)
 	/* Zero completion for next FLR */
 	REG_WR(bp, comp_addr, 0);
 
-	return ret;
+	return 0;
 }
 
 u8 bnx2x_is_pcie_pending(struct pci_dev *dev)
-- 
1.9.1


