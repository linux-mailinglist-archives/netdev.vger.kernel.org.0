Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1EF348935
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 07:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhCYGhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 02:37:41 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:14892 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbhCYGhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 02:37:07 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F5b2R5LTKzkfYB;
        Thu, 25 Mar 2021 14:35:27 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.498.0; Thu, 25 Mar 2021
 14:37:01 +0800
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
Subject: [PATCH -next 3/5] net: decnet: Fix a typo in dn_nsp_in.c
Date:   Thu, 25 Mar 2021 14:38:23 +0800
Message-ID: <20210325063825.228167-4-luwei32@huawei.com>
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

Modify "erronous" to "erroneous" in net/decnet/dn_nsp_in.c.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Lu Wei <luwei32@huawei.com>
---
 net/decnet/dn_nsp_in.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/decnet/dn_nsp_in.c b/net/decnet/dn_nsp_in.c
index c97bdca5ec30..1a12912b88d6 100644
--- a/net/decnet/dn_nsp_in.c
+++ b/net/decnet/dn_nsp_in.c
@@ -520,7 +520,7 @@ static void dn_nsp_linkservice(struct sock *sk, struct sk_buff *skb)
 	fcval = *ptr;
 
 	/*
-	 * Here we ignore erronous packets which should really
+	 * Here we ignore erroneous packets which should really
 	 * should cause a connection abort. It is not critical
 	 * for now though.
 	 */
-- 
2.17.1

