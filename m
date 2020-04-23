Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552031B551F
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 09:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgDWHER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 03:04:17 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2838 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726679AbgDWHEQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 03:04:16 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 5D3BC9A1978D68F7FC4D;
        Thu, 23 Apr 2020 15:04:11 +0800 (CST)
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Thu, 23 Apr 2020 15:04:03 +0800
From:   Zou Wei <zou_wei@huawei.com>
To:     <trond.myklebust@hammerspace.com>, <anna.schumaker@netapp.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <bfields@fieldses.org>,
        <chuck.lever@oracle.com>
CC:     <linux-nfs@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Zou Wei <zou_wei@huawei.com>
Subject: [PATCH -next] xprtrdma: Make xprt_rdma_slot_table_entries static
Date:   Thu, 23 Apr 2020 15:10:02 +0800
Message-ID: <1587625802-97494-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following sparse warning:

net/sunrpc/xprtrdma/transport.c:71:14: warning: symbol 'xprt_rdma_slot_table_entries'
was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
---
 net/sunrpc/xprtrdma/transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 659da37..9f2e8f5 100644
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
2.6.2

