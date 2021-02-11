Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1AD3188C7
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 11:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbhBKKz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 05:55:57 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41304 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231169AbhBKKvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 05:51:55 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11BAp4Lm017003;
        Thu, 11 Feb 2021 02:51:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Ffc005doljDZq7ZBkKj9BHL4DMSmfMsFk13MamXETPw=;
 b=ZKaX7fX+rqXU8zz4StKeP7BQoYAlkjmCkUm6z+pZ8mFs/sgOsvAvhjCecHG4jkYe7oH0
 mZWXCbPF12zoqC8QjFa0xl5pu1LYCDUSWEI+a0Dy4Zv43C/kF0u9I2xyc9/tvSARG+/i
 e6TUxt5Yz+KaMVJUhvVwS9EcvrACvZwbpnSwWa6jt8D/6dr8i3DGbkoMYUC14frQQuyQ
 NWkMx66vO0/6DxghrxY4MUzWVtdNzzAlyjhxdkuS4viOQAE0TGeXKtPWYqLx0ciXePiv
 7MKjbOVmhnc9hkMlW5oPtWi/xUOgMP4sfHcq1F4ibMStBy7GN/1Tu6Ggx/dCBzWyxDCB dA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugqefbf-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 02:51:04 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 02:51:02 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 02:51:01 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Feb 2021 02:51:01 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 093713F7043;
        Thu, 11 Feb 2021 02:50:57 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>, <devicetree@vger.kernel.org>,
        <robh+dt@kernel.org>, <sebastian.hesselbarth@gmail.com>,
        <gregory.clement@bootlin.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v13 net-next 05/15] net: mvpp2: add PPv23 version definition
Date:   Thu, 11 Feb 2021 12:48:52 +0200
Message-ID: <1613040542-16500-6-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1613040542-16500-1-git-send-email-stefanc@marvell.com>
References: <1613040542-16500-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_05:2021-02-10,2021-02-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

This patch add PPv23 version definition.
PPv23 is new packet processor in CP115.
Everything that supported by PPv22, also supported by PPv23.
No functional changes in this stage.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
Acked-by: Marcin Wojtas <mw@semihalf.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      | 24 ++++++++++++--------
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 15 ++++++++----
 2 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 56e90ab..ce08086 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -60,6 +60,9 @@
 /* Top Registers */
 #define MVPP2_MH_REG(port)			(0x5040 + 4 * (port))
 #define MVPP2_DSA_EXTENDED			BIT(5)
+#define MVPP2_VER_ID_REG			0x50b0
+#define MVPP2_VER_PP22				0x10
+#define MVPP2_VER_PP23				0x11
 
 /* Parser Registers */
 #define MVPP2_PRS_INIT_LOOKUP_REG		0x1000
@@ -469,7 +472,7 @@
 #define     MVPP22_GMAC_INT_SUM_MASK_LINK_STAT	BIT(1)
 #define	    MVPP22_GMAC_INT_SUM_MASK_PTP	BIT(2)
 
-/* Per-port XGMAC registers. PPv2.2 only, only for GOP port 0,
+/* Per-port XGMAC registers. PPv2.2 and PPv2.3, only for GOP port 0,
  * relative to port->base.
  */
 #define MVPP22_XLG_CTRL0_REG			0x100
@@ -506,7 +509,7 @@
 #define     MVPP22_XLG_CTRL4_MACMODSELECT_GMAC	BIT(12)
 #define     MVPP22_XLG_CTRL4_EN_IDLE_CHECK	BIT(14)
 
-/* SMI registers. PPv2.2 only, relative to priv->iface_base. */
+/* SMI registers. PPv2.2 and PPv2.3, relative to priv->iface_base. */
 #define MVPP22_SMI_MISC_CFG_REG			0x1204
 #define     MVPP22_SMI_POLLING_EN		BIT(10)
 
@@ -582,7 +585,7 @@
 #define MVPP2_QUEUE_NEXT_DESC(q, index) \
 	(((index) < (q)->last_desc) ? ((index) + 1) : 0)
 
-/* XPCS registers. PPv2.2 only */
+/* XPCS registers.PPv2.2 and PPv2.3 */
 #define MVPP22_MPCS_BASE(port)			(0x7000 + (port) * 0x1000)
 #define MVPP22_MPCS_CTRL			0x14
 #define     MVPP22_MPCS_CTRL_FWD_ERR_CONN	BIT(10)
@@ -593,7 +596,7 @@
 #define     MVPP22_MPCS_CLK_RESET_DIV_RATIO(n)	((n) << 4)
 #define     MVPP22_MPCS_CLK_RESET_DIV_SET	BIT(11)
 
-/* XPCS registers. PPv2.2 only */
+/* XPCS registers. PPv2.2 and PPv2.3 */
 #define MVPP22_XPCS_BASE(port)			(0x7400 + (port) * 0x1000)
 #define MVPP22_XPCS_CFG0			0x0
 #define     MVPP22_XPCS_CFG0_RESET_DIS		BIT(0)
@@ -927,15 +930,16 @@ struct mvpp2 {
 	void __iomem *iface_base;
 	void __iomem *cm3_base;
 
-	/* On PPv2.2, each "software thread" can access the base
+	/* On PPv2.2 and PPv2.3, each "software thread" can access the base
 	 * register through a separate address space, each 64 KB apart
 	 * from each other. Typically, such address spaces will be
 	 * used per CPU.
 	 */
 	void __iomem *swth_base[MVPP2_MAX_THREADS];
 
-	/* On PPv2.2, some port control registers are located into the system
-	 * controller space. These registers are accessible through a regmap.
+	/* On PPv2.2 and PPv2.3, some port control registers are located into
+	 * the system controller space. These registers are accessible
+	 * through a regmap.
 	 */
 	struct regmap *sysctrl_base;
 
@@ -977,7 +981,7 @@ struct mvpp2 {
 	u32 tclk;
 
 	/* HW version */
-	enum { MVPP21, MVPP22 } hw_version;
+	enum { MVPP21, MVPP22, MVPP23 } hw_version;
 
 	/* Maximum number of RXQs per port */
 	unsigned int max_port_rxqs;
@@ -1221,7 +1225,7 @@ struct mvpp21_rx_desc {
 	__le32 reserved8;
 };
 
-/* HW TX descriptor for PPv2.2 */
+/* HW TX descriptor for PPv2.2 and PPv2.3 */
 struct mvpp22_tx_desc {
 	__le32 command;
 	u8  packet_offset;
@@ -1233,7 +1237,7 @@ struct mvpp22_tx_desc {
 	__le64 buf_cookie_misc;
 };
 
-/* HW RX descriptor for PPv2.2 */
+/* HW RX descriptor for PPv2.2 and PPv2.3 */
 struct mvpp22_rx_desc {
 	__le32 status;
 	__le16 reserved1;
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 17cd161..5730900 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -384,7 +384,7 @@ static int mvpp2_bm_pool_create(struct device *dev, struct mvpp2 *priv,
 	if (!IS_ALIGNED(size, 16))
 		return -EINVAL;
 
-	/* PPv2.1 needs 8 bytes per buffer pointer, PPv2.2 needs 16
+	/* PPv2.1 needs 8 bytes per buffer pointer, PPv2.2 and PPv2.3 needs 16
 	 * bytes per buffer pointer
 	 */
 	if (priv->hw_version == MVPP21)
@@ -5456,7 +5456,7 @@ static void mvpp2_rx_irqs_setup(struct mvpp2_port *port)
 		return;
 	}
 
-	/* Handle the more complicated PPv2.2 case */
+	/* Handle the more complicated PPv2.2 and PPv2.3 case */
 	for (i = 0; i < port->nqvecs; i++) {
 		struct mvpp2_queue_vector *qv = port->qvecs + i;
 
@@ -5633,7 +5633,7 @@ static bool mvpp22_port_has_legacy_tx_irqs(struct device_node *port_node,
 
 /* Checks if the port dt description has the required Tx interrupts:
  * - PPv2.1: there are no such interrupts.
- * - PPv2.2:
+ * - PPv2.2 and PPv2.3:
  *   - The old DTs have: "rx-shared", "tx-cpuX" with X in [0...3]
  *   - The new ones have: "hifX" with X in [0..8]
  *
@@ -6621,7 +6621,7 @@ static void mvpp22_rx_fifo_set_hw(struct mvpp2 *priv, int port, int data_size)
 	mvpp2_write(priv, MVPP2_RX_ATTR_FIFO_SIZE_REG(port), attr_size);
 }
 
-/* Initialize TX FIFO's: the total FIFO size is 48kB on PPv2.2.
+/* Initialize TX FIFO's: the total FIFO size is 48kB on PPv2.2 and PPv2.3.
  * 4kB fixed space must be assigned for the loopback port.
  * Redistribute remaining avialable 44kB space among all active ports.
  * Guarantee minimum 32kB for 10G port and 8kB for port 1, capable of 2.5G
@@ -6678,7 +6678,7 @@ static void mvpp22_tx_fifo_set_hw(struct mvpp2 *priv, int port, int size)
 	mvpp2_write(priv, MVPP22_TX_FIFO_THRESH_REG(port), threshold);
 }
 
-/* Initialize TX FIFO's: the total FIFO size is 19kB on PPv2.2.
+/* Initialize TX FIFO's: the total FIFO size is 19kB on PPv2.2 and PPv2.3.
  * 3kB fixed space must be assigned for the loopback port.
  * Redistribute remaining avialable 16kB space among all active ports.
  * The 10G interface should use 10kB (which is maximum possible size
@@ -7049,6 +7049,11 @@ static int mvpp2_probe(struct platform_device *pdev)
 			priv->port_map |= BIT(i);
 	}
 
+	if (priv->hw_version != MVPP21) {
+		if (mvpp2_read(priv, MVPP2_VER_ID_REG) == MVPP2_VER_PP23)
+			priv->hw_version = MVPP23;
+	}
+
 	/* Initialize network controller */
 	err = mvpp2_init(pdev, priv);
 	if (err < 0) {
-- 
1.9.1

