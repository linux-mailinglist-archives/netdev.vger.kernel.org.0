Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8A9391687
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 13:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234511AbhEZLuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 07:50:23 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3951 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbhEZLta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 07:49:30 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Fqpz45WKfzCx3v;
        Wed, 26 May 2021 19:45:04 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 26 May 2021 19:47:57 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 26 May 2021 19:47:56 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 08/10] net: wan: add braces {} to all arms of the statement
Date:   Wed, 26 May 2021 19:44:53 +0800
Message-ID: <1622029495-30357-9-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622029495-30357-1-git-send-email-huangguangbin2@huawei.com>
References: <1622029495-30357-1-git-send-email-huangguangbin2@huawei.com>
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
 drivers/net/wan/hdlc_fr.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 77b4f65cc4e0..5c2a2ec6de5f 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -613,10 +613,10 @@ static void fr_timer(struct timer_list *t)
 		fr_set_link_state(reliable, dev);
 	}
 
-	if (state(hdlc)->settings.dce)
+	if (state(hdlc)->settings.dce) {
 		state(hdlc)->timer.expires = jiffies +
 			state(hdlc)->settings.t392 * HZ;
-	else {
+	} else {
 		if (state(hdlc)->n391cnt)
 			state(hdlc)->n391cnt--;
 
@@ -671,8 +671,9 @@ static int fr_lmi_recv(struct net_device *dev, struct sk_buff *skb)
 			return 1;
 		}
 		i = 7;
-	} else
+	} else {
 		i = 6;
+	}
 
 	if (skb->data[i] != (lmi == LMI_CCITT ? LMI_CCITT_REPTYPE :
 			     LMI_ANSI_CISCO_REPTYPE)) {
@@ -1013,8 +1014,9 @@ static void fr_start(struct net_device *dev)
 		/* First poll after 1 s */
 		state(hdlc)->timer.expires = jiffies + HZ;
 		add_timer(&state(hdlc)->timer);
-	} else
+	} else {
 		fr_set_link_state(1, dev);
+	}
 }
 
 static void fr_stop(struct net_device *dev)
-- 
2.8.1

