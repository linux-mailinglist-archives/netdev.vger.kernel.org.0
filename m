Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6795538BB50
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 03:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236275AbhEUBMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 21:12:44 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5708 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236065AbhEUBMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 21:12:39 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FmT405cFczqVWS;
        Fri, 21 May 2021 09:07:44 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 09:11:16 +0800
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
Subject: [PATCH net-next 6/6] net: wan: add necessary () to macro argument
Date:   Fri, 21 May 2021 09:08:17 +0800
Message-ID: <1621559297-9651-7-git-send-email-huangguangbin2@huawei.com>
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

Macro argument 'card' and 'port' may be better as
'(card)' and '(port)' to avoid precedence issues.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/hd64572.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wan/hd64572.c b/drivers/net/wan/hd64572.c
index 7fccf23c8bef..b89b03a6aba7 100644
--- a/drivers/net/wan/hd64572.c
+++ b/drivers/net/wan/hd64572.c
@@ -41,16 +41,16 @@
 
 #define NAPI_WEIGHT		16
 
-#define get_msci(port)	  (port->chan ?   MSCI1_OFFSET :   MSCI0_OFFSET)
-#define get_dmac_rx(port) (port->chan ? DMAC1RX_OFFSET : DMAC0RX_OFFSET)
-#define get_dmac_tx(port) (port->chan ? DMAC1TX_OFFSET : DMAC0TX_OFFSET)
-
-#define sca_in(reg, card)	     readb(card->scabase + (reg))
-#define sca_out(value, reg, card)    writeb(value, card->scabase + (reg))
-#define sca_inw(reg, card)	     readw(card->scabase + (reg))
-#define sca_outw(value, reg, card)   writew(value, card->scabase + (reg))
-#define sca_inl(reg, card)	     readl(card->scabase + (reg))
-#define sca_outl(value, reg, card)   writel(value, card->scabase + (reg))
+#define get_msci(port)	  ((port)->chan ?   MSCI1_OFFSET :   MSCI0_OFFSET)
+#define get_dmac_rx(port) ((port)->chan ? DMAC1RX_OFFSET : DMAC0RX_OFFSET)
+#define get_dmac_tx(port) ((port)->chan ? DMAC1TX_OFFSET : DMAC0TX_OFFSET)
+
+#define sca_in(reg, card)	     readb((card)->scabase + (reg))
+#define sca_out(value, reg, card)    writeb(value, (card)->scabase + (reg))
+#define sca_inw(reg, card)	     readw((card)->scabase + (reg))
+#define sca_outw(value, reg, card)   writew(value, (card)->scabase + (reg))
+#define sca_inl(reg, card)	     readl((card)->scabase + (reg))
+#define sca_outl(value, reg, card)   writel(value, (card)->scabase + (reg))
 
 static int sca_poll(struct napi_struct *napi, int budget);
 
-- 
2.8.1

