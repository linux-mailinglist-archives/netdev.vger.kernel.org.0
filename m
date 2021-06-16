Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7246E3A93DE
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 09:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbhFPHat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 03:30:49 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:7299 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbhFPH3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 03:29:08 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G4c7r1lYbz1BN7h;
        Wed, 16 Jun 2021 15:22:00 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 15:26:55 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 15:26:55 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 15/15] net: cosa: remove redundant spaces
Date:   Wed, 16 Jun 2021 15:23:41 +0800
Message-ID: <1623828221-48349-16-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623828221-48349-1-git-send-email-huangguangbin2@huawei.com>
References: <1623828221-48349-1-git-send-email-huangguangbin2@huawei.com>
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

According to the chackpatch.pl,
no spaces is necessary at the start of a line,
no space is necessary after a cast.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/cosa.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index 79941b3..43caab0 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -976,7 +976,7 @@ static struct fasync_struct *fasync[256] = { NULL, };
 /* To be done ... */
 static int cosa_fasync(struct inode *inode, struct file *file, int on)
 {
-        int port = iminor(inode);
+	int port = iminor(inode);
 
 	return fasync_helper(inode, file, on, &fasync[port]);
 }
@@ -1338,7 +1338,7 @@ static void cosa_kick(struct cosa_data *cosa)
 	udelay(100);
 	cosa_putstatus(cosa, 0);
 	udelay(100);
-	(void) cosa_getdata8(cosa);
+	(void)cosa_getdata8(cosa);
 	udelay(100);
 	cosa_putdata8(cosa, 0);
 	udelay(100);
@@ -1739,7 +1739,7 @@ static inline void tx_interrupt(struct cosa_data *cosa, int status)
 #ifdef DEBUG_IO
 			debug_status_out(cosa, SR_TX_INT_ENA);
 			debug_data_out(cosa, ((cosa->txchan << 5) & 0xe0) |
-                                ((cosa->txsize >> 8) & 0x1f));
+				       ((cosa->txsize >> 8) & 0x1f));
 			debug_data_in(cosa, cosa_getdata8(cosa));
 #else
 			cosa_getdata8(cosa);
@@ -1762,8 +1762,8 @@ static inline void tx_interrupt(struct cosa_data *cosa, int status)
 			| (cosa->txsize & 0x1fff));
 #ifdef DEBUG_IO
 		debug_status_out(cosa, SR_TX_INT_ENA);
-		debug_data_out(cosa, ((cosa->txchan << 13) & 0xe000)
-                        | (cosa->txsize & 0x1fff));
+		debug_data_out(cosa, ((cosa->txchan << 13) & 0xe000) |
+			       (cosa->txsize & 0x1fff));
 		debug_data_in(cosa, cosa_getdata8(cosa));
 		debug_status_out(cosa, 0);
 #else
-- 
2.8.1

