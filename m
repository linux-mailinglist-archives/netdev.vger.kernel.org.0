Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4726E4898C6
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 13:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245620AbiAJMlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 07:41:23 -0500
Received: from xmbgsz7.mail.foxmail.com ([61.241.55.243]:44885 "EHLO
        xmbgsz7.mail.foxmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245599AbiAJMlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 07:41:23 -0500
X-Greylist: delayed 98139 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Jan 2022 07:41:22 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1641818478;
        bh=g317dTPTpgSCEdP8ZINM18u9N7xoe3pAeREzosvRh0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Uksghk2XXq/IobLR2p+oIM8TMmpMkoA0Ttf29TEd643sh69satFwUbaw2uxvW2mE+
         YMUvGgdFBlAsKGkTCewB6xvkHst+DD75DLPQKVWKxJElv58wuBGr1JQkgRtShj1BT+
         tmMkXVn6Z/iEyXcSatPgnbSyRxUmXkA135umrEj8=
Received: from fedora.. ([119.32.47.91])
        by newxmesmtplogicsvrsza7.qq.com (NewEsmtp) with SMTP
        id 8F2BB215; Mon, 10 Jan 2022 19:35:50 +0800
X-QQ-mid: xmsmtpt1641814550tadfo0vjb
Message-ID: <tencent_AEEE0573A5455BBE4D5C05226C6C1E3AEF08@qq.com>
X-QQ-XMAILINFO: Nw6Y/HeEb1MZpHgDiS7/LJhp8IFwyZJ3C+va4g8+G8duTO4HNq19H40VxVRsmZ
         hK4yG/pKkgw6U4ntv2yxX2xIZs+nhAsRN9iaxZBzjIoVeN/TTs+rbUATOmObZIjRkZwNCY0Hqi3J
         uz57tU6NVoURjeAxSQQSMxCyD8xo+eVla/YN3OdawDbOBDp9y0OFCA2AJ+adkuucqLGnDG90w09z
         xwP7UsZmBX80hOK9FFEHhGRJsvXxVGvYPLWJNZdwjDhXxXHZEziODe1OQmb+aXwcsxDIvtD1pRFU
         knn5SEFNbi3LgkAHDSjDzb2GDwP9gB5+zkcHWa9KZQX5419LWq6ic+9qenRFa+zTvNr3AhDeLcoS
         UAYDYgk+eQVBAlfBLU0qOWgEKCnOM8vQlQvn9mPCk6t73aYuXa3CXd3DqPUL/iDySwPZB28RP86s
         shTtjwrRh/PJWN1gIgMV19JBii9MJZwiIyGOuX+q1UOvZ5vIN/1YE3aHfSScILZ1fKl9Dpbh7sTt
         SWfSNUbAhwbdtKNb8WhBpW4i84k6Hrdg/psmFI9yUz6hbItyBLmY0yJmwU+23CwM5tj/0rzyA2C5
         GAFFB2OOLmVd81lQ7XkW0fznTeS3IdZIliQFRg6CSKKMzcdaSApka9FOvOflTDaL4r01zXrbKI3e
         OnxBV5ll3rUylf6uwgsR3ZfiG2T3RM0Wv2TspUY7WUogV/2cBg72y3HeiqjAkiOlLagk2s3RxvRk
         xFUBuaQefiMhwy8cA1ifPSKM/GNMuxFjBkqHvIv5KXi/veSt3Z9ttJzjEWuXVd3RGq1wiXlMVgRT
         9ZXdFtRuMIB36gMzSTMx9l601k/qabR3NI0LLY1OAzlstIT7jCKvNHXZjFQq2yfQaAUPKLxOO+fy
         aRZT5yEyr+tjoVuD01wwk1C9hFP6X3DkDwHlEr6kDGY4pCWzR0h7k23QQUo6/1EA==
From:   Conley Lee <conleylee@foxmail.com>
To:     davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
        wens@csie.org, clabbe.montjoie@gmail.com
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Conley Lee <conleylee@foxmail.com>
Subject: [PATCH v2] net: ethernet: sun4i-emac: replace magic number with macro
Date:   Mon, 10 Jan 2022 19:35:49 +0800
X-OQ-MSGID: <20220110113549.2297850-1-conleylee@foxmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <tencent_58B12979F0BFDB1520949A6DB536ED15940A@qq.com>
References: <tencent_58B12979F0BFDB1520949A6DB536ED15940A@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch remove magic numbers in sun4i-emac.c and replace with macros
defined in sun4i-emac.h

Change since v1
---------------
- reformat
- merge commits
- add commit message

Signed-off-by: Conley Lee <conleylee@foxmail.com>
---
 drivers/net/ethernet/allwinner/sun4i-emac.c | 30 ++++++++++++---------
 drivers/net/ethernet/allwinner/sun4i-emac.h | 18 +++++++++++++
 2 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index 849de4564709..98fd98feb439 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -106,9 +106,9 @@ static void emac_update_speed(struct net_device *dev)
 
 	/* set EMAC SPEED, depend on PHY  */
 	reg_val = readl(db->membase + EMAC_MAC_SUPP_REG);
-	reg_val &= ~(0x1 << 8);
+	reg_val &= ~EMAC_MAC_SUPP_100M;
 	if (db->speed == SPEED_100)
-		reg_val |= 1 << 8;
+		reg_val |= EMAC_MAC_SUPP_100M;
 	writel(reg_val, db->membase + EMAC_MAC_SUPP_REG);
 }
 
@@ -264,7 +264,7 @@ static void emac_dma_done_callback(void *arg)
 
 	/* re enable interrupt */
 	reg_val = readl(db->membase + EMAC_INT_CTL_REG);
-	reg_val |= (0x01 << 8);
+	reg_val |= EMAC_INT_CTL_RX_EN;
 	writel(reg_val, db->membase + EMAC_INT_CTL_REG);
 
 	db->emacrx_completed_flag = 1;
@@ -429,7 +429,7 @@ static unsigned int emac_powerup(struct net_device *ndev)
 	/* initial EMAC */
 	/* flush RX FIFO */
 	reg_val = readl(db->membase + EMAC_RX_CTL_REG);
-	reg_val |= 0x8;
+	reg_val |= EMAC_RX_CTL_FLUSH_FIFO;
 	writel(reg_val, db->membase + EMAC_RX_CTL_REG);
 	udelay(1);
 
@@ -441,8 +441,8 @@ static unsigned int emac_powerup(struct net_device *ndev)
 
 	/* set MII clock */
 	reg_val = readl(db->membase + EMAC_MAC_MCFG_REG);
-	reg_val &= (~(0xf << 2));
-	reg_val |= (0xD << 2);
+	reg_val &= ~EMAC_MAC_MCFG_MII_CLKD_MASK;
+	reg_val |= EMAC_MAC_MCFG_MII_CLKD_72;
 	writel(reg_val, db->membase + EMAC_MAC_MCFG_REG);
 
 	/* clear RX counter */
@@ -506,7 +506,7 @@ static void emac_init_device(struct net_device *dev)
 
 	/* enable RX/TX0/RX Hlevel interrup */
 	reg_val = readl(db->membase + EMAC_INT_CTL_REG);
-	reg_val |= (0xf << 0) | (0x01 << 8);
+	reg_val |= (EMAC_INT_CTL_TX_EN | EMAC_INT_CTL_TX_ABRT_EN | EMAC_INT_CTL_RX_EN);
 	writel(reg_val, db->membase + EMAC_INT_CTL_REG);
 
 	spin_unlock_irqrestore(&db->lock, flags);
@@ -637,7 +637,9 @@ static void emac_rx(struct net_device *dev)
 		if (!rxcount) {
 			db->emacrx_completed_flag = 1;
 			reg_val = readl(db->membase + EMAC_INT_CTL_REG);
-			reg_val |= (0xf << 0) | (0x01 << 8);
+			reg_val |=
+				(EMAC_INT_CTL_TX_EN | EMAC_INT_CTL_TX_ABRT_EN |
+				 EMAC_INT_CTL_RX_EN);
 			writel(reg_val, db->membase + EMAC_INT_CTL_REG);
 
 			/* had one stuck? */
@@ -669,7 +671,9 @@ static void emac_rx(struct net_device *dev)
 			writel(reg_val | EMAC_CTL_RX_EN,
 			       db->membase + EMAC_CTL_REG);
 			reg_val = readl(db->membase + EMAC_INT_CTL_REG);
-			reg_val |= (0xf << 0) | (0x01 << 8);
+			reg_val |=
+				(EMAC_INT_CTL_TX_EN | EMAC_INT_CTL_TX_ABRT_EN |
+				 EMAC_INT_CTL_RX_EN);
 			writel(reg_val, db->membase + EMAC_INT_CTL_REG);
 
 			db->emacrx_completed_flag = 1;
@@ -783,20 +787,20 @@ static irqreturn_t emac_interrupt(int irq, void *dev_id)
 	}
 
 	/* Transmit Interrupt check */
-	if (int_status & (0x01 | 0x02))
+	if (int_status & EMAC_INT_STA_TX_COMPLETE)
 		emac_tx_done(dev, db, int_status);
 
-	if (int_status & (0x04 | 0x08))
+	if (int_status & EMAC_INT_STA_TX_ABRT)
 		netdev_info(dev, " ab : %x\n", int_status);
 
 	/* Re-enable interrupt mask */
 	if (db->emacrx_completed_flag == 1) {
 		reg_val = readl(db->membase + EMAC_INT_CTL_REG);
-		reg_val |= (0xf << 0) | (0x01 << 8);
+		reg_val |= (EMAC_INT_CTL_TX_EN | EMAC_INT_CTL_TX_ABRT_EN | EMAC_INT_CTL_RX_EN);
 		writel(reg_val, db->membase + EMAC_INT_CTL_REG);
 	} else {
 		reg_val = readl(db->membase + EMAC_INT_CTL_REG);
-		reg_val |= (0xf << 0);
+		reg_val |= (EMAC_INT_CTL_TX_EN | EMAC_INT_CTL_TX_ABRT_EN);
 		writel(reg_val, db->membase + EMAC_INT_CTL_REG);
 	}
 
diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.h b/drivers/net/ethernet/allwinner/sun4i-emac.h
index 38c72d9ec600..90bd9ad77607 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.h
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.h
@@ -38,6 +38,7 @@
 #define EMAC_RX_CTL_REG		(0x3c)
 #define EMAC_RX_CTL_AUTO_DRQ_EN		(1 << 1)
 #define EMAC_RX_CTL_DMA_EN		(1 << 2)
+#define EMAC_RX_CTL_FLUSH_FIFO		(1 << 3)
 #define EMAC_RX_CTL_PASS_ALL_EN		(1 << 4)
 #define EMAC_RX_CTL_PASS_CTL_EN		(1 << 5)
 #define EMAC_RX_CTL_PASS_CRC_ERR_EN	(1 << 6)
@@ -61,7 +62,21 @@
 #define EMAC_RX_IO_DATA_STATUS_OK	(1 << 7)
 #define EMAC_RX_FBC_REG		(0x50)
 #define EMAC_INT_CTL_REG	(0x54)
+#define EMAC_INT_CTL_RX_EN	(1 << 8)
+#define EMAC_INT_CTL_TX0_EN	(1)
+#define EMAC_INT_CTL_TX1_EN	(1 << 1)
+#define EMAC_INT_CTL_TX_EN	(EMAC_INT_CTL_TX0_EN | EMAC_INT_CTL_TX1_EN)
+#define EMAC_INT_CTL_TX0_ABRT_EN	(0x1 << 2)
+#define EMAC_INT_CTL_TX1_ABRT_EN	(0x1 << 3)
+#define EMAC_INT_CTL_TX_ABRT_EN	(EMAC_INT_CTL_TX0_ABRT_EN | EMAC_INT_CTL_TX1_ABRT_EN)
 #define EMAC_INT_STA_REG	(0x58)
+#define EMAC_INT_STA_TX0_COMPLETE	(0x1)
+#define EMAC_INT_STA_TX1_COMPLETE	(0x1 << 1)
+#define EMAC_INT_STA_TX_COMPLETE	(EMAC_INT_STA_TX0_COMPLETE | EMAC_INT_STA_TX1_COMPLETE)
+#define EMAC_INT_STA_TX0_ABRT	(0x1 << 2)
+#define EMAC_INT_STA_TX1_ABRT	(0x1 << 3)
+#define EMAC_INT_STA_TX_ABRT	(EMAC_INT_STA_TX0_ABRT | EMAC_INT_STA_TX1_ABRT)
+#define EMAC_INT_STA_RX_COMPLETE	(0x1 << 8)
 #define EMAC_MAC_CTL0_REG	(0x5c)
 #define EMAC_MAC_CTL0_RX_FLOW_CTL_EN	(1 << 2)
 #define EMAC_MAC_CTL0_TX_FLOW_CTL_EN	(1 << 3)
@@ -87,8 +102,11 @@
 #define EMAC_MAC_CLRT_RM		(0x0f)
 #define EMAC_MAC_MAXF_REG	(0x70)
 #define EMAC_MAC_SUPP_REG	(0x74)
+#define EMAC_MAC_SUPP_100M	(0x1 << 8)
 #define EMAC_MAC_TEST_REG	(0x78)
 #define EMAC_MAC_MCFG_REG	(0x7c)
+#define EMAC_MAC_MCFG_MII_CLKD_MASK	(0xff << 2)
+#define EMAC_MAC_MCFG_MII_CLKD_72	(0x0d << 2)
 #define EMAC_MAC_A0_REG		(0x98)
 #define EMAC_MAC_A1_REG		(0x9c)
 #define EMAC_MAC_A2_REG		(0xa0)
-- 
2.31.1

