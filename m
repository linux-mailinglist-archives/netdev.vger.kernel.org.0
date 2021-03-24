Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A9934718F
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 07:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbhCXGWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 02:22:45 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:14859 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232492AbhCXGWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 02:22:40 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F4ylj6KGKz90Sr;
        Wed, 24 Mar 2021 14:20:33 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.498.0; Wed, 24 Mar 2021
 14:22:29 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <santosh.shilimkar@oracle.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <linux-rdma@vger.kernel.org>, <rds-devel@oss.oracle.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] rds: Fix some typos for rds
Date:   Wed, 24 Mar 2021 14:25:24 +0800
Message-ID: <20210324062524.14996-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/alloced/allocated/
s/synching/syncing/
s/connction/connection/
s/beween/between/

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 net/rds/ib_ring.c  | 2 +-
 net/rds/ib_send.c  | 2 +-
 net/rds/send.c     | 4 ++--
 net/rds/tcp_recv.c | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/rds/ib_ring.c b/net/rds/ib_ring.c
index ff97e8eda858..006b2e441418 100644
--- a/net/rds/ib_ring.c
+++ b/net/rds/ib_ring.c
@@ -141,7 +141,7 @@ int rds_ib_ring_low(struct rds_ib_work_ring *ring)
 }
 
 /*
- * returns the oldest alloced ring entry.  This will be the next one
+ * returns the oldest allocated ring entry.  This will be the next one
  * freed.  This can't be called if there are none allocated.
  */
 u32 rds_ib_ring_oldest(struct rds_ib_work_ring *ring)
diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
index 92b4a8689aae..0ad8c685621d 100644
--- a/net/rds/ib_send.c
+++ b/net/rds/ib_send.c
@@ -109,7 +109,7 @@ static void rds_ib_send_unmap_rdma(struct rds_ib_connection *ic,
 	 * Note: There's no need to explicitly sync any RDMA buffers using
 	 * ib_dma_sync_sg_for_cpu - the completion for the RDMA
 	 * operation itself unmapped the RDMA buffers, which takes care
-	 * of synching.
+	 * of syncing.
 	 */
 	rds_ib_send_complete(container_of(op, struct rds_message, rdma),
 			     wc_status, rds_rdma_send_complete);
diff --git a/net/rds/send.c b/net/rds/send.c
index 985d0b7713ac..ea6301c4001a 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -233,7 +233,7 @@ int rds_send_xmit(struct rds_conn_path *cp)
 		 * If not already working on one, grab the next message.
 		 *
 		 * cp_xmit_rm holds a ref while we're sending this message down
-		 * the connction.  We can use this ref while holding the
+		 * the connection.  We can use this ref while holding the
 		 * send_sem.. rds_send_reset() is serialized with it.
 		 */
 		if (!rm) {
@@ -1225,7 +1225,7 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 		}
 		/* If the socket is already bound to a link local address,
 		 * it can only send to peers on the same link.  But allow
-		 * communicating beween link local and non-link local address.
+		 * communicating between link local and non-link local address.
 		 */
 		if (scope_id != rs->rs_bound_scope_id) {
 			if (!scope_id) {
diff --git a/net/rds/tcp_recv.c b/net/rds/tcp_recv.c
index 42c5ff1eda95..f4ee13da90c7 100644
--- a/net/rds/tcp_recv.c
+++ b/net/rds/tcp_recv.c
@@ -177,7 +177,7 @@ static int rds_tcp_data_recv(read_descriptor_t *desc, struct sk_buff *skb,
 				goto out;
 			}
 			tc->t_tinc = tinc;
-			rdsdebug("alloced tinc %p\n", tinc);
+			rdsdebug("allocated tinc %p\n", tinc);
 			rds_inc_path_init(&tinc->ti_inc, cp,
 					  &cp->cp_conn->c_faddr);
 			tinc->ti_inc.i_rx_lat_trace[RDS_MSG_RX_HDR] =
-- 
2.17.1

