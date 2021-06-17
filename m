Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39F463AB6A5
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 16:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbhFQO7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 10:59:05 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5028 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbhFQO65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 10:58:57 -0400
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G5Q4K33QWzXgtG;
        Thu, 17 Jun 2021 22:51:45 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 17 Jun 2021 22:56:48 +0800
From:   Peng Li <lipeng321@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 4/6] net: hostess_sv11: fix the code style issue about switch and case
Date:   Thu, 17 Jun 2021 22:53:33 +0800
Message-ID: <1623941615-26966-5-git-send-email-lipeng321@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623941615-26966-1-git-send-email-lipeng321@huawei.com>
References: <1623941615-26966-1-git-send-email-lipeng321@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the chackpatch.pl,
switch and case should be at the same indent.

Signed-off-by: Peng Li <lipeng321@huawei.com>
---
 drivers/net/wan/hostess_sv11.c | 54 +++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wan/hostess_sv11.c b/drivers/net/wan/hostess_sv11.c
index 8914cdd..7a59d7e 100644
--- a/drivers/net/wan/hostess_sv11.c
+++ b/drivers/net/wan/hostess_sv11.c
@@ -85,15 +85,15 @@ static int hostess_open(struct net_device *d)
 	 *	Link layer up
 	 */
 	switch (dma) {
-		case 0:
-			err = z8530_sync_open(d, &sv11->chanA);
-			break;
-		case 1:
-			err = z8530_sync_dma_open(d, &sv11->chanA);
-			break;
-		case 2:
-			err = z8530_sync_txdma_open(d, &sv11->chanA);
-			break;
+	case 0:
+		err = z8530_sync_open(d, &sv11->chanA);
+		break;
+	case 1:
+		err = z8530_sync_dma_open(d, &sv11->chanA);
+		break;
+	case 2:
+		err = z8530_sync_txdma_open(d, &sv11->chanA);
+		break;
 	}
 
 	if (err)
@@ -102,15 +102,15 @@ static int hostess_open(struct net_device *d)
 	err = hdlc_open(d);
 	if (err) {
 		switch (dma) {
-			case 0:
-				z8530_sync_close(d, &sv11->chanA);
-				break;
-			case 1:
-				z8530_sync_dma_close(d, &sv11->chanA);
-				break;
-			case 2:
-				z8530_sync_txdma_close(d, &sv11->chanA);
-				break;
+		case 0:
+			z8530_sync_close(d, &sv11->chanA);
+			break;
+		case 1:
+			z8530_sync_dma_close(d, &sv11->chanA);
+			break;
+		case 2:
+			z8530_sync_txdma_close(d, &sv11->chanA);
+			break;
 		}
 		return err;
 	}
@@ -136,15 +136,15 @@ static int hostess_close(struct net_device *d)
 	netif_stop_queue(d);
 
 	switch (dma) {
-		case 0:
-			z8530_sync_close(d, &sv11->chanA);
-			break;
-		case 1:
-			z8530_sync_dma_close(d, &sv11->chanA);
-			break;
-		case 2:
-			z8530_sync_txdma_close(d, &sv11->chanA);
-			break;
+	case 0:
+		z8530_sync_close(d, &sv11->chanA);
+		break;
+	case 1:
+		z8530_sync_dma_close(d, &sv11->chanA);
+		break;
+	case 2:
+		z8530_sync_txdma_close(d, &sv11->chanA);
+		break;
 	}
 	return 0;
 }
-- 
2.8.1

