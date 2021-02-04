Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E04030EAA5
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 04:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233660AbhBDDG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 22:06:56 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11677 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbhBDDG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 22:06:56 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DWNgj4ZWPzlGCn;
        Thu,  4 Feb 2021 11:04:33 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Thu, 4 Feb 2021 11:06:05 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: core: Remove extra spaces
Date:   Thu, 4 Feb 2021 11:06:39 +0800
Message-ID: <20210204030639.14965-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do codingstyle clean up to remove extra spaces.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/core/neighbour.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 9500d28a43b0..72ea94ec8c4a 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1618,7 +1618,7 @@ struct neigh_parms *neigh_parms_alloc(struct net_device *dev,
 
 	p = kmemdup(&tbl->parms, sizeof(*p), GFP_KERNEL);
 	if (p) {
-		p->tbl		  = tbl;
+		p->tbl = tbl;
 		refcount_set(&p->refcnt, 1);
 		p->reachable_time =
 				neigh_rand_reach_time(NEIGH_VAR(p, BASE_REACHABLE_TIME));
-- 
2.22.0

