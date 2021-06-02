Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E73B139814C
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 08:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhFBGoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 02:44:01 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3504 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbhFBGny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 02:43:54 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Fvzs82LcNzYrXf;
        Wed,  2 Jun 2021 14:39:24 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 2 Jun 2021 14:42:07 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-decnet-user@lists.sourceforge.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] decnet: Fix spelling mistakes
Date:   Wed, 2 Jun 2021 14:55:44 +0800
Message-ID: <20210602065544.105734-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix some spelling mistakes in comments:
thats  ==> that's
serivce  ==> service
varience  ==> variance

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/decnet/dn_nsp_in.c  | 2 +-
 net/decnet/dn_nsp_out.c | 2 +-
 net/decnet/dn_route.c   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/decnet/dn_nsp_in.c b/net/decnet/dn_nsp_in.c
index 1a12912b88d6..7ab788f41a3f 100644
--- a/net/decnet/dn_nsp_in.c
+++ b/net/decnet/dn_nsp_in.c
@@ -870,7 +870,7 @@ int dn_nsp_backlog_rcv(struct sock *sk, struct sk_buff *skb)
 
 		/*
 		 * Read out ack data here, this applies equally
-		 * to data, other data, link serivce and both
+		 * to data, other data, link service and both
 		 * ack data and ack otherdata.
 		 */
 		dn_process_ack(sk, skb, other);
diff --git a/net/decnet/dn_nsp_out.c b/net/decnet/dn_nsp_out.c
index 00f2ed721ec1..eadc89583168 100644
--- a/net/decnet/dn_nsp_out.c
+++ b/net/decnet/dn_nsp_out.c
@@ -179,7 +179,7 @@ static void dn_nsp_rtt(struct sock *sk, long rtt)
 		scp->nsp_srtt = 1;
 
 	/*
-	 * Add new rtt varience to smoothed varience
+	 * Add new rtt variance to smoothed varience
 	 */
 	delta >>= 1;
 	rttvar += ((((delta>0)?(delta):(-delta)) - rttvar) >> 2);
diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
index 32b1bed8ae51..729d3de6020d 100644
--- a/net/decnet/dn_route.c
+++ b/net/decnet/dn_route.c
@@ -604,7 +604,7 @@ static int dn_route_rx_short(struct sk_buff *skb)
 static int dn_route_discard(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
 	/*
-	 * I know we drop the packet here, but thats considered success in
+	 * I know we drop the packet here, but that's considered success in
 	 * this case
 	 */
 	kfree_skb(skb);
-- 
2.25.1

