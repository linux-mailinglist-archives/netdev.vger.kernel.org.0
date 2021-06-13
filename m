Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7023A56E4
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 09:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbhFMHnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 03:43:41 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:4055 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbhFMHnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 03:43:37 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G2mc52frzzWr0x;
        Sun, 13 Jun 2021 15:36:37 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sun, 13 Jun 2021 15:41:34 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sun, 13 Jun 2021 15:41:34 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 02/11] net: z85230: add blank line after declarations
Date:   Sun, 13 Jun 2021 15:38:14 +0800
Message-ID: <1623569903-47930-3-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623569903-47930-1-git-send-email-huangguangbin2@huawei.com>
References: <1623569903-47930-1-git-send-email-huangguangbin2@huawei.com>
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

This patch fixes the checkpatch error about missing a blank line
after declarations.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/z85230.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wan/z85230.c b/drivers/net/wan/z85230.c
index f074cb1..3036d58 100644
--- a/drivers/net/wan/z85230.c
+++ b/drivers/net/wan/z85230.c
@@ -74,6 +74,7 @@
 static inline int z8530_read_port(unsigned long p)
 {
 	u8 r=inb(Z8530_PORT_OF(p));
+
 	if(p&Z8530_PORT_SLEEP)	/* gcc should figure this out efficiently ! */
 		udelay(5);
 	return r;
@@ -133,6 +134,7 @@ static inline u8 read_zsreg(struct z8530_channel *c, u8 reg)
 static inline u8 read_zsdata(struct z8530_channel *c)
 {
 	u8 r;
+
 	r=z8530_read_port(c->dataio);
 	return r;
 }
@@ -653,6 +655,7 @@ static void z8530_tx_clear(struct z8530_channel *c)
 static void z8530_status_clear(struct z8530_channel *chan)
 {
 	u8 status=read_zsreg(chan, R0);
+
 	if(status&TxEOM)
 		write_zsctrl(chan, ERR_RES);
 	write_zsctrl(chan, RES_EXT_INT);
@@ -1360,6 +1363,7 @@ int z8530_channel_load(struct z8530_channel *c, u8 *rtable)
 	while(*rtable!=255)
 	{
 		int reg=*rtable++;
+
 		if(reg>0x0F)
 			write_zsreg(c, R15, c->regs[15]|1);
 		write_zsreg(c, reg&0x0F, *rtable);
@@ -1401,6 +1405,7 @@ EXPORT_SYMBOL(z8530_channel_load);
 static void z8530_tx_begin(struct z8530_channel *c)
 {
 	unsigned long flags;
+
 	if(c->tx_skb)
 		return;
 		
@@ -1672,6 +1677,7 @@ static void z8530_rx_done(struct z8530_channel *c)
 static inline int spans_boundary(struct sk_buff *skb)
 {
 	unsigned long a=(unsigned long)skb->data;
+
 	a^=(a+skb->len);
 	if(a&0x00010000)	/* If the 64K bit is different.. */
 		return 1;
-- 
2.8.1

