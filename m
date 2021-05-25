Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1950839039A
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 16:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbhEYONN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 10:13:13 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:4006 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233744AbhEYOMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 10:12:32 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FqGCB5WjyzmbTn;
        Tue, 25 May 2021 22:08:38 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 25 May 2021 22:10:59 +0800
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
Subject: [PATCH net-next 4/6] net: wan: add some required spaces
Date:   Tue, 25 May 2021 22:07:56 +0800
Message-ID: <1621951678-23466-5-git-send-email-huangguangbin2@huawei.com>
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

Add space required after that close brace '}'.
Add space required before the open parenthesis '(' and '{'

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/n2.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wan/n2.c b/drivers/net/wan/n2.c
index 180fb2c9a442..2f602171cbc6 100644
--- a/drivers/net/wan/n2.c
+++ b/drivers/net/wan/n2.c
@@ -101,7 +101,7 @@ typedef struct port_s {
 	u8 rxs, txs, tmc;	/* SCA registers */
 	u8 phy_node;		/* physical port # - 0 or 1 */
 	u8 log_node;		/* logical port # */
-}port_t;
+} port_t;
 
 typedef struct card_s {
 	u8 __iomem *winbase;		/* ISA window base address */
@@ -115,7 +115,7 @@ typedef struct card_s {
 
 	port_t ports[2];
 	struct card_s *next_card;
-}card_t;
+} card_t;
 
 static card_t *first_card;
 static card_t **new_card = &first_card;
@@ -158,7 +158,7 @@ static void n2_set_iface(port_t *port)
 	u8 rxs = port->rxs & CLK_BRG_MASK;
 	u8 txs = port->txs & CLK_BRG_MASK;
 
-	switch(port->settings.clock_type) {
+	switch (port->settings.clock_type) {
 	case CLOCK_INT:
 		mcr |= port->phy_node ? CLOCK_OUT_PORT1 : CLOCK_OUT_PORT0;
 		rxs |= CLK_BRG_RX; /* BRG output */
@@ -241,7 +241,7 @@ static int n2_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	if (cmd != SIOCWANDEV)
 		return hdlc_ioctl(dev, ifr, cmd);
 
-	switch(ifr->ifr_settings.type) {
+	switch (ifr->ifr_settings.type) {
 	case IF_GET_IFACE:
 		ifr->ifr_settings.type = IF_IFACE_SYNC_SERIAL;
 		if (ifr->ifr_settings.size < size) {
@@ -253,7 +253,7 @@ static int n2_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		return 0;
 
 	case IF_IFACE_SYNC_SERIAL:
-		if(!capable(CAP_NET_ADMIN))
+		if (!capable(CAP_NET_ADMIN))
 			return -EPERM;
 
 		if (copy_from_user(&new_line, line, size))
@@ -494,7 +494,7 @@ static int __init n2_init(void)
 
 		if (*hw++ != ',')
 			break;
-		while(1) {
+		while (1) {
 			if (*hw == '0' && !valid[0])
 				valid[0] = 1; /* Port 0 enabled */
 			else if (*hw == '1' && !valid[1])
@@ -512,7 +512,7 @@ static int __init n2_init(void)
 
 		if (*hw == '\x0')
 			return first_card ? 0 : -EINVAL;
-	}while(*hw++ == ':');
+	} while (*hw++ == ':');
 
 	pr_err("invalid hardware parameters\n");
 	return first_card ? 0 : -EINVAL;
-- 
2.8.1

