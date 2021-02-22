Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5B732117B
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 08:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbhBVHka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 02:40:30 -0500
Received: from m12-16.163.com ([220.181.12.16]:33674 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230041AbhBVHkZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 02:40:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=TiHdS
        zAyVBOUsnYE4b7ebCRqdXM/3rAuYaKbUU1aazk=; b=KYt6aRGIPbSziaJp2aGhF
        3IHAF1UDRpRisbiax/Hin7lotbBt6YjPY26zG2T5Sd5SYcRwtEIlGdhCVP6nkg80
        NcerOba98uRH8Drdv+lAw5G8RbAK4nsw/gTprrbHF6m5GBZTrmyR1S3/OfufKMuf
        /Y2gi7tcq5oqKcl7N5FrkA=
Received: from COOL-20201222LC.ccdomain.com (unknown [218.94.48.178])
        by smtp12 (Coremail) with SMTP id EMCowADnTUfnSDNg49yPdA--.7050S2;
        Mon, 22 Feb 2021 14:02:16 +0800 (CST)
From:   dingsenjie@163.com
To:     davem@davemloft.net, kuba@kernel.org, aelior@marvell.com,
        skalluru@marvell.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dingsenjie <dingsenjie@yulong.com>
Subject: [PATCH] ethernet/broadcom:remove unneeded variable: "ret"
Date:   Mon, 22 Feb 2021 14:00:59 +0800
Message-Id: <20210222060059.37788-1-dingsenjie@163.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EMCowADnTUfnSDNg49yPdA--.7050S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrur43XF4xKw1rur4xAF1UZFb_yoWkXwbEgr
        18Xw1fKr4UJr9ayrWjyrsxu3sagayqv34v9F129rW3WrsrZw18AayqkF9xJw1rWF48JFnx
        Cry3KayIywn0kjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU0fb15UUUUU==
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 5glqw25hqmxvi6rwjhhfrp/1tbiTghByFUDH0KCFQAAsT
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


