Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCB7354B5F
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 05:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243561AbhDFDr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 23:47:29 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:53289 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233639AbhDFDr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 23:47:28 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R371e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UUea06T_1617680821;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UUea06T_1617680821)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 06 Apr 2021 11:47:19 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     bfields@fieldses.org
Cc:     chuck.lever@oracle.com, trond.myklebust@hammerspace.com,
        anna.schumaker@netapp.com, davem@davemloft.net, kuba@kernel.org,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] sunrpc: Remove unused function ip_map_lookup
Date:   Tue,  6 Apr 2021 11:46:59 +0800
Message-Id: <1617680819-9058-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following clang warnings:

net/sunrpc/svcauth_unix.c:306:30: warning: unused function
'ip_map_lookup' [-Wunused-function].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 net/sunrpc/svcauth_unix.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/net/sunrpc/svcauth_unix.c b/net/sunrpc/svcauth_unix.c
index 97c0bdd..35b7966 100644
--- a/net/sunrpc/svcauth_unix.c
+++ b/net/sunrpc/svcauth_unix.c
@@ -303,15 +303,6 @@ static struct ip_map *__ip_map_lookup(struct cache_detail *cd, char *class,
 		return NULL;
 }
 
-static inline struct ip_map *ip_map_lookup(struct net *net, char *class,
-		struct in6_addr *addr)
-{
-	struct sunrpc_net *sn;
-
-	sn = net_generic(net, sunrpc_net_id);
-	return __ip_map_lookup(sn->ip_map_cache, class, addr);
-}
-
 static int __ip_map_update(struct cache_detail *cd, struct ip_map *ipm,
 		struct unix_domain *udom, time64_t expiry)
 {
-- 
1.8.3.1

