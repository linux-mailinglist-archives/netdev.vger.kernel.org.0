Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC0A1C50FF
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 10:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbgEEIqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 04:46:25 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3846 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728220AbgEEIqY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 04:46:24 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id ED478BB0EFFF13225343;
        Tue,  5 May 2020 16:46:13 +0800 (CST)
Received: from localhost (10.166.215.154) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Tue, 5 May 2020
 16:46:05 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <bfields@fieldses.org>, <chuck.lever@oracle.com>,
        <trond.myklebust@hammerspace.com>, <anna.schumaker@netapp.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-nfs@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] sunrpc: Remove unused function ip_map_update
Date:   Tue, 5 May 2020 16:45:37 +0800
Message-ID: <20200505084537.52372-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.166.215.154]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 49b28684fdba ("nfsd: Remove deprecated nfsctl system call and related code.")
left behind this, remove it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/sunrpc/svcauth_unix.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/net/sunrpc/svcauth_unix.c b/net/sunrpc/svcauth_unix.c
index 6c8f802c4261..97c0bddba7a3 100644
--- a/net/sunrpc/svcauth_unix.c
+++ b/net/sunrpc/svcauth_unix.c
@@ -332,15 +332,6 @@ static int __ip_map_update(struct cache_detail *cd, struct ip_map *ipm,
 	return 0;
 }
 
-static inline int ip_map_update(struct net *net, struct ip_map *ipm,
-		struct unix_domain *udom, time64_t expiry)
-{
-	struct sunrpc_net *sn;
-
-	sn = net_generic(net, sunrpc_net_id);
-	return __ip_map_update(sn->ip_map_cache, ipm, udom, expiry);
-}
-
 void svcauth_unix_purge(struct net *net)
 {
 	struct sunrpc_net *sn;
-- 
2.17.1


