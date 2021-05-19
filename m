Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0EA938864D
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 07:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242209AbhESFBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 01:01:47 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3415 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbhESFBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 01:01:46 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FlLGB28QKzCtBb;
        Wed, 19 May 2021 12:57:38 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 13:00:24 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 19 May 2021 13:00:24 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hui Tang <tanghui20@huawei.com>,
        Steffen Klassert <klassert@kernel.org>,
        Jes Sorensen <jes@trained-monkey.org>,
        Michael Chan <michael.chan@broadcom.com>,
        "Rasesh Mody" <rmody@marvell.com>, <GR-Linux-NIC-Dev@marvell.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Russell King <linux@armlinux.org.uk>,
        Daniele Venzano <venza@brownhat.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Shannon Nelson <snelson@pensando.io>,
        "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Joe Perches <joe@perches.com>,
        Lee Jones <lee.jones@linaro.org>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Weihang Li <liweihang@huawei.com>,
        Nathan Chancellor <nathan@kernel.org>,
        "Christophe JAILLET" <christophe.jaillet@wanadoo.fr>,
        Yixing Liu <liuyixing1@huawei.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Mike Rapoport <rppt@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jeremy Kerr <jk@ozlabs.org>, Moritz Fischer <mdf@kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Lucy Yan <lucyyan@google.com>,
        Edward Cree <ecree@solarflare.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Zheng Yongjun" <zhengyongjun3@huawei.com>,
        Jason Yan <yanaijie@huawei.com>,
        "Andrew Lunn" <andrew@lunn.ch>, Wang Hai <wanghai38@huawei.com>,
        Allen Pais <apais@linux.microsoft.com>,
        Colin Ian King <colin.king@canonical.com>,
        "Luo Jiaxing" <luojiaxing@huawei.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Qiushi Wu <wu000273@umn.edu>,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Gaurav Singh <gaurav1086@gmail.com>, <linux-acenic@sunsite.dk>,
        <linux-parisc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 05/20] net: broadcom: remove leading spaces before tabs
Date:   Wed, 19 May 2021 12:45:30 +0800
Message-ID: <1621399671-15517-6-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621399671-15517-1-git-send-email-tanghui20@huawei.com>
References: <1621399671-15517-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few leading spaces before tabs and remove it by running the
following commard:

	$ find . -name '*.c' | xargs sed -r -i 's/^[ ]+\t/\t/'
	$ find . -name '*.h' | xargs sed -r -i 's/^[ ]+\t/\t/'

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

