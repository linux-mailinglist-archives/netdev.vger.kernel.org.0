Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35C994890CA
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 08:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239453AbiAJHZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 02:25:38 -0500
Received: from out162-62-57-210.mail.qq.com ([162.62.57.210]:51619 "EHLO
        out162-62-57-210.mail.qq.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239322AbiAJHYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 02:24:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1641799470;
        bh=qnDuLkInDd7H3HP9HBO/tRxoGCJl57LHYRdQZPrsjsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=hJ8BjBz6b4lvLJfTrNjIyxY4FN2fQmeyoK/T51K0UpRNnX5akTKO3QaQ3QJsZ94LW
         hWdB00griLhUuues9Njx++wzpa0jJhlCgxtT0TjMnSxCWFgbzfW5mykGjEPOyxqdkg
         7K2UiUCfYtSvA2KtGOTYaym1+5Q9+xXs58cupgpw=
Received: from fedora.. ([119.32.47.91])
        by newxmesmtplogicsvrsza9.qq.com (NewEsmtp) with SMTP
        id 5CD80CD5; Mon, 10 Jan 2022 15:23:13 +0800
X-QQ-mid: xmsmtpt1641799399tgimq3pd8
Message-ID: <tencent_DEA0AF54608BBD29ADC09D0DCA83E85DA205@qq.com>
X-QQ-XMAILINFO: OZ7HbAk7YCRiLu20qljPu1APmkzChkgm7N3Nyupk1yvU2sKbc9YzbYD5/Jwajb
         7btfAo8/+9G0BVjKSKzYnpt1vOWIiri6Cbb/MUI+JVpb9xth0u3TmXkqmXq/DgO2cNZs3Pp4BbFt
         4FqbVOs2DuE+bfjiPdUKUogmFUOuWYEQ6g0rdubvTG9FbNqhAY7WfyfIYHllbM4XMlot9vcXseNO
         urEP+phZkPU2L/cknfkw8Dp3FJIkWt4C3b1rF3+p6wwhaUIsH5Mqjd9xznYOLx96aRETbAVUFwpv
         O0WrU/hd1kIn9v3DMwQfIocAaLRFrCrehL88VyhW06vqvTVEQOiaqxRYJfU6QRRoFgzmTBKvb2Xm
         1f1pNWsnybvYG5J6I6aY1GoRa48PNsD67WXr8zCKdO1/esBKFB33s3Gxzf6yMVzBh93na3uXFNMj
         jVFIIRuVRRJGsjZefqFJ3hTngkWapvsUMAlc/Zf40V488q21c/tcwJXHSSqKrmdlox9l0KSd6bjM
         nxBOqnWzYUTKFjMWSSokttQRyCaSsp8i86UhDIfMxPa1JfRpI4y+/RWyVWXU2T7yQs4DiTWoFcLr
         bAS40S+4Td7iWB2sAK87disisLeLd6tcGXbJnzW+5K7Ve8otSQeUE558esA9lIGo6Tz1VKBxGRaz
         iaRgLFhnOvvrYBsS/I76FKuw7pnYTruLlxzxQi11n0RYd4b6g0oSbhdOIveEEBt2vAh0X6WJpCtm
         8nmIpG+7omUAim87jmC9mlOz8PBY3gdli69GcL57iAD3+3mN6SY4CCZYV148AZ88ih1L1b0Mp6uP
         tvXu7xThzbP6lwDJZ/WUKLRnA1sKZxUlG+aJBW1YodaldxtFpf4Tx601SeeNAAP/ExWCtPUZ4coN
         YKsk2d2zhEY7P+F9hWP1MSt9J5I+QctEHhzQlZWU8w
From:   conleylee@foxmail.com
To:     davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
        wens@csie.org
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, conley <conleylee@foxmail.com>
Subject: [PATCH 2/2] sun4i-emac.c: replace magic number with macro
Date:   Mon, 10 Jan 2022 15:23:09 +0800
X-OQ-MSGID: <20220110072309.2259523-3-conleylee@foxmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220110072309.2259523-1-conleylee@foxmail.com>
References: <20220110072309.2259523-1-conleylee@foxmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: conley <conleylee@foxmail.com>

Signed-off-by: conley <conleylee@foxmail.com>
---
 drivers/net/ethernet/allwinner/sun4i-emac.c | 26 ++++++++++-----------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index 849de4564709..cf9d8e9a4d9f 100644
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
+	reg_val &=~ EMAC_MAC_MCFG_MII_CLKD_MASK;
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
@@ -637,7 +637,7 @@ static void emac_rx(struct net_device *dev)
 		if (!rxcount) {
 			db->emacrx_completed_flag = 1;
 			reg_val = readl(db->membase + EMAC_INT_CTL_REG);
-			reg_val |= (0xf << 0) | (0x01 << 8);
+			reg_val |= (EMAC_INT_CTL_TX_EN | EMAC_INT_CTL_TX_ABRT_EN | EMAC_INT_CTL_RX_EN);
 			writel(reg_val, db->membase + EMAC_INT_CTL_REG);
 
 			/* had one stuck? */
@@ -669,7 +669,7 @@ static void emac_rx(struct net_device *dev)
 			writel(reg_val | EMAC_CTL_RX_EN,
 			       db->membase + EMAC_CTL_REG);
 			reg_val = readl(db->membase + EMAC_INT_CTL_REG);
-			reg_val |= (0xf << 0) | (0x01 << 8);
+			reg_val |= (EMAC_INT_CTL_TX_EN | EMAC_INT_CTL_TX_ABRT_EN | EMAC_INT_CTL_RX_EN);
 			writel(reg_val, db->membase + EMAC_INT_CTL_REG);
 
 			db->emacrx_completed_flag = 1;
@@ -783,20 +783,20 @@ static irqreturn_t emac_interrupt(int irq, void *dev_id)
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
 
-- 
2.31.1

