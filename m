Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36F703AB6AA
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 16:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233055AbhFQO7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 10:59:24 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7477 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbhFQO67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 10:58:59 -0400
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G5Q6m1GCwzZhrL;
        Thu, 17 Jun 2021 22:53:52 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 17 Jun 2021 22:56:48 +0800
From:   Peng Li <lipeng321@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 6/6] net: hostess_sv11: fix the alignment issue
Date:   Thu, 17 Jun 2021 22:53:35 +0800
Message-ID: <1623941615-26966-7-git-send-email-lipeng321@huawei.com>
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

Alignment should match open parenthesis.

Signed-off-by: Peng Li <lipeng321@huawei.com>
---
 drivers/net/wan/hostess_sv11.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wan/hostess_sv11.c b/drivers/net/wan/hostess_sv11.c
index 4085590..38c1a91 100644
--- a/drivers/net/wan/hostess_sv11.c
+++ b/drivers/net/wan/hostess_sv11.c
@@ -155,7 +155,7 @@ static int hostess_ioctl(struct net_device *d, struct ifreq *ifr, int cmd)
  */
 
 static netdev_tx_t hostess_queue_xmit(struct sk_buff *skb,
-					    struct net_device *d)
+				      struct net_device *d)
 {
 	return z8530_queue_xmit(&dev_to_sv(d)->chanA, skb);
 }
-- 
2.8.1

