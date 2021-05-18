Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45CF3878C9
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 14:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349146AbhERMeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 08:34:15 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4662 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349175AbhERMeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 08:34:11 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FkwLj4dr9z16QXL;
        Tue, 18 May 2021 20:30:05 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 18 May 2021 20:32:50 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 18 May 2021 20:32:50 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 1/5] net: wan: remove redundant blank lines
Date:   Tue, 18 May 2021 20:29:50 +0800
Message-ID: <1621340994-20760-2-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621340994-20760-1-git-send-email-huangguangbin2@huawei.com>
References: <1621340994-20760-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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
 drivers/net/wan/c101.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/net/wan/c101.c b/drivers/net/wan/c101.c
index c354a5143e99..215f2fbfc3ae 100644
--- a/drivers/net/wan/c101.c
+++ b/drivers/net/wan/c101.c
@@ -28,7 +28,6 @@
 
 #include "hd64570.h"
 
-
 static const char* version = "Moxa C101 driver version: 1.15";
 static const char* devname = "C101";
 
@@ -51,7 +50,6 @@ static const char* devname = "C101";
 
 static char *hw;		/* pointer to hw=xxx command line string */
 
-
 typedef struct card_s {
 	struct net_device *dev;
 	spinlock_t lock;	/* TX lock */
@@ -79,7 +77,6 @@ typedef card_t port_t;
 static card_t *first_card;
 static card_t **new_card = &first_card;
 
-
 #define sca_in(reg, card)	   readb((card)->win0base + C101_SCA + (reg))
 #define sca_out(value, reg, card)  writeb(value, (card)->win0base + C101_SCA + (reg))
 #define sca_inw(reg, card)	   readw((card)->win0base + C101_SCA + (reg))
@@ -99,7 +96,6 @@ static card_t **new_card = &first_card;
 #define get_port(card, port)	   (card)
 static void sca_msci_intr(port_t *port);
 
-
 static inline u8 sca_get_page(card_t *card)
 {
 	return card->page;
@@ -111,10 +107,8 @@ static inline void openwin(card_t *card, u8 page)
 	writeb(page, card->win0base + C101_PAGE);
 }
 
-
 #include "hd64570.c"
 
-
 static inline void set_carrier(port_t *port)
 {
 	if (!(sca_in(MSCI1_OFFSET + ST3, port) & ST3_DCD))
@@ -123,7 +117,6 @@ static inline void set_carrier(port_t *port)
 		netif_carrier_off(port_to_dev(port));
 }
 
-
 static void sca_msci_intr(port_t *port)
 {
 	u8 stat = sca_in(MSCI0_OFFSET + ST1, port); /* read MSCI ST1 status */
@@ -145,7 +138,6 @@ static void sca_msci_intr(port_t *port)
 		set_carrier(port);
 }
 
-
 static void c101_set_iface(port_t *port)
 {
 	u8 rxs = port->rxs & CLK_BRG_MASK;
@@ -179,7 +171,6 @@ static void c101_set_iface(port_t *port)
 	sca_set_port(port);
 }
 
-
 static int c101_open(struct net_device *dev)
 {
 	port_t *port = dev_to_port(dev);
@@ -206,7 +197,6 @@ static int c101_open(struct net_device *dev)
 	return 0;
 }
 
-
 static int c101_close(struct net_device *dev)
 {
 	port_t *port = dev_to_port(dev);
@@ -218,7 +208,6 @@ static int c101_close(struct net_device *dev)
 	return 0;
 }
 
-
 static int c101_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
 	const size_t size = sizeof(sync_serial_settings);
@@ -276,8 +265,6 @@ static int c101_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	}
 }
 
-
-
 static void c101_destroy_card(card_t *card)
 {
 	readb(card->win0base + C101_PAGE); /* Resets SCA? */
@@ -392,8 +379,6 @@ static int __init c101_run(unsigned long irq, unsigned long winbase)
 	return 0;
 }
 
-
-
 static int __init c101_init(void)
 {
 	if (hw == NULL) {
@@ -425,7 +410,6 @@ static int __init c101_init(void)
 	return first_card ? 0 : -EINVAL;
 }
 
-
 static void __exit c101_cleanup(void)
 {
 	card_t *card = first_card;
@@ -438,7 +422,6 @@ static void __exit c101_cleanup(void)
 	}
 }
 
-
 module_init(c101_init);
 module_exit(c101_cleanup);
 
-- 
2.8.1

