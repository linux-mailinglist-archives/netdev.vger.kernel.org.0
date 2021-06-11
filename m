Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D853A3A5E
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 05:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbhFKDlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 23:41:37 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3950 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbhFKDlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 23:41:31 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G1RMt5zg4z6w30;
        Fri, 11 Jun 2021 11:36:26 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 11:39:32 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 11 Jun 2021 11:39:31 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 1/8] net: pc300too: remove redundant blank lines
Date:   Fri, 11 Jun 2021 11:36:15 +0800
Message-ID: <1623382582-37854-2-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623382582-37854-1-git-send-email-huangguangbin2@huawei.com>
References: <1623382582-37854-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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
 drivers/net/wan/pc300too.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/net/wan/pc300too.c b/drivers/net/wan/pc300too.c
index 001fd37..5ccaec9 100644
--- a/drivers/net/wan/pc300too.c
+++ b/drivers/net/wan/pc300too.c
@@ -52,7 +52,6 @@ static unsigned int CLOCK_BASE;
 #define PC300_CHMEDIA_MASK(port) (0x00000020UL << ((port) * 3))
 #define PC300_CTYPE_MASK	 (0x00000800UL)
 
-
 enum { PC300_RSV = 1, PC300_X21, PC300_TE }; /* card types */
 
 /*
@@ -71,8 +70,6 @@ typedef struct {
 	u32 init_ctrl;		/* 50h : EEPROM ctrl, Init Ctrl, etc */
 }plx9050;
 
-
-
 typedef struct port_s {
 	struct napi_struct napi;
 	struct net_device *netdev;
@@ -90,8 +87,6 @@ typedef struct port_s {
 	u8 chan;		/* physical port # - 0 or 1 */
 }port_t;
 
-
-
 typedef struct card_s {
 	int type;		/* RSV, X21, etc. */
 	int n_ports;		/* 1 or 2 ports */
@@ -107,13 +102,11 @@ typedef struct card_s {
 	port_t ports[2];
 }card_t;
 
-
 #define get_port(card, port)	     ((port) < (card)->n_ports ? \
 					 (&(card)->ports[port]) : (NULL))
 
 #include "hd64572.c"
 
-
 static void pc300_set_iface(port_t *port)
 {
 	card_t *card = port->card;
@@ -162,8 +155,6 @@ static void pc300_set_iface(port_t *port)
 	}
 }
 
-
-
 static int pc300_open(struct net_device *dev)
 {
 	port_t *port = dev_to_port(dev);
@@ -177,8 +168,6 @@ static int pc300_open(struct net_device *dev)
 	return 0;
 }
 
-
-
 static int pc300_close(struct net_device *dev)
 {
 	sca_close(dev);
@@ -186,8 +175,6 @@ static int pc300_close(struct net_device *dev)
 	return 0;
 }
 
-
-
 static int pc300_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
 	const size_t size = sizeof(sync_serial_settings);
@@ -214,7 +201,6 @@ static int pc300_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		if (copy_to_user(line, &port->settings, size))
 			return -EFAULT;
 		return 0;
-
 	}
 
 	if (port->card->type == PC300_X21 &&
@@ -255,8 +241,6 @@ static int pc300_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	return 0;
 }
 
-
-
 static void pc300_pci_remove_one(struct pci_dev *pdev)
 {
 	int i;
@@ -472,8 +456,6 @@ static int pc300_pci_init_one(struct pci_dev *pdev,
 	return 0;
 }
 
-
-
 static const struct pci_device_id pc300_pci_tbl[] = {
 	{ PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_PC300_RX_1, PCI_ANY_ID,
 	  PCI_ANY_ID, 0, 0, 0 },
@@ -486,7 +468,6 @@ static const struct pci_device_id pc300_pci_tbl[] = {
 	{ 0, }
 };
 
-
 static struct pci_driver pc300_pci_driver = {
 	.name =          "PC300",
 	.id_table =      pc300_pci_tbl,
@@ -494,7 +475,6 @@ static struct pci_driver pc300_pci_driver = {
 	.remove =        pc300_pci_remove_one,
 };
 
-
 static int __init pc300_init_module(void)
 {
 	if (pci_clock_freq < 1000000 || pci_clock_freq > 80000000) {
@@ -511,8 +491,6 @@ static int __init pc300_init_module(void)
 	return pci_register_driver(&pc300_pci_driver);
 }
 
-
-
 static void __exit pc300_cleanup_module(void)
 {
 	pci_unregister_driver(&pc300_pci_driver);
-- 
2.8.1

