Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032C63A106F
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238233AbhFIJpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 05:45:18 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:5305 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238216AbhFIJpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 05:45:16 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G0MVD4yCxz1BK2c;
        Wed,  9 Jun 2021 17:38:12 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 17:43:04 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 9 Jun 2021 17:43:04 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 5/9] net: lapbether: remove unnecessary out of memory message
Date:   Wed, 9 Jun 2021 17:39:51 +0800
Message-ID: <1623231595-33851-6-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623231595-33851-1-git-send-email-huangguangbin2@huawei.com>
References: <1623231595-33851-1-git-send-email-huangguangbin2@huawei.com>
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

This patch removes unnecessary out of memory message,
to fix the following checkpatch.pl warning:
"WARNING: Possible unnecessary 'out of memory' message"

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/lapbether.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 169b323..705a898 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -266,10 +266,8 @@ static void lapbeth_connected(struct net_device *dev, int reason)
 	unsigned char *ptr;
 	struct sk_buff *skb = __dev_alloc_skb(1, GFP_ATOMIC | __GFP_NOMEMALLOC);
 
-	if (!skb) {
-		pr_err("out of memory\n");
+	if (!skb)
 		return;
-	}
 
 	ptr  = skb_put(skb, 1);
 	*ptr = X25_IFACE_CONNECT;
@@ -286,10 +284,8 @@ static void lapbeth_disconnected(struct net_device *dev, int reason)
 	unsigned char *ptr;
 	struct sk_buff *skb = __dev_alloc_skb(1, GFP_ATOMIC | __GFP_NOMEMALLOC);
 
-	if (!skb) {
-		pr_err("out of memory\n");
+	if (!skb)
 		return;
-	}
 
 	ptr  = skb_put(skb, 1);
 	*ptr = X25_IFACE_DISCONNECT;
-- 
2.8.1

