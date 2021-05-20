Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED43389DA4
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 08:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbhETGXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 02:23:02 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3619 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbhETGW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 02:22:56 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Fm01x0fqQzmWx9;
        Thu, 20 May 2021 14:19:17 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 14:21:33 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 20 May 2021 14:21:33 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <j.vosburgh@gmail.com>, <vfalico@gmail.com>, <andy@greyhouse.net>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 4/4] net: bonding: use tabs instead of space for code indent
Date:   Thu, 20 May 2021 14:18:35 +0800
Message-ID: <1621491515-53459-5-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621491515-53459-1-git-send-email-huangguangbin2@huawei.com>
References: <1621491515-53459-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

Code indent should use tabs where possible, so
use tabs instead of space for code indent.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/bonding/bond_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
index f0f9138e967f..0561ece1ba45 100644
--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -598,7 +598,7 @@ static int bond_fill_info(struct sk_buff *skb,
 		goto nla_put_failure;
 
 	if (nla_put_u32(skb, IFLA_BOND_RESEND_IGMP,
-		        bond->params.resend_igmp))
+			bond->params.resend_igmp))
 		goto nla_put_failure;
 
 	if (nla_put_u8(skb, IFLA_BOND_NUM_PEER_NOTIF,
-- 
2.8.1

