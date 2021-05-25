Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E39F39039C
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 16:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233868AbhEYONZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 10:13:25 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5702 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233663AbhEYOMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 10:12:33 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FqGBb2qtrz1BQtB;
        Tue, 25 May 2021 22:08:07 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 25 May 2021 22:10:58 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 25 May 2021 22:10:58 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 1/6] net: wan: remove redundant blank lines
Date:   Tue, 25 May 2021 22:07:53 +0800
Message-ID: <1621951678-23466-2-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621951678-23466-1-git-send-email-huangguangbin2@huawei.com>
References: <1621951678-23466-1-git-send-email-huangguangbin2@huawei.com>
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
 drivers/net/wan/n2.c | 25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/drivers/net/wan/n2.c b/drivers/net/wan/n2.c
index 5bf4463873b1..dd39789ebfa0 100644
--- a/drivers/net/wan/n2.c
+++ b/drivers/net/wan/n2.c
@@ -32,7 +32,6 @@
 #include <asm/io.h>
 #include "hd64570.h"
 
-
 static const char* version = "SDL RISCom/N2 driver version: 1.15";
 static const char* devname = "RISCom/N2";
 
@@ -64,11 +63,9 @@ static char *hw;	/* pointer to hw=xxx command line string */
 #define PCR_ENWIN  4     /* Open window */
 #define PCR_BUS16  8     /* 16-bit bus */
 
-
 /* Memory Base Address Register */
 #define N2_BAR 2
 
-
 /* Page Scan Register  */
 #define N2_PSR 4
 #define WIN16K       0x00
@@ -78,7 +75,6 @@ static char *hw;	/* pointer to hw=xxx command line string */
 #define PSR_DMAEN    0x80
 #define PSR_PAGEBITS 0x0F
 
-
 /* Modem Control Reg */
 #define N2_MCR 6
 #define CLOCK_OUT_PORT1 0x80
@@ -90,7 +86,6 @@ static char *hw;	/* pointer to hw=xxx command line string */
 #define DTR_PORT1       0x02
 #define DTR_PORT0       0x01
 
-
 typedef struct port_s {
 	struct net_device *dev;
 	struct card_s *card;
@@ -108,8 +103,6 @@ typedef struct port_s {
 	u8 log_node;		/* logical port # */
 }port_t;
 
-
-
 typedef struct card_s {
 	u8 __iomem *winbase;		/* ISA window base address */
 	u32 phy_winbase;	/* ISA physical base address */
@@ -124,11 +117,9 @@ typedef struct card_s {
 	struct card_s *next_card;
 }card_t;
 
-
 static card_t *first_card;
 static card_t **new_card = &first_card;
 
-
 #define sca_reg(reg, card) (0x8000 | (card)->io | \
 			    ((reg) & 0x0F) | (((reg) & 0xF0) << 6))
 #define sca_in(reg, card)		inb(sca_reg(reg, card))
@@ -144,23 +135,19 @@ static card_t **new_card = &first_card;
 #define get_port(card, port)		((card)->ports[port].valid ? \
 					 &(card)->ports[port] : NULL)
 
-
 static __inline__ u8 sca_get_page(card_t *card)
 {
 	return inb(card->io + N2_PSR) & PSR_PAGEBITS;
 }
 
-
 static __inline__ void openwin(card_t *card, u8 page)
 {
 	u8 psr = inb(card->io + N2_PSR);
 	outb((psr & ~PSR_PAGEBITS) | page, card->io + N2_PSR);
 }
 
-
 #include "hd64570.c"
 
-
 static void n2_set_iface(port_t *port)
 {
 	card_t *card = port->card;
@@ -203,8 +190,6 @@ static void n2_set_iface(port_t *port)
 	sca_set_port(port);
 }
 
-
-
 static int n2_open(struct net_device *dev)
 {
 	port_t *port = dev_to_port(dev);
@@ -226,8 +211,6 @@ static int n2_open(struct net_device *dev)
 	return 0;
 }
 
-
-
 static int n2_close(struct net_device *dev)
 {
 	port_t *port = dev_to_port(dev);
@@ -241,8 +224,6 @@ static int n2_close(struct net_device *dev)
 	return 0;
 }
 
-
-
 static int n2_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
 	const size_t size = sizeof(sync_serial_settings);
@@ -295,8 +276,6 @@ static int n2_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	}
 }
 
-
-
 static void n2_destroy_card(card_t *card)
 {
 	int cnt;
@@ -486,8 +465,6 @@ static int __init n2_run(unsigned long io, unsigned long irq,
 	return 0;
 }
 
-
-
 static int __init n2_init(void)
 {
 	if (hw==NULL) {
@@ -539,7 +516,6 @@ static int __init n2_init(void)
 	return first_card ? 0 : -EINVAL;
 }
 
-
 static void __exit n2_cleanup(void)
 {
 	card_t *card = first_card;
@@ -551,7 +527,6 @@ static void __exit n2_cleanup(void)
 	}
 }
 
-
 module_init(n2_init);
 module_exit(n2_cleanup);
 
-- 
2.8.1

