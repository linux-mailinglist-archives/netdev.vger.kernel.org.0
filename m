Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC5439555E
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 08:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbhEaGYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 02:24:21 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:6089 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbhEaGYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 02:24:20 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FtlWc3B58zYmv3;
        Mon, 31 May 2021 14:19:56 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 31 May 2021 14:22:37 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <santosh.shilimkar@oracle.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] rds: Fix spelling mistakes
Date:   Mon, 31 May 2021 14:36:17 +0800
Message-ID: <20210531063617.3018637-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix some spelling mistakes in comments:
alloced  ==> allocated

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/rds/ib_ring.c  | 2 +-
 net/rds/tcp_recv.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

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
2.25.1

