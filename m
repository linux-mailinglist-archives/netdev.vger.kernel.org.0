Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1369139B406
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 09:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhFDHhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 03:37:15 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3426 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbhFDHhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 03:37:06 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FxDxG55jJz6vGg;
        Fri,  4 Jun 2021 15:32:18 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 4 Jun 2021 15:35:18 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 4 Jun 2021 15:35:17 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 2/6] net: hdlc_x25: remove unnecessary out of memory message
Date:   Fri, 4 Jun 2021 15:32:08 +0800
Message-ID: <1622791932-49876-3-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622791932-49876-1-git-send-email-huangguangbin2@huawei.com>
References: <1622791932-49876-1-git-send-email-huangguangbin2@huawei.com>
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

This patch removes unnecessary out of memory message,
to fix the following checkpatch.pl warning:
"WARNING: Possible unnecessary 'out of memory' message"

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/hdlc_x25.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
index 86b88f2..525eb42 100644
--- a/drivers/net/wan/hdlc_x25.c
+++ b/drivers/net/wan/hdlc_x25.c
@@ -56,10 +56,8 @@ static void x25_connect_disconnect(struct net_device *dev, int reason, int code)
 	unsigned char *ptr;
 
 	skb = __dev_alloc_skb(1, GFP_ATOMIC | __GFP_NOMEMALLOC);
-	if (!skb) {
-		netdev_err(dev, "out of memory\n");
+	if (!skb)
 		return;
-	}
 
 	ptr = skb_put(skb, 1);
 	*ptr = code;
-- 
2.8.1

