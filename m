Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E713886A9
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 07:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235422AbhESFht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 01:37:49 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3030 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242718AbhESFf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 01:35:56 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FlM2C508tzmWtl;
        Wed, 19 May 2021 13:32:19 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 13:34:35 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 19 May 2021 13:34:34 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hui Tang <tanghui20@huawei.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH 05/20] net: broadcom: remove leading spaces before tabs
Date:   Wed, 19 May 2021 13:30:38 +0800
Message-ID: <1621402253-27200-6-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621402253-27200-1-git-send-email-tanghui20@huawei.com>
References: <1621402253-27200-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few leading spaces before tabs and remove it by running the
following commard:

	$ find . -name '*.c' | xargs sed -r -i 's/^[ ]+\t/\t/'
	$ find . -name '*.h' | xargs sed -r -i 's/^[ ]+\t/\t/'

Cc: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/net/ethernet/broadcom/b44.c  | 20 ++++++++++----------
 drivers/net/ethernet/broadcom/bnx2.c |  6 +++---
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
index b455b60..ad2655e 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -1556,8 +1556,8 @@ static void b44_setup_pseudo_magicp(struct b44 *bp)
 	plen0 = b44_magic_pattern(bp->dev->dev_addr, pwol_pattern, pwol_mask,
 				  B44_ETHIPV4UDP_HLEN);
 
-   	bwfilter_table(bp, pwol_pattern, B44_PATTERN_SIZE, B44_PATTERN_BASE);
-   	bwfilter_table(bp, pwol_mask, B44_PMASK_SIZE, B44_PMASK_BASE);
+	bwfilter_table(bp, pwol_pattern, B44_PATTERN_SIZE, B44_PATTERN_BASE);
+	bwfilter_table(bp, pwol_mask, B44_PMASK_SIZE, B44_PMASK_BASE);
 
 	/* Raw ethernet II magic packet pattern - pattern 1 */
 	memset(pwol_pattern, 0, B44_PATTERN_SIZE);
@@ -1565,9 +1565,9 @@ static void b44_setup_pseudo_magicp(struct b44 *bp)
 	plen1 = b44_magic_pattern(bp->dev->dev_addr, pwol_pattern, pwol_mask,
 				  ETH_HLEN);
 
-   	bwfilter_table(bp, pwol_pattern, B44_PATTERN_SIZE,
+	bwfilter_table(bp, pwol_pattern, B44_PATTERN_SIZE,
 		       B44_PATTERN_BASE + B44_PATTERN_SIZE);
-  	bwfilter_table(bp, pwol_mask, B44_PMASK_SIZE,
+	bwfilter_table(bp, pwol_mask, B44_PMASK_SIZE,
 		       B44_PMASK_BASE + B44_PMASK_SIZE);
 
 	/* Ipv6 magic packet pattern - pattern 2 */
@@ -1576,9 +1576,9 @@ static void b44_setup_pseudo_magicp(struct b44 *bp)
 	plen2 = b44_magic_pattern(bp->dev->dev_addr, pwol_pattern, pwol_mask,
 				  B44_ETHIPV6UDP_HLEN);
 
-   	bwfilter_table(bp, pwol_pattern, B44_PATTERN_SIZE,
+	bwfilter_table(bp, pwol_pattern, B44_PATTERN_SIZE,
 		       B44_PATTERN_BASE + B44_PATTERN_SIZE + B44_PATTERN_SIZE);
-  	bwfilter_table(bp, pwol_mask, B44_PMASK_SIZE,
+	bwfilter_table(bp, pwol_mask, B44_PMASK_SIZE,
 		       B44_PMASK_BASE + B44_PMASK_SIZE + B44_PMASK_SIZE);
 
 	kfree(pwol_pattern);
@@ -1631,9 +1631,9 @@ static void b44_setup_wol(struct b44 *bp)
 		val = br32(bp, B44_DEVCTRL);
 		bw32(bp, B44_DEVCTRL, val | DEVCTRL_MPM | DEVCTRL_PFE);
 
- 	} else {
- 		b44_setup_pseudo_magicp(bp);
- 	}
+	} else {
+		b44_setup_pseudo_magicp(bp);
+	}
 	b44_setup_wol_pci(bp);
 }
 
@@ -1757,7 +1757,7 @@ static void __b44_set_rx_mode(struct net_device *dev)
 			__b44_cam_write(bp, zero, i);
 
 		bw32(bp, B44_RXCONFIG, val);
-        	val = br32(bp, B44_CAM_CTRL);
+		val = br32(bp, B44_CAM_CTRL);
 	        bw32(bp, B44_CAM_CTRL, val | CAM_CTRL_ENABLE);
 	}
 }
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index c098609..2c5f36b 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -572,7 +572,7 @@ bnx2_write_phy(struct bnx2 *bp, u32 reg, u32 val)
 	}
 
 	if (val1 & BNX2_EMAC_MDIO_COMM_START_BUSY)
-        	ret = -EBUSY;
+		ret = -EBUSY;
 	else
 		ret = 0;
 
@@ -3599,7 +3599,7 @@ bnx2_set_rx_mode(struct net_device *dev)
 		for (i = 0; i < NUM_MC_HASH_REGISTERS; i++) {
 			BNX2_WR(bp, BNX2_EMAC_MULTICAST_HASH0 + (i * 4),
 				0xffffffff);
-        	}
+		}
 		sort_mode |= BNX2_RPM_SORT_USER0_MC_EN;
 	}
 	else {
@@ -4674,7 +4674,7 @@ bnx2_nvram_write(struct bnx2 *bp, u32 offset, u8 *data_buf,
 
 				if (addr == page_end-4) {
 					cmd_flags = BNX2_NVM_COMMAND_LAST;
-                		}
+				}
 				rc = bnx2_nvram_write_dword(bp, addr,
 					&flash_buffer[i], cmd_flags);
 
-- 
2.8.1

