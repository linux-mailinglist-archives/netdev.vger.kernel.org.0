Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64839450337
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 12:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237596AbhKOLMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 06:12:31 -0500
Received: from pegase2.c-s.fr ([93.17.235.10]:55949 "EHLO pegase2.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237614AbhKOLMP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 06:12:15 -0500
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4Ht5zx3JsWz9sSP;
        Mon, 15 Nov 2021 12:09:17 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZRsRwFA9RRdi; Mon, 15 Nov 2021 12:09:17 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4Ht5zx20Q7z9sSM;
        Mon, 15 Nov 2021 12:09:17 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 2F5918B770;
        Mon, 15 Nov 2021 12:09:17 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id L4Pn52N3YmDv; Mon, 15 Nov 2021 12:09:17 +0100 (CET)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [172.25.230.108])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 07F3E8B763;
        Mon, 15 Nov 2021 12:09:17 +0100 (CET)
Received: from PO20335.IDSI0.si.c-s.fr (localhost [127.0.0.1])
        by PO20335.IDSI0.si.c-s.fr (8.16.1/8.16.1) with ESMTPS id 1AFB99ba190039
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 12:09:09 +0100
Received: (from chleroy@localhost)
        by PO20335.IDSI0.si.c-s.fr (8.16.1/8.16.1/Submit) id 1AFB98O6190037;
        Mon, 15 Nov 2021 12:09:08 +0100
X-Authentication-Warning: PO20335.IDSI0.si.c-s.fr: chleroy set sender to christophe.leroy@csgroup.eu using -f
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Zhao Qiang <qiang.zhao@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] net/wan/fsl_ucc_hdlc: fix sparse warnings
Date:   Mon, 15 Nov 2021 12:08:59 +0100
Message-Id: <28f87309a3bb26e91d93e808a3b0e43baf79cc3b.1636974508.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1636974538; l=12637; s=20211009; h=from:subject:message-id; bh=GMb4skj7qWvP2nA/1Ji7l0jkYLPXIUJNOWXUfdaEMUY=; b=w5nX2TR23NY3StVFjnXaSWS0bSJIE6D/6SyiC0KagJP3STdoBnwndIKBln+WVeyKPm/kSMRyscFo erFko9IMA/KgFZKqS8mIt4hFc0vqn984fS2dnVom8KhRIL7ahQ/q
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  CHECK   drivers/net/wan/fsl_ucc_hdlc.c
drivers/net/wan/fsl_ucc_hdlc.c:309:57: warning: incorrect type in argument 2 (different address spaces)
drivers/net/wan/fsl_ucc_hdlc.c:309:57:    expected void [noderef] __iomem *
drivers/net/wan/fsl_ucc_hdlc.c:309:57:    got restricted __be16 *
drivers/net/wan/fsl_ucc_hdlc.c:311:46: warning: incorrect type in argument 2 (different address spaces)
drivers/net/wan/fsl_ucc_hdlc.c:311:46:    expected void [noderef] __iomem *
drivers/net/wan/fsl_ucc_hdlc.c:311:46:    got restricted __be32 *
drivers/net/wan/fsl_ucc_hdlc.c:320:57: warning: incorrect type in argument 2 (different address spaces)
drivers/net/wan/fsl_ucc_hdlc.c:320:57:    expected void [noderef] __iomem *
drivers/net/wan/fsl_ucc_hdlc.c:320:57:    got restricted __be16 *
drivers/net/wan/fsl_ucc_hdlc.c:322:46: warning: incorrect type in argument 2 (different address spaces)
drivers/net/wan/fsl_ucc_hdlc.c:322:46:    expected void [noderef] __iomem *
drivers/net/wan/fsl_ucc_hdlc.c:322:46:    got restricted __be32 *
drivers/net/wan/fsl_ucc_hdlc.c:372:29: warning: incorrect type in assignment (different base types)
drivers/net/wan/fsl_ucc_hdlc.c:372:29:    expected unsigned short [usertype]
drivers/net/wan/fsl_ucc_hdlc.c:372:29:    got restricted __be16 [usertype]
drivers/net/wan/fsl_ucc_hdlc.c:379:36: warning: restricted __be16 degrades to integer
drivers/net/wan/fsl_ucc_hdlc.c:402:12: warning: incorrect type in assignment (different address spaces)
drivers/net/wan/fsl_ucc_hdlc.c:402:12:    expected struct qe_bd [noderef] __iomem *bd
drivers/net/wan/fsl_ucc_hdlc.c:402:12:    got struct qe_bd *curtx_bd
drivers/net/wan/fsl_ucc_hdlc.c:425:20: warning: incorrect type in assignment (different address spaces)
drivers/net/wan/fsl_ucc_hdlc.c:425:20:    expected struct qe_bd [noderef] __iomem *[assigned] bd
drivers/net/wan/fsl_ucc_hdlc.c:425:20:    got struct qe_bd *tx_bd_base
drivers/net/wan/fsl_ucc_hdlc.c:427:16: error: incompatible types in comparison expression (different address spaces):
drivers/net/wan/fsl_ucc_hdlc.c:427:16:    struct qe_bd [noderef] __iomem *
drivers/net/wan/fsl_ucc_hdlc.c:427:16:    struct qe_bd *
drivers/net/wan/fsl_ucc_hdlc.c:462:33: warning: incorrect type in argument 1 (different address spaces)
drivers/net/wan/fsl_ucc_hdlc.c:506:41: warning: incorrect type in argument 1 (different address spaces)
drivers/net/wan/fsl_ucc_hdlc.c:528:33: warning: incorrect type in argument 1 (different address spaces)
drivers/net/wan/fsl_ucc_hdlc.c:552:38: warning: incorrect type in argument 1 (different address spaces)
drivers/net/wan/fsl_ucc_hdlc.c:596:67: warning: incorrect type in argument 2 (different address spaces)
drivers/net/wan/fsl_ucc_hdlc.c:611:41: warning: incorrect type in argument 1 (different address spaces)
drivers/net/wan/fsl_ucc_hdlc.c:851:38: warning: incorrect type in initializer (different address spaces)
drivers/net/wan/fsl_ucc_hdlc.c:854:40: warning: incorrect type in argument 1 (different address spaces)
drivers/net/wan/fsl_ucc_hdlc.c:855:40: warning: incorrect type in argument 1 (different address spaces)
drivers/net/wan/fsl_ucc_hdlc.c:858:39: warning: incorrect type in argument 1 (different address spaces)
drivers/net/wan/fsl_ucc_hdlc.c:861:37: warning: incorrect type in argument 2 (different address spaces)
drivers/net/wan/fsl_ucc_hdlc.c:866:38: warning: incorrect type in initializer (different address spaces)
drivers/net/wan/fsl_ucc_hdlc.c:868:21: warning: incorrect type in argument 1 (different address spaces)
drivers/net/wan/fsl_ucc_hdlc.c:870:40: warning: incorrect type in argument 2 (different address spaces)
drivers/net/wan/fsl_ucc_hdlc.c:871:40: warning: incorrect type in argument 2 (different address spaces)
drivers/net/wan/fsl_ucc_hdlc.c:873:39: warning: incorrect type in argument 2 (different address spaces)
drivers/net/wan/fsl_ucc_hdlc.c:993:57: warning: incorrect type in argument 2 (different address spaces)
drivers/net/wan/fsl_ucc_hdlc.c:995:46: warning: incorrect type in argument 2 (different address spaces)
drivers/net/wan/fsl_ucc_hdlc.c:1004:57: warning: incorrect type in argument 2 (different address spaces)
drivers/net/wan/fsl_ucc_hdlc.c:1006:46: warning: incorrect type in argument 2 (different address spaces)
drivers/net/wan/fsl_ucc_hdlc.c:412:35: warning: dereference of noderef expression
drivers/net/wan/fsl_ucc_hdlc.c:412:35: warning: dereference of noderef expression
drivers/net/wan/fsl_ucc_hdlc.c:724:29: warning: dereference of noderef expression
drivers/net/wan/fsl_ucc_hdlc.c:815:21: warning: dereference of noderef expression
drivers/net/wan/fsl_ucc_hdlc.c:1021:29: warning: dereference of noderef expression

Most of the warnings are due to DMA memory being incorrectly handled as IO memory.
Fix it by doing direct read/write and doing proper dma_rmb() / dma_wmb().

Other problems are type mismatches or lack of use of IO accessors.

Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lkml.org/lkml/2021/11/12/647
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 drivers/net/wan/fsl_ucc_hdlc.c | 62 ++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wan/fsl_ucc_hdlc.c b/drivers/net/wan/fsl_ucc_hdlc.c
index cda1b4ce6b21..5ae2d27b5da9 100644
--- a/drivers/net/wan/fsl_ucc_hdlc.c
+++ b/drivers/net/wan/fsl_ucc_hdlc.c
@@ -306,9 +306,8 @@ static int uhdlc_init(struct ucc_hdlc_private *priv)
 		else
 			bd_status = R_E_S | R_I_S | R_W_S;
 
-		iowrite16be(bd_status, &priv->rx_bd_base[i].status);
-		iowrite32be(priv->dma_rx_addr + i * MAX_RX_BUF_LENGTH,
-			    &priv->rx_bd_base[i].buf);
+		priv->rx_bd_base[i].status = cpu_to_be16(bd_status);
+		priv->rx_bd_base[i].buf = cpu_to_be32(priv->dma_rx_addr + i * MAX_RX_BUF_LENGTH);
 	}
 
 	for (i = 0; i < TX_BD_RING_LEN; i++) {
@@ -317,10 +316,10 @@ static int uhdlc_init(struct ucc_hdlc_private *priv)
 		else
 			bd_status =  T_I_S | T_TC_S | T_W_S;
 
-		iowrite16be(bd_status, &priv->tx_bd_base[i].status);
-		iowrite32be(priv->dma_tx_addr + i * MAX_RX_BUF_LENGTH,
-			    &priv->tx_bd_base[i].buf);
+		priv->tx_bd_base[i].status = cpu_to_be16(bd_status);
+		priv->tx_bd_base[i].buf = cpu_to_be32(priv->dma_tx_addr + i * MAX_RX_BUF_LENGTH);
 	}
+	dma_wmb();
 
 	return 0;
 
@@ -352,10 +351,10 @@ static netdev_tx_t ucc_hdlc_tx(struct sk_buff *skb, struct net_device *dev)
 {
 	hdlc_device *hdlc = dev_to_hdlc(dev);
 	struct ucc_hdlc_private *priv = (struct ucc_hdlc_private *)hdlc->priv;
-	struct qe_bd __iomem *bd;
+	struct qe_bd *bd;
 	u16 bd_status;
 	unsigned long flags;
-	u16 *proto_head;
+	__be16 *proto_head;
 
 	switch (dev->type) {
 	case ARPHRD_RAWHDLC:
@@ -368,14 +367,14 @@ static netdev_tx_t ucc_hdlc_tx(struct sk_buff *skb, struct net_device *dev)
 
 		skb_push(skb, HDLC_HEAD_LEN);
 
-		proto_head = (u16 *)skb->data;
+		proto_head = (__be16 *)skb->data;
 		*proto_head = htons(DEFAULT_HDLC_HEAD);
 
 		dev->stats.tx_bytes += skb->len;
 		break;
 
 	case ARPHRD_PPP:
-		proto_head = (u16 *)skb->data;
+		proto_head = (__be16 *)skb->data;
 		if (*proto_head != htons(DEFAULT_PPP_HEAD)) {
 			dev->stats.tx_dropped++;
 			dev_kfree_skb(skb);
@@ -398,9 +397,10 @@ static netdev_tx_t ucc_hdlc_tx(struct sk_buff *skb, struct net_device *dev)
 	netdev_sent_queue(dev, skb->len);
 	spin_lock_irqsave(&priv->lock, flags);
 
+	dma_rmb();
 	/* Start from the next BD that should be filled */
 	bd = priv->curtx_bd;
-	bd_status = ioread16be(&bd->status);
+	bd_status = be16_to_cpu(bd->status);
 	/* Save the skb pointer so we can free it later */
 	priv->tx_skbuff[priv->skb_curtx] = skb;
 
@@ -415,8 +415,8 @@ static netdev_tx_t ucc_hdlc_tx(struct sk_buff *skb, struct net_device *dev)
 	/* set bd status and length */
 	bd_status = (bd_status & T_W_S) | T_R_S | T_I_S | T_L_S | T_TC_S;
 
-	iowrite16be(skb->len, &bd->length);
-	iowrite16be(bd_status, &bd->status);
+	bd->length = cpu_to_be16(skb->len);
+	bd->status = cpu_to_be16(bd_status);
 
 	/* Move to next BD in the ring */
 	if (!(bd_status & T_W_S))
@@ -458,8 +458,9 @@ static int hdlc_tx_done(struct ucc_hdlc_private *priv)
 	u16 bd_status;
 	int tx_restart = 0;
 
+	dma_rmb();
 	bd = priv->dirty_tx;
-	bd_status = ioread16be(&bd->status);
+	bd_status = be16_to_cpu(bd->status);
 
 	/* Normal processing. */
 	while ((bd_status & T_R_S) == 0) {
@@ -503,7 +504,7 @@ static int hdlc_tx_done(struct ucc_hdlc_private *priv)
 			bd += 1;
 		else
 			bd = priv->tx_bd_base;
-		bd_status = ioread16be(&bd->status);
+		bd_status = be16_to_cpu(bd->status);
 	}
 	priv->dirty_tx = bd;
 
@@ -524,8 +525,9 @@ static int hdlc_rx_done(struct ucc_hdlc_private *priv, int rx_work_limit)
 	u16 length, howmany = 0;
 	u8 *bdbuffer;
 
+	dma_rmb();
 	bd = priv->currx_bd;
-	bd_status = ioread16be(&bd->status);
+	bd_status = be16_to_cpu(bd->status);
 
 	/* while there are received buffers and BD is full (~R_E) */
 	while (!((bd_status & (R_E_S)) || (--rx_work_limit < 0))) {
@@ -549,7 +551,7 @@ static int hdlc_rx_done(struct ucc_hdlc_private *priv, int rx_work_limit)
 		}
 		bdbuffer = priv->rx_buffer +
 			(priv->currx_bdnum * MAX_RX_BUF_LENGTH);
-		length = ioread16be(&bd->length);
+		length = be16_to_cpu(bd->length);
 
 		switch (dev->type) {
 		case ARPHRD_RAWHDLC:
@@ -593,7 +595,7 @@ static int hdlc_rx_done(struct ucc_hdlc_private *priv, int rx_work_limit)
 		netif_receive_skb(skb);
 
 recycle:
-		iowrite16be((bd_status & R_W_S) | R_E_S | R_I_S, &bd->status);
+		bd->status = cpu_to_be16((bd_status & R_W_S) | R_E_S | R_I_S);
 
 		/* update to point at the next bd */
 		if (bd_status & R_W_S) {
@@ -608,8 +610,9 @@ static int hdlc_rx_done(struct ucc_hdlc_private *priv, int rx_work_limit)
 			bd += 1;
 		}
 
-		bd_status = ioread16be(&bd->status);
+		bd_status = be16_to_cpu(bd->status);
 	}
+	dma_rmb();
 
 	priv->currx_bd = bd;
 	return howmany;
@@ -721,7 +724,7 @@ static int uhdlc_open(struct net_device *dev)
 
 		/* Enable the TDM port */
 		if (priv->tsa)
-			utdm->si_regs->siglmr1_h |= (0x1 << utdm->tdm_port);
+			qe_setbits_8(&utdm->si_regs->siglmr1_h, 0x1 << utdm->tdm_port);
 
 		priv->hdlc_busy = 1;
 		netif_device_attach(priv->ndev);
@@ -812,7 +815,7 @@ static int uhdlc_close(struct net_device *dev)
 		     (u8)QE_CR_PROTOCOL_UNSPECIFIED, 0);
 
 	if (priv->tsa)
-		utdm->si_regs->siglmr1_h &= ~(0x1 << utdm->tdm_port);
+		qe_clrbits_8(&utdm->si_regs->siglmr1_h, 0x1 << utdm->tdm_port);
 
 	ucc_fast_disable(priv->uccf, COMM_DIR_RX | COMM_DIR_TX);
 
@@ -848,7 +851,7 @@ static int ucc_hdlc_attach(struct net_device *dev, unsigned short encoding,
 #ifdef CONFIG_PM
 static void store_clk_config(struct ucc_hdlc_private *priv)
 {
-	struct qe_mux *qe_mux_reg = &qe_immr->qmx;
+	struct qe_mux __iomem *qe_mux_reg = &qe_immr->qmx;
 
 	/* store si clk */
 	priv->cmxsi1cr_h = ioread32be(&qe_mux_reg->cmxsi1cr_h);
@@ -863,7 +866,7 @@ static void store_clk_config(struct ucc_hdlc_private *priv)
 
 static void resume_clk_config(struct ucc_hdlc_private *priv)
 {
-	struct qe_mux *qe_mux_reg = &qe_immr->qmx;
+	struct qe_mux __iomem *qe_mux_reg = &qe_immr->qmx;
 
 	memcpy_toio(qe_mux_reg->cmxucr, priv->cmxucr, 4 * sizeof(u32));
 
@@ -990,9 +993,8 @@ static int uhdlc_resume(struct device *dev)
 		else
 			bd_status = R_E_S | R_I_S | R_W_S;
 
-		iowrite16be(bd_status, &priv->rx_bd_base[i].status);
-		iowrite32be(priv->dma_rx_addr + i * MAX_RX_BUF_LENGTH,
-			    &priv->rx_bd_base[i].buf);
+		priv->rx_bd_base[i].status = cpu_to_be16(bd_status);
+		priv->rx_bd_base[i].buf = cpu_to_be32(priv->dma_rx_addr + i * MAX_RX_BUF_LENGTH);
 	}
 
 	for (i = 0; i < TX_BD_RING_LEN; i++) {
@@ -1001,10 +1003,10 @@ static int uhdlc_resume(struct device *dev)
 		else
 			bd_status =  T_I_S | T_TC_S | T_W_S;
 
-		iowrite16be(bd_status, &priv->tx_bd_base[i].status);
-		iowrite32be(priv->dma_tx_addr + i * MAX_RX_BUF_LENGTH,
-			    &priv->tx_bd_base[i].buf);
+		priv->tx_bd_base[i].status = cpu_to_be16(bd_status);
+		priv->tx_bd_base[i].buf = cpu_to_be32(priv->dma_tx_addr + i * MAX_RX_BUF_LENGTH);
 	}
+	dma_wmb();
 
 	/* if hdlc is busy enable TX and RX */
 	if (priv->hdlc_busy == 1) {
@@ -1018,7 +1020,7 @@ static int uhdlc_resume(struct device *dev)
 
 		/* Enable the TDM port */
 		if (priv->tsa)
-			utdm->si_regs->siglmr1_h |= (0x1 << utdm->tdm_port);
+			qe_setbits_8(&utdm->si_regs->siglmr1_h, 0x1 << utdm->tdm_port);
 	}
 
 	napi_enable(&priv->napi);
-- 
2.31.1

