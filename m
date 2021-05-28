Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3742393A2A
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 02:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235116AbhE1ARv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 20:17:51 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2442 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234649AbhE1ARa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 20:17:30 -0400
Received: from dggeml753-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FrlWf2TJ2z674v;
        Fri, 28 May 2021 08:13:02 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggeml753-chm.china.huawei.com (10.1.199.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 28 May 2021 08:15:55 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 28 May 2021 08:15:55 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH V2 net-next 10/10] net: hdlc_fr: remove unnecessary out of memory message
Date:   Fri, 28 May 2021 08:12:49 +0800
Message-ID: <1622160769-6678-11-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622160769-6678-1-git-send-email-huangguangbin2@huawei.com>
References: <1622160769-6678-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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
 drivers/net/wan/hdlc_fr.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index de7fbdc..72250fe 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -474,10 +474,9 @@ static void fr_lmi_send(struct net_device *dev, int fullrep)
 	}
 
 	skb = dev_alloc_skb(len);
-	if (!skb) {
-		netdev_warn(dev, "Memory squeeze on fr_lmi_send()\n");
+	if (!skb)
 		return;
-	}
+
 	memset(skb->data, 0, len);
 	skb_reserve(skb, 4);
 	if (lmi == LMI_CISCO)
-- 
2.8.1

