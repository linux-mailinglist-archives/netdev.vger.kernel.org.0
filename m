Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF92A156FCF
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 08:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbgBJHZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 02:25:01 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:47342 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726118AbgBJHZB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Feb 2020 02:25:01 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id BDF7FB350DFE91E5EC80;
        Mon, 10 Feb 2020 15:24:48 +0800 (CST)
Received: from euler.huawei.com (10.175.104.193) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Mon, 10 Feb 2020 15:24:40 +0800
From:   Chen Wandun <chenwandun@huawei.com>
To:     <bfields@fieldses.org>, <chuck.lever@oracle.com>,
        <trond.myklebust@hammerspace.com>, <Anna.Schumaker@Netapp.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-nfs@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <chenwandun@huawei.com>
Subject: [PATCH next] xprtrdma: make the symbol 'xprt_rdma_slot_table_entries' static
Date:   Mon, 10 Feb 2020 15:39:27 +0800
Message-ID: <20200210073927.8769-1-chenwandun@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.104.193]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following sparse warning:
net/sunrpc/xprtrdma/transport.c:71:14: warning: symbol 'xprt_rdma_slot_table_entries' was not declared. Should it be static?

Fixes: 86c4ccd9b92b ("xprtrdma: Eliminate struct rpcrdma_create_data_internal")
Signed-off-by: Chen Wandun <chenwandun@huawei.com>
---
 net/sunrpc/xprtrdma/transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 3cfeba68ee9a..14c2a852d2a1 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -68,7 +68,7 @@
  * tunables
  */
 
-unsigned int xprt_rdma_slot_table_entries = RPCRDMA_DEF_SLOT_TABLE;
+static unsigned int xprt_rdma_slot_table_entries = RPCRDMA_DEF_SLOT_TABLE;
 unsigned int xprt_rdma_max_inline_read = RPCRDMA_DEF_INLINE;
 unsigned int xprt_rdma_max_inline_write = RPCRDMA_DEF_INLINE;
 unsigned int xprt_rdma_memreg_strategy		= RPCRDMA_FRWR;
-- 
2.17.1

