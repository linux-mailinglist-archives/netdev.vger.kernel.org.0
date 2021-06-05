Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A0739C67B
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 09:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhFEHFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 03:05:30 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:4315 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbhFEHFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 03:05:25 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Fxr886YCqz1BGRq;
        Sat,  5 Jun 2021 14:58:48 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 15:03:34 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 5 Jun 2021 15:03:34 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 1/8] net: hd64570: remove redundant blank lines
Date:   Sat, 5 Jun 2021 15:00:22 +0800
Message-ID: <1622876429-47278-2-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622876429-47278-1-git-send-email-huangguangbin2@huawei.com>
References: <1622876429-47278-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

This patch removes some redundant blank lines.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/hd64570.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/net/wan/hd64570.c b/drivers/net/wan/hd64570.c
index 058e481..e0266c6 100644
--- a/drivers/net/wan/hd64570.c
+++ b/drivers/net/wan/hd64570.c
@@ -47,7 +47,6 @@
 #define SCA_INTR_DMAC_RX(node) (node ? 0x20 : 0x02)
 #define SCA_INTR_DMAC_TX(node) (node ? 0x40 : 0x04)
 
-
 static inline struct net_device *port_to_dev(port_t *port)
 {
 	return port->dev;
@@ -87,7 +86,6 @@ static inline u16 next_desc(port_t *port, u16 desc, int transmit)
 			     : port_to_card(port)->rx_ring_buffers);
 }
 
-
 static inline u16 desc_abs_number(port_t *port, u16 desc, int transmit)
 {
 	u16 rx_buffs = port_to_card(port)->rx_ring_buffers;
@@ -98,14 +96,12 @@ static inline u16 desc_abs_number(port_t *port, u16 desc, int transmit)
 		transmit * rx_buffs + desc;
 }
 
-
 static inline u16 desc_offset(port_t *port, u16 desc, int transmit)
 {
 	/* Descriptor offset always fits in 16 bits */
 	return desc_abs_number(port, desc, transmit) * sizeof(pkt_desc);
 }
 
-
 static inline pkt_desc __iomem *desc_address(port_t *port, u16 desc,
 					     int transmit)
 {
@@ -118,14 +114,12 @@ static inline pkt_desc __iomem *desc_address(port_t *port, u16 desc,
 #endif
 }
 
-
 static inline u32 buffer_offset(port_t *port, u16 desc, int transmit)
 {
 	return port_to_card(port)->buff_offset +
 		desc_abs_number(port, desc, transmit) * (u32)HDLC_MAX_MRU;
 }
 
-
 static inline void sca_set_carrier(port_t *port)
 {
 	if (!(sca_in(get_msci(port) + ST3, port_to_card(port)) & ST3_DCD)) {
@@ -143,7 +137,6 @@ static inline void sca_set_carrier(port_t *port)
 	}
 }
 
-
 static void sca_init_port(port_t *port)
 {
 	card_t *card = port_to_card(port);
@@ -213,7 +206,6 @@ static void sca_init_port(port_t *port)
 	sca_set_carrier(port);
 }
 
-
 #ifdef NEED_SCA_MSCI_INTR
 /* MSCI interrupt service */
 static inline void sca_msci_intr(port_t *port)
@@ -236,7 +228,6 @@ static inline void sca_msci_intr(port_t *port)
 }
 #endif
 
-
 static inline void sca_rx(card_t *card, port_t *port, pkt_desc __iomem *desc,
 			  u16 rxin)
 {
@@ -282,7 +273,6 @@ static inline void sca_rx(card_t *card, port_t *port, pkt_desc __iomem *desc,
 	netif_rx(skb);
 }
 
-
 /* Receive DMA interrupt service */
 static inline void sca_rx_intr(port_t *port)
 {
@@ -334,7 +324,6 @@ static inline void sca_rx_intr(port_t *port)
 	sca_out(DSR_DE, DSR_RX(phy_node(port)), card);
 }
 
-
 /* Transmit DMA interrupt service */
 static inline void sca_tx_intr(port_t *port)
 {
@@ -370,7 +359,6 @@ static inline void sca_tx_intr(port_t *port)
 	spin_unlock(&port->lock);
 }
 
-
 static irqreturn_t sca_intr(int irq, void* dev_id)
 {
 	card_t *card = dev_id;
@@ -400,7 +388,6 @@ static irqreturn_t sca_intr(int irq, void* dev_id)
 	return IRQ_RETVAL(handled);
 }
 
-
 static void sca_set_port(port_t *port)
 {
 	card_t* card = port_to_card(port);
@@ -408,7 +395,6 @@ static void sca_set_port(port_t *port)
 	u8 md2 = sca_in(msci + MD2, card);
 	unsigned int tmc, br = 10, brv = 1024;
 
-
 	if (port->settings.clock_rate > 0) {
 		/* Try lower br for better accuracy*/
 		do {
@@ -450,10 +436,8 @@ static void sca_set_port(port_t *port)
 		md2 &= ~MD2_LOOPBACK;
 
 	sca_out(md2, msci + MD2, card);
-
 }
 
-
 static void sca_open(struct net_device *dev)
 {
 	port_t *port = dev_to_port(dev);
@@ -517,7 +501,6 @@ static void sca_open(struct net_device *dev)
 	netif_start_queue(dev);
 }
 
-
 static void sca_close(struct net_device *dev)
 {
 	port_t *port = dev_to_port(dev);
@@ -535,7 +518,6 @@ static void sca_close(struct net_device *dev)
 	netif_stop_queue(dev);
 }
 
-
 static int sca_attach(struct net_device *dev, unsigned short encoding,
 		      unsigned short parity)
 {
@@ -558,7 +540,6 @@ static int sca_attach(struct net_device *dev, unsigned short encoding,
 	return 0;
 }
 
-
 #ifdef DEBUG_RINGS
 static void sca_dump_rings(struct net_device *dev)
 {
@@ -613,7 +594,6 @@ static void sca_dump_rings(struct net_device *dev)
 }
 #endif /* DEBUG_RINGS */
 
-
 static netdev_tx_t sca_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	port_t *port = dev_to_port(dev);
@@ -670,7 +650,6 @@ static netdev_tx_t sca_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 }
 
-
 #ifdef NEED_DETECT_RAM
 static u32 sca_detect_ram(card_t *card, u8 __iomem *rambase, u32 ramsize)
 {
@@ -699,7 +678,6 @@ static u32 sca_detect_ram(card_t *card, u8 __iomem *rambase, u32 ramsize)
 }
 #endif /* NEED_DETECT_RAM */
 
-
 static void sca_init(card_t *card, int wait_states)
 {
 	sca_out(wait_states, WCRL, card); /* Wait Control */
-- 
2.8.1

