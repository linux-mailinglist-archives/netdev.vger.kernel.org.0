Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5906A45582B
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 10:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245221AbhKRJkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 04:40:55 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:57725 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243574AbhKRJkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 04:40:53 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UxAmxnk_1637228267;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UxAmxnk_1637228267)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 18 Nov 2021 17:37:51 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     trond.myklebust@hammerspace.com
Cc:     anna.schumaker@netapp.com, bfields@fieldses.org,
        chuck.lever@oracle.com, davem@davemloft.net, kuba@kernel.org,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] SUNRPC: clean up some inconsistent indenting
Date:   Thu, 18 Nov 2021 17:37:41 +0800
Message-Id: <1637228261-92684-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate the follow smatch warning:

net/sunrpc/xprtsock.c:1912 xs_local_connect() warn: inconsistent
indenting.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 net/sunrpc/xprtsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index ae48c9c..bbed23c 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1910,7 +1910,7 @@ static void xs_local_connect(struct rpc_xprt *xprt, struct rpc_task *task)
 	struct sock_xprt *transport = container_of(xprt, struct sock_xprt, xprt);
 	int ret;
 
-	 if (RPC_IS_ASYNC(task)) {
+	if (RPC_IS_ASYNC(task)) {
 		/*
 		 * We want the AF_LOCAL connect to be resolved in the
 		 * filesystem namespace of the process making the rpc
-- 
1.8.3.1

