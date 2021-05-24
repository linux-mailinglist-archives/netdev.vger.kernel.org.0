Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504DD38EA4A
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 16:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbhEXOx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 10:53:56 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3987 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233969AbhEXOvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 10:51:54 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Fpg716HZJzmZsH;
        Mon, 24 May 2021 22:47:57 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 24 May 2021 22:50:17 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 24 May 2021 22:50:17 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 01/10] net: wan: remove redundant blank lines
Date:   Mon, 24 May 2021 22:47:08 +0800
Message-ID: <1621867637-2680-2-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621867637-2680-1-git-send-email-huangguangbin2@huawei.com>
References: <1621867637-2680-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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
 drivers/net/wan/wanxl.c | 38 --------------------------------------
 1 file changed, 38 deletions(-)

diff --git a/drivers/net/wan/wanxl.c b/drivers/net/wan/wanxl.c
index f393684f203a..676dd813d36d 100644
--- a/drivers/net/wan/wanxl.c
+++ b/drivers/net/wan/wanxl.c
@@ -50,7 +50,6 @@ static const char* version = "wanXL serial card driver version: 0.48";
 /* MAILBOX #2 - DRAM SIZE */
 #define MBX2_MEMSZ_MASK 0xFFFF0000 /* PUTS Memory Size Register mask */
 
-
 struct port {
 	struct net_device *dev;
 	struct card *card;
@@ -61,13 +60,11 @@ struct port {
 	struct sk_buff *tx_skbs[TX_BUFFERS];
 };
 
-
 struct card_status {
 	desc_t rx_descs[RX_QUEUE_LENGTH];
 	port_status_t port_status[4];
 };
 
-
 struct card {
 	int n_ports;		/* 1, 2 or 4 ports */
 	u8 irq;
@@ -81,20 +78,16 @@ struct card {
 	struct port ports[];	/* 1 - 4 port structures follow */
 };
 
-
-
 static inline struct port *dev_to_port(struct net_device *dev)
 {
 	return (struct port *)dev_to_hdlc(dev)->priv;
 }
 
-
 static inline port_status_t *get_status(struct port *port)
 {
 	return &port->card->status->port_status[port->node];
 }
 
-
 #ifdef DEBUG_PCI
 static inline dma_addr_t pci_map_single_debug(struct pci_dev *pdev, void *ptr,
 					      size_t size, int direction)
@@ -110,7 +103,6 @@ static inline dma_addr_t pci_map_single_debug(struct pci_dev *pdev, void *ptr,
 #define pci_map_single pci_map_single_debug
 #endif
 
-
 /* Cable and/or personality module change interrupt service */
 static inline void wanxl_cable_intr(struct port *port)
 {
@@ -154,8 +146,6 @@ static inline void wanxl_cable_intr(struct port *port)
 		netif_carrier_off(port->dev);
 }
 
-
-
 /* Transmit complete interrupt service */
 static inline void wanxl_tx_intr(struct port *port)
 {
@@ -187,8 +177,6 @@ static inline void wanxl_tx_intr(struct port *port)
         }
 }
 
-
-
 /* Receive complete interrupt service */
 static inline void wanxl_rx_intr(struct card *card)
 {
@@ -239,8 +227,6 @@ static inline void wanxl_rx_intr(struct card *card)
 	}
 }
 
-
-
 static irqreturn_t wanxl_intr(int irq, void* dev_id)
 {
 	struct card *card = dev_id;
@@ -248,7 +234,6 @@ static irqreturn_t wanxl_intr(int irq, void* dev_id)
         u32 stat;
         int handled = 0;
 
-
         while((stat = readl(card->plx + PLX_DOORBELL_FROM_CARD)) != 0) {
                 handled = 1;
 		writel(stat, card->plx + PLX_DOORBELL_FROM_CARD);
@@ -266,8 +251,6 @@ static irqreturn_t wanxl_intr(int irq, void* dev_id)
         return IRQ_RETVAL(handled);
 }
 
-
-
 static netdev_tx_t wanxl_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct port *port = dev_to_port(dev);
@@ -312,8 +295,6 @@ static netdev_tx_t wanxl_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 }
 
-
-
 static int wanxl_attach(struct net_device *dev, unsigned short encoding,
 			unsigned short parity)
 {
@@ -335,8 +316,6 @@ static int wanxl_attach(struct net_device *dev, unsigned short encoding,
 	return 0;
 }
 
-
-
 static int wanxl_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
 	const size_t size = sizeof(sync_serial_settings);
@@ -387,8 +366,6 @@ static int wanxl_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
         }
 }
 
-
-
 static int wanxl_open(struct net_device *dev)
 {
 	struct port *port = dev_to_port(dev);
@@ -423,8 +400,6 @@ static int wanxl_open(struct net_device *dev)
 	return -EFAULT;
 }
 
-
-
 static int wanxl_close(struct net_device *dev)
 {
 	struct port *port = dev_to_port(dev);
@@ -461,8 +436,6 @@ static int wanxl_close(struct net_device *dev)
 	return 0;
 }
 
-
-
 static struct net_device_stats *wanxl_get_stats(struct net_device *dev)
 {
 	struct port *port = dev_to_port(dev);
@@ -474,8 +447,6 @@ static struct net_device_stats *wanxl_get_stats(struct net_device *dev)
 	return &dev->stats;
 }
 
-
-
 static int wanxl_puts_command(struct card *card, u32 cmd)
 {
 	unsigned long timeout = jiffies + 5 * HZ;
@@ -491,8 +462,6 @@ static int wanxl_puts_command(struct card *card, u32 cmd)
 	return -1;
 }
 
-
-
 static void wanxl_reset(struct card *card)
 {
 	u32 old_value = readl(card->plx + PLX_CONTROL) & ~PLX_CTL_RESET;
@@ -505,8 +474,6 @@ static void wanxl_reset(struct card *card)
 	readl(card->plx + PLX_CONTROL); /* wait for posted write */
 }
 
-
-
 static void wanxl_pci_remove_one(struct pci_dev *pdev)
 {
 	struct card *card = pci_get_drvdata(pdev);
@@ -543,7 +510,6 @@ static void wanxl_pci_remove_one(struct pci_dev *pdev)
 	kfree(card);
 }
 
-
 #include "wanxlfw.inc"
 
 static const struct net_device_ops wanxl_ops = {
@@ -677,7 +643,6 @@ static int wanxl_pci_init_one(struct pci_dev *pdev,
 	/* set up on-board RAM mapping */
 	mem_phy = pci_resource_start(pdev, 2);
 
-
 	/* sanity check the board's reported memory size */
 	if (ramsize < BUFFERS_ADDR +
 	    (TX_BUFFERS + RX_BUFFERS) * BUFFER_LENGTH * ports) {
@@ -813,7 +778,6 @@ static const struct pci_device_id wanxl_pci_tbl[] = {
 	{ 0, }
 };
 
-
 static struct pci_driver wanxl_pci_driver = {
 	.name		= "wanXL",
 	.id_table	= wanxl_pci_tbl,
@@ -821,7 +785,6 @@ static struct pci_driver wanxl_pci_driver = {
 	.remove		= wanxl_pci_remove_one,
 };
 
-
 static int __init wanxl_init_module(void)
 {
 #ifdef MODULE
@@ -835,7 +798,6 @@ static void __exit wanxl_cleanup_module(void)
 	pci_unregister_driver(&wanxl_pci_driver);
 }
 
-
 MODULE_AUTHOR("Krzysztof Halasa <khc@pm.waw.pl>");
 MODULE_DESCRIPTION("SBE Inc. wanXL serial port driver");
 MODULE_LICENSE("GPL v2");
-- 
2.8.1

