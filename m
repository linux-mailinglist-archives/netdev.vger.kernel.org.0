Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC4823A818B
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 15:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbhFON7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 09:59:50 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:4920 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbhFON7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 09:59:42 -0400
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G48v63FW8z6xyN;
        Tue, 15 Jun 2021 21:54:26 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 15 Jun 2021 21:57:35 +0800
From:   Peng Li <lipeng321@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 1/6] net: pci200syn: remove redundant blank lines
Date:   Tue, 15 Jun 2021 21:54:18 +0800
Message-ID: <1623765263-36775-2-git-send-email-lipeng321@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623765263-36775-1-git-send-email-lipeng321@huawei.com>
References: <1623765263-36775-1-git-send-email-lipeng321@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch removes some redundant blank lines.

Signed-off-by: Peng Li <lipeng321@huawei.com>
---
 drivers/net/wan/pci200syn.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/net/wan/pci200syn.c b/drivers/net/wan/pci200syn.c
index ba5cc0c..1667dfd 100644
--- a/drivers/net/wan/pci200syn.c
+++ b/drivers/net/wan/pci200syn.c
@@ -58,8 +58,6 @@ typedef struct {
 	u32 init_ctrl;		/* 50h : EEPROM ctrl, Init Ctrl, etc */
 }plx9052;
 
-
-
 typedef struct port_s {
 	struct napi_struct napi;
 	struct net_device *netdev;
@@ -76,8 +74,6 @@ typedef struct port_s {
 	u8 chan;		/* physical port # - 0 or 1 */
 }port_t;
 
-
-
 typedef struct card_s {
 	u8 __iomem *rambase;	/* buffer memory base (virtual) */
 	u8 __iomem *scabase;	/* SCA memory base (virtual) */
@@ -90,7 +86,6 @@ typedef struct card_s {
 	port_t ports[2];
 }card_t;
 
-
 #define get_port(card, port)	     (&card->ports[port])
 #define sca_flush(card)		     (sca_in(IER0, card))
 
@@ -112,7 +107,6 @@ static inline void new_memcpy_toio(char __iomem *dest, char *src, int length)
 
 #include "hd64572.c"
 
-
 static void pci200_set_iface(port_t *port)
 {
 	card_t *card = port->card;
@@ -151,8 +145,6 @@ static void pci200_set_iface(port_t *port)
 	sca_set_port(port);
 }
 
-
-
 static int pci200_open(struct net_device *dev)
 {
 	port_t *port = dev_to_port(dev);
@@ -167,8 +159,6 @@ static int pci200_open(struct net_device *dev)
 	return 0;
 }
 
-
-
 static int pci200_close(struct net_device *dev)
 {
 	sca_close(dev);
@@ -177,8 +167,6 @@ static int pci200_close(struct net_device *dev)
 	return 0;
 }
 
-
-
 static int pci200_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
 	const size_t size = sizeof(sync_serial_settings);
@@ -233,8 +221,6 @@ static int pci200_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	}
 }
 
-
-
 static void pci200_pci_remove_one(struct pci_dev *pdev)
 {
 	int i;
@@ -407,15 +393,12 @@ static int pci200_pci_init_one(struct pci_dev *pdev,
 	return 0;
 }
 
-
-
 static const struct pci_device_id pci200_pci_tbl[] = {
 	{ PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050, PCI_VENDOR_ID_PLX,
 	  PCI_DEVICE_ID_PLX_PCI200SYN, 0, 0, 0 },
 	{ 0, }
 };
 
-
 static struct pci_driver pci200_pci_driver = {
 	.name		= "PCI200SYN",
 	.id_table	= pci200_pci_tbl,
@@ -423,7 +406,6 @@ static struct pci_driver pci200_pci_driver = {
 	.remove		= pci200_pci_remove_one,
 };
 
-
 static int __init pci200_init_module(void)
 {
 	if (pci_clock_freq < 1000000 || pci_clock_freq > 80000000) {
@@ -433,8 +415,6 @@ static int __init pci200_init_module(void)
 	return pci_register_driver(&pci200_pci_driver);
 }
 
-
-
 static void __exit pci200_cleanup_module(void)
 {
 	pci_unregister_driver(&pci200_pci_driver);
-- 
2.8.1

