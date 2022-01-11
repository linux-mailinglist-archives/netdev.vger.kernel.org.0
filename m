Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8316148A609
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 04:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241957AbiAKDGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 22:06:02 -0500
Received: from out162-62-57-137.mail.qq.com ([162.62.57.137]:45733 "EHLO
        out162-62-57-137.mail.qq.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237371AbiAKDGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 22:06:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1641870357;
        bh=ecSMM6XuKcWiwqw9LfrFz5Ws23plBSvG+Rwa8GnJgJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=ooOOn6XZBVKWBsgnvTc29ggGHvyyX+mSDon6X/oVQohtuElzn2DwnX+jqwTt8yyN5
         1n0GPJF1DwiSxEMhoDYl7hq3xlbitrUXOA3nEC2aV4SxAGxpk2R6QAbLcesgnvkeYU
         ruytJj1z3gGpQB5GHTFpu0OoYHjzkRFxvN1lZPNs=
Received: from fedora.. ([119.32.47.91])
        by newxmesmtplogicsvrsza7.qq.com (NewEsmtp) with SMTP
        id 17780050; Tue, 11 Jan 2022 11:05:55 +0800
X-QQ-mid: xmsmtpt1641870355tdzfw2s27
Message-ID: <tencent_71466C2135CD1780B19D7844BE3F167C940A@qq.com>
X-QQ-XMAILINFO: MjHH9lmJ+i2kqq5qQi1JMblBeaRRfHWHe4bBXNHU6Z2Th9No+vqtgPyfRcoJGO
         xJDxsVzl3zc6WH0q0GGYac22B/V70FQWOCrDp3jqSD01yhpiCRDmc4083pRS1feWdjxqsxGkchVw
         swg77FOuKbR+vCUBEMGOYl+xcr5n4An6sMLDwgngY2ULTg/sShfpLSZspaWDKufKr14uCvb+fuIM
         7lO6q5ceeLmsB5YDbiGjWsHqBGTrCvG61p7QpKtYi7gcx/qwYnB4KXNX21TS0zhirQr2AGkYbMbv
         eBxcp7N7fDJCOpaUSAffFzn5EYre0z+Ws4JeRRv2dG7IocE5JutQYwDPbIg1riU0ZfTGapsJ8OK0
         FRqNNPP8W3L9koiCB+XXAGuhZh9YEfs56GPIdLwb/KICSNT1z/JrA93grNhj8kDc7a4t7O0cnGQw
         0GfUzAWqIg3xRj5ugyDqLlt9+DpSNHcEdXNyGyDRkxg/q00Aj4DWmoBHMt0imTaV81CC29SSMgpw
         O/qFs9JLO6e8Fk6KrxjTumFQJNnQBdgmCTIg+NaYPNb2PBCxPuFuW60nf4AYjfwQM2gWXdmOABLb
         NBQyUV7q1PUfjw9VayhV7L+2aAxeD7y0S8w9ogHxyk7ju6hkX90ze5mX8sbQ7T49jNjYbl3JijVQ
         Hod01tve+g/2B+CCA8W7FEJz3dmPZApo310Qzq//g0OJ2+8YPoTmVZYT3od5/8wlXOJ9z9KKQvvR
         iZW1bt5sp7NAScQDZGrPp7SJyTHYPtBiSbS25puFxgJHo5lLIvmvYU8m6vHt+hXa+jdm721vBd8y
         g4uyByP/4u6POHDhpcPhUYvK9mMq88SM+D7Enrq/nOYI61taAHHdYH
From:   Conley Lee <conleylee@foxmail.com>
To:     davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
        wens@csie.org, clabbe.montjoie@gmail.com
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Conley Lee <conleylee@foxmail.com>
Subject: [PATCH v3] net: ethernet: sun4i-emac: replace magic number with macro
Date:   Tue, 11 Jan 2022 11:05:53 +0800
X-OQ-MSGID: <20220111030553.2369419-1-conleylee@foxmail.com>
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

Signed-off-by: Conley Lee <conleylee@foxmail.com>
---
Change since v2.
- fix some code style issues

Change since v1.
- reformat
- merge commits
- add commit message

---
 drivers/net/ethernet/allwinner/sun4i-emac.c | 30 ++++++++++++---------
 drivers/net/ethernet/allwinner/sun4i-emac.h | 18 +++++++++++++
 2 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index 849de4564709..74635a6fa8ca 100644
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
+			reg_val |= (EMAC_INT_CTL_TX_EN |
+					EMAC_INT_CTL_TX_ABRT_EN |
+					EMAC_INT_CTL_RX_EN);
 			writel(reg_val, db->membase + EMAC_INT_CTL_REG);
 
 			/* had one stuck? */
@@ -669,7 +671,9 @@ static void emac_rx(struct net_device *dev)
 			writel(reg_val | EMAC_CTL_RX_EN,
 			       db->membase + EMAC_CTL_REG);
 			reg_val = readl(db->membase + EMAC_INT_CTL_REG);
-			reg_val |= (0xf << 0) | (0x01 << 8);
+			reg_val |= (EMAC_INT_CTL_TX_EN |
+					EMAC_INT_CTL_TX_ABRT_EN |
+					EMAC_INT_CTL_RX_EN);
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

