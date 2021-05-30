Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06923394FCF
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 08:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhE3G3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 02:29:33 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3474 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbhE3G3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 02:29:19 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Ft7gt35SZzYrwn;
        Sun, 30 May 2021 14:24:58 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sun, 30 May 2021 14:27:40 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sun, 30 May 2021 14:27:40 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 07/10] net: sealevel: fix a code style issue about switch and case
Date:   Sun, 30 May 2021 14:24:31 +0800
Message-ID: <1622355874-18933-8-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622355874-18933-1-git-send-email-huangguangbin2@huawei.com>
References: <1622355874-18933-1-git-send-email-huangguangbin2@huawei.com>
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

According to the chackpatch.pl, switch and case should be
at the same indent.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/sealevel.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wan/sealevel.c b/drivers/net/wan/sealevel.c
index d19e9024865f..e07309e0d971 100644
--- a/drivers/net/wan/sealevel.c
+++ b/drivers/net/wan/sealevel.c
@@ -79,12 +79,12 @@ static int sealevel_open(struct net_device *d)
 	 */
 
 	switch (unit) {
-		case 0:
-			err = z8530_sync_dma_open(d, slvl->chan);
-			break;
-		case 1:
-			err = z8530_sync_open(d, slvl->chan);
-			break;
+	case 0:
+		err = z8530_sync_dma_open(d, slvl->chan);
+		break;
+	case 1:
+		err = z8530_sync_open(d, slvl->chan);
+		break;
 	}
 
 	if (err)
@@ -93,12 +93,12 @@ static int sealevel_open(struct net_device *d)
 	err = hdlc_open(d);
 	if (err) {
 		switch (unit) {
-			case 0:
-				z8530_sync_dma_close(d, slvl->chan);
-				break;
-			case 1:
-				z8530_sync_close(d, slvl->chan);
-				break;
+		case 0:
+			z8530_sync_dma_close(d, slvl->chan);
+			break;
+		case 1:
+			z8530_sync_close(d, slvl->chan);
+			break;
 		}
 		return err;
 	}
@@ -127,12 +127,12 @@ static int sealevel_close(struct net_device *d)
 	netif_stop_queue(d);
 
 	switch (unit) {
-		case 0:
-			z8530_sync_dma_close(d, slvl->chan);
-			break;
-		case 1:
-			z8530_sync_close(d, slvl->chan);
-			break;
+	case 0:
+		z8530_sync_dma_close(d, slvl->chan);
+		break;
+	case 1:
+		z8530_sync_close(d, slvl->chan);
+		break;
 	}
 	return 0;
 }
-- 
2.8.1

