Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0131D39C686
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 09:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbhFEHIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 03:08:06 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7111 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbhFEHIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 03:08:05 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FxrFZ1gM5zYqHQ;
        Sat,  5 Jun 2021 15:03:30 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 15:03:35 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 5 Jun 2021 15:03:35 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 5/8] net: hd64570: add braces {} to all arms of the statement
Date:   Sat, 5 Jun 2021 15:00:26 +0800
Message-ID: <1622876429-47278-6-git-send-email-huangguangbin2@huawei.com>
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

Braces {} should be used on all arms of this statement.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/hd64570.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wan/hd64570.c b/drivers/net/wan/hd64570.c
index f02cce0..0297fbe 100644
--- a/drivers/net/wan/hd64570.c
+++ b/drivers/net/wan/hd64570.c
@@ -262,8 +262,9 @@ static inline void sca_rx(card_t *card, port_t *port, pkt_desc __iomem *desc,
 		memcpy_fromio(skb->data, winbase(card) + buff, maxlen);
 		openwin(card, page + 1);
 		memcpy_fromio(skb->data + maxlen, winbase(card), len - maxlen);
-	} else
+	} else {
 		memcpy_fromio(skb->data, winbase(card) + buff, len);
+	}
 
 #ifndef PAGE0_ALWAYS_MAPPED
 	openwin(card, 0);	/* select pkt_desc table page back */
@@ -318,8 +319,9 @@ static inline void sca_rx_intr(port_t *port)
 				dev->stats.rx_crc_errors++;
 			if (stat & ST_RX_EOM)
 				port->rxpart = 0; /* received last fragment */
-		} else
+		} else {
 			sca_rx(card, port, desc, port->rxin);
+		}
 
 		/* Set new error descriptor address */
 		sca_outw(desc_off, dmac + EDAL, card);
@@ -417,8 +419,9 @@ static void sca_set_port(port_t *port)
 			tmc = 1;
 			br = 0;	/* For baud=CLOCK_BASE we use tmc=1 br=0 */
 			brv = 1;
-		} else if (tmc > 255)
+		} else if (tmc > 255) {
 			tmc = 256; /* tmc=0 means 256 - low baud rates */
+		}
 
 		port->settings.clock_rate = CLOCK_BASE / brv / tmc;
 	} else {
@@ -651,8 +654,9 @@ static netdev_tx_t sca_xmit(struct sk_buff *skb, struct net_device *dev)
 		memcpy_toio(winbase(card) + buff, skb->data, maxlen);
 		openwin(card, page + 1);
 		memcpy_toio(winbase(card), skb->data + maxlen, len - maxlen);
-	} else
+	} else {
 		memcpy_toio(winbase(card) + buff, skb->data, len);
+	}
 
 #ifndef PAGE0_ALWAYS_MAPPED
 	openwin(card, 0);	/* select pkt_desc table page back */
-- 
2.8.1

