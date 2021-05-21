Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11B138BB53
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 03:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236384AbhEUBMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 21:12:47 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4564 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235932AbhEUBMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 21:12:39 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FmT4r44ZbzqVC8;
        Fri, 21 May 2021 09:08:28 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 09:11:15 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 21 May 2021 09:11:15 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 4/6] net: wan: remove redundant blank lines
Date:   Fri, 21 May 2021 09:08:15 +0800
Message-ID: <1621559297-9651-5-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621559297-9651-1-git-send-email-huangguangbin2@huawei.com>
References: <1621559297-9651-1-git-send-email-huangguangbin2@huawei.com>
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
 drivers/net/wan/hd64572.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/net/wan/hd64572.c b/drivers/net/wan/hd64572.c
index aa69bcaba633..34acea93efdf 100644
--- a/drivers/net/wan/hd64572.c
+++ b/drivers/net/wan/hd64572.c
@@ -81,14 +81,12 @@ static inline u16 desc_abs_number(port_t *port, u16 desc, int transmit)
 	return port->chan * (rx_buffs + tx_buffs) + transmit * rx_buffs + desc;
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
@@ -96,14 +94,12 @@ static inline pkt_desc __iomem *desc_address(port_t *port, u16 desc,
 				    desc_offset(port, desc, transmit));
 }
 
-
 static inline u32 buffer_offset(port_t *port, u16 desc, int transmit)
 {
 	return port->card->buff_offset +
 		desc_abs_number(port, desc, transmit) * (u32)HDLC_MAX_MRU;
 }
 
-
 static inline void sca_set_carrier(port_t *port)
 {
 	if (!(sca_in(get_msci(port) + ST3, port->card) & ST3_DCD)) {
@@ -121,7 +117,6 @@ static inline void sca_set_carrier(port_t *port)
 	}
 }
 
-
 static void sca_init_port(port_t *port)
 {
 	card_t *card = port->card;
@@ -181,7 +176,6 @@ static void sca_init_port(port_t *port)
 	netif_napi_add(port->netdev, &port->napi, sca_poll, NAPI_WEIGHT);
 }
 
-
 /* MSCI interrupt service */
 static inline void sca_msci_intr(port_t *port)
 {
@@ -195,7 +189,6 @@ static inline void sca_msci_intr(port_t *port)
 	}
 }
 
-
 static inline void sca_rx(card_t *card, port_t *port, pkt_desc __iomem *desc,
 			  u16 rxin)
 {
@@ -225,7 +218,6 @@ static inline void sca_rx(card_t *card, port_t *port, pkt_desc __iomem *desc,
 	netif_receive_skb(skb);
 }
 
-
 /* Receive DMA service */
 static inline int sca_rx_done(port_t *port, int budget)
 {
@@ -281,7 +273,6 @@ static inline int sca_rx_done(port_t *port, int budget)
 	return received;
 }
 
-
 /* Transmit DMA service */
 static inline void sca_tx_done(port_t *port)
 {
@@ -321,7 +312,6 @@ static inline void sca_tx_done(port_t *port)
 	spin_unlock(&port->lock);
 }
 
-
 static int sca_poll(struct napi_struct *napi, int budget)
 {
 	port_t *port = container_of(napi, port_t, napi);
@@ -363,7 +353,6 @@ static irqreturn_t sca_intr(int irq, void *dev_id)
 	return IRQ_RETVAL(handled);
 }
 
-
 static void sca_set_port(port_t *port)
 {
 	card_t *card = port->card;
@@ -371,7 +360,6 @@ static void sca_set_port(port_t *port)
 	u8 md2 = sca_in(msci + MD2, card);
 	unsigned int tmc, br = 10, brv = 1024;
 
-
 	if (port->settings.clock_rate > 0) {
 		/* Try lower br for better accuracy*/
 		do {
@@ -414,10 +402,8 @@ static void sca_set_port(port_t *port)
 		md2 &= ~MD2_LOOPBACK;
 
 	sca_out(md2, msci + MD2, card);
-
 }
 
-
 static void sca_open(struct net_device *dev)
 {
 	port_t *port = dev_to_port(dev);
@@ -494,7 +480,6 @@ static void sca_open(struct net_device *dev)
 	netif_start_queue(dev);
 }
 
-
 static void sca_close(struct net_device *dev)
 {
 	port_t *port = dev_to_port(dev);
@@ -506,7 +491,6 @@ static void sca_close(struct net_device *dev)
 	netif_stop_queue(dev);
 }
 
-
 static int sca_attach(struct net_device *dev, unsigned short encoding,
 		      unsigned short parity)
 {
@@ -529,7 +513,6 @@ static int sca_attach(struct net_device *dev, unsigned short encoding,
 	return 0;
 }
 
-
 #ifdef DEBUG_RINGS
 static void sca_dump_rings(struct net_device *dev)
 {
@@ -576,7 +559,6 @@ static void sca_dump_rings(struct net_device *dev)
 }
 #endif /* DEBUG_RINGS */
 
-
 static netdev_tx_t sca_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	port_t *port = dev_to_port(dev);
@@ -618,7 +600,6 @@ static netdev_tx_t sca_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 }
 
-
 static u32 sca_detect_ram(card_t *card, u8 __iomem *rambase, u32 ramsize)
 {
 	/* Round RAM size to 32 bits, fill from end to start */
@@ -637,7 +618,6 @@ static u32 sca_detect_ram(card_t *card, u8 __iomem *rambase, u32 ramsize)
 	return i;
 }
 
-
 static void sca_init(card_t *card, int wait_states)
 {
 	sca_out(wait_states, WCRL, card); /* Wait Control */
-- 
2.8.1

