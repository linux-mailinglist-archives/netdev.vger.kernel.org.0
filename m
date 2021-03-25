Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 439EB34893D
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 07:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhCYGhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 02:37:40 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14584 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbhCYGhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 02:37:07 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F5b216Gxtz19JCy;
        Thu, 25 Mar 2021 14:35:05 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.498.0; Thu, 25 Mar 2021
 14:37:02 +0800
From:   Lu Wei <luwei32@huawei.com>
To:     <idryomov@gmail.com>, <jlayton@kernel.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <ceph-devel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xiyou.wangcong@gmail.com>, <ap420073@gmail.com>,
        <linux-decnet-user@lists.sourceforge.net>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <olteanv@gmail.com>, <steffen.klassert@secunet.com>,
        <herbert@gondor.apana.org.au>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>
Subject: [PATCH -next 4/5] net: dsa: Fix a typo in tag_rtl4_a.c
Date:   Thu, 25 Mar 2021 14:38:24 +0800
Message-ID: <20210325063825.228167-5-luwei32@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210325063825.228167-1-luwei32@huawei.com>
References: <20210325063825.228167-1-luwei32@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify "Apparantly" to "Apparently" in net/dsa/tag_rtl4_a.c..

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Lu Wei <luwei32@huawei.com>
---
 net/dsa/tag_rtl4_a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_rtl4_a.c b/net/dsa/tag_rtl4_a.c
index e9176475bac8..cf8ac316f4c7 100644
--- a/net/dsa/tag_rtl4_a.c
+++ b/net/dsa/tag_rtl4_a.c
@@ -79,7 +79,7 @@ static struct sk_buff *rtl4a_tag_rcv(struct sk_buff *skb,
 
 	/* The RTL4 header has its own custom Ethertype 0x8899 and that
 	 * starts right at the beginning of the packet, after the src
-	 * ethernet addr. Apparantly skb->data always points 2 bytes in,
+	 * ethernet addr. Apparently skb->data always points 2 bytes in,
 	 * behind the Ethertype.
 	 */
 	tag = skb->data - 2;
-- 
2.17.1

