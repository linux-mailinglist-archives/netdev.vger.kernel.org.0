Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B84A39DF17
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 16:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbhFGOta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 10:49:30 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3454 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbhFGOt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 10:49:29 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FzGNc1Pn3z6wnG;
        Mon,  7 Jun 2021 22:44:32 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 7 Jun 2021 22:47:32 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <kuba@kernel.org>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] ipv4: Fix spelling mistakes
Date:   Mon, 7 Jun 2021 23:01:09 +0800
Message-ID: <20210607150109.2856253-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix some spelling mistakes in comments:
Dont  ==> Don't
timout  ==> timeout
incomming  ==> incoming
necesarry  ==> necessary
substract  ==> subtract

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/ipv4/fib_lookup.h   | 2 +-
 net/ipv4/ipmr.c         | 4 ++--
 net/ipv4/tcp_fastopen.c | 2 +-
 net/ipv4/tcp_timer.c    | 4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/fib_lookup.h b/net/ipv4/fib_lookup.h
index b58db1ca4bfb..e184bcb19943 100644
--- a/net/ipv4/fib_lookup.h
+++ b/net/ipv4/fib_lookup.h
@@ -25,7 +25,7 @@ struct fib_alias {
 
 #define FA_S_ACCESSED	0x01
 
-/* Dont write on fa_state unless needed, to keep it shared on all cpus */
+/* Don't write on fa_state unless needed, to keep it shared on all cpus */
 static inline void fib_alias_accessed(struct fib_alias *fa)
 {
 	if (!(fa->fa_state & FA_S_ACCESSED))
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 939792a38814..b8a25cefc503 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1317,7 +1317,7 @@ static void mroute_clean_tables(struct mr_table *mrt, int flags)
 }
 
 /* called from ip_ra_control(), before an RCU grace period,
- * we dont need to call synchronize_rcu() here
+ * we don't need to call synchronize_rcu() here
  */
 static void mrtsock_destruct(struct sock *sk)
 {
@@ -1938,7 +1938,7 @@ static void ip_mr_forward(struct net *net, struct mr_table *mrt,
 	if (c->mfc_origin == htonl(INADDR_ANY) && true_vifi >= 0) {
 		struct mfc_cache *cache_proxy;
 
-		/* For an (*,G) entry, we only check that the incomming
+		/* For an (*,G) entry, we only check that the incoming
 		 * interface is part of the static tree.
 		 */
 		cache_proxy = mr_mfc_find_any_parent(mrt, vif);
diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index af2814c9342a..47c32604d38f 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -526,7 +526,7 @@ bool tcp_fastopen_active_should_disable(struct sock *sk)
 	if (!tfo_da_times)
 		return false;
 
-	/* Limit timout to max: 2^6 * initial timeout */
+	/* Limit timeout to max: 2^6 * initial timeout */
 	multiplier = 1 << min(tfo_da_times - 1, 6);
 	timeout = multiplier * tfo_bh_timeout * HZ;
 	if (time_before(jiffies, sock_net(sk)->ipv4.tfo_active_disable_stamp + timeout))
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 4ef08079ccfa..56b9d648f054 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -441,7 +441,7 @@ static void tcp_fastopen_synack_timer(struct sock *sk, struct request_sock *req)
  *  This function gets called when the kernel timer for a TCP packet
  *  of this socket expires.
  *
- *  It handles retransmission, timer adjustment and other necesarry measures.
+ *  It handles retransmission, timer adjustment and other necessary measures.
  *
  *  Returns: Nothing (void)
  */
@@ -766,7 +766,7 @@ static enum hrtimer_restart tcp_compressed_ack_kick(struct hrtimer *timer)
 	if (!sock_owned_by_user(sk)) {
 		if (tp->compressed_ack) {
 			/* Since we have to send one ack finally,
-			 * substract one from tp->compressed_ack to keep
+			 * subtract one from tp->compressed_ack to keep
 			 * LINUX_MIB_TCPACKCOMPRESSED accurate.
 			 */
 			tp->compressed_ack--;
-- 
2.25.1

