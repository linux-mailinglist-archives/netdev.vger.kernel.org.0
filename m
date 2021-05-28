Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7BB8393A27
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 02:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236454AbhE1ARp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 20:17:45 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:2323 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234570AbhE1AR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 20:17:29 -0400
Received: from dggeml756-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FrlTf624Bz1BFXt;
        Fri, 28 May 2021 08:11:18 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggeml756-chm.china.huawei.com (10.1.199.158) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 28 May 2021 08:15:54 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 28 May 2021 08:15:53 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH V2 net-next 07/10] net: hdlc_fr: remove space after '!'
Date:   Fri, 28 May 2021 08:12:46 +0800
Message-ID: <1622160769-6678-8-git-send-email-huangguangbin2@huawei.com>
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

According to the chackpatch.pl, space prohibited after that '!'.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/hdlc_fr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index fa10eea..77b4f65 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -789,8 +789,8 @@ static int fr_lmi_recv(struct net_device *dev, struct sk_buff *skb)
 		}
 		i++;
 
-		new = !! (skb->data[i + 2] & 0x08);
-		active = !! (skb->data[i + 2] & 0x02);
+		new = !!(skb->data[i + 2] & 0x08);
+		active = !!(skb->data[i + 2] & 0x02);
 		if (lmi == LMI_CISCO) {
 			dlci = (skb->data[i] << 8) | skb->data[i + 1];
 			bw = (skb->data[i + 3] << 16) |
-- 
2.8.1

