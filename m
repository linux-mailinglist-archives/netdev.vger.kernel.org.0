Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C42263878D4
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 14:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349192AbhERMec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 08:34:32 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3585 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349178AbhERMeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 08:34:11 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FkwLj6pHvzsRnL;
        Tue, 18 May 2021 20:30:05 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
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
Subject: [PATCH net-next 2/5] net: wan: add some required spaces
Date:   Tue, 18 May 2021 20:29:51 +0800
Message-ID: <1621340994-20760-3-git-send-email-huangguangbin2@huawei.com>
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

Add space required before the open parenthesis '(',
and add spaces required around that '<', '>' and '!='.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/c101.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wan/c101.c b/drivers/net/wan/c101.c
index 215f2fbfc3ae..5a04f18db32a 100644
--- a/drivers/net/wan/c101.c
+++ b/drivers/net/wan/c101.c
@@ -70,7 +70,7 @@ typedef struct card_s {
 	u8 page;
 
 	struct card_s *next_card;
-}card_t;
+} card_t;
 
 typedef card_t port_t;
 
@@ -85,7 +85,7 @@ static card_t **new_card = &first_card;
 #define sca_outw(value, reg, card) do { \
 	writeb(value & 0xFF, (card)->win0base + C101_SCA + (reg)); \
 	writeb((value >> 8 ) & 0xFF, (card)->win0base + C101_SCA + (reg + 1));\
-} while(0)
+} while (0)
 
 #define port_to_card(port)	   (port)
 #define log_node(port)		   (0)
@@ -143,7 +143,7 @@ static void c101_set_iface(port_t *port)
 	u8 rxs = port->rxs & CLK_BRG_MASK;
 	u8 txs = port->txs & CLK_BRG_MASK;
 
-	switch(port->settings.clock_type) {
+	switch (port->settings.clock_type) {
 	case CLOCK_INT:
 		rxs |= CLK_BRG_RX; /* TX clock */
 		txs |= CLK_RXCLK_TX; /* BRG output */
@@ -229,7 +229,7 @@ static int c101_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	if (cmd != SIOCWANDEV)
 		return hdlc_ioctl(dev, ifr, cmd);
 
-	switch(ifr->ifr_settings.type) {
+	switch (ifr->ifr_settings.type) {
 	case IF_GET_IFACE:
 		ifr->ifr_settings.type = IF_IFACE_SYNC_SERIAL;
 		if (ifr->ifr_settings.size < size) {
@@ -241,7 +241,7 @@ static int c101_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		return 0;
 
 	case IF_IFACE_SYNC_SERIAL:
-		if(!capable(CAP_NET_ADMIN))
+		if (!capable(CAP_NET_ADMIN))
 			return -EPERM;
 
 		if (copy_from_user(&new_line, line, size))
@@ -296,12 +296,12 @@ static int __init c101_run(unsigned long irq, unsigned long winbase)
 	card_t *card;
 	int result;
 
-	if (irq<3 || irq>15 || irq == 6) /* FIXME */ {
+	if (irq < 3 || irq > 15 || irq == 6) /* FIXME */ {
 		pr_err("invalid IRQ value\n");
 		return -ENODEV;
 	}
 
-	if (winbase < 0xC0000 || winbase > 0xDFFFF || (winbase & 0x3FFF) !=0) {
+	if (winbase < 0xC0000 || winbase > 0xDFFFF || (winbase & 0x3FFF) != 0) {
 		pr_err("invalid RAM value\n");
 		return -ENODEV;
 	}
@@ -404,7 +404,7 @@ static int __init c101_init(void)
 
 		if (*hw == '\x0')
 			return first_card ? 0 : -EINVAL;
-	}while(*hw++ == ':');
+	} while (*hw++ == ':');
 
 	pr_err("invalid hardware parameters\n");
 	return first_card ? 0 : -EINVAL;
-- 
2.8.1

