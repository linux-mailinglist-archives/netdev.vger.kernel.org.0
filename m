Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1470269BF6
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 04:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbgIOCkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 22:40:17 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:37790 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726035AbgIOCkP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 22:40:15 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C8EA91997CCD5EA0F4FA;
        Tue, 15 Sep 2020 10:40:12 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Tue, 15 Sep 2020
 10:40:09 +0800
From:   Lu Wei <luwei32@huawei.com>
To:     <jmaloy@redhat.com>, <ying.xue@windriver.com>,
        <davem@davemloft.net>
CC:     <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <tipc-discussion@lists.sourceforge.net>
Subject: [PATCH] net: tipc: kerneldoc fixes
Date:   Tue, 15 Sep 2020 10:39:55 +0800
Message-ID: <20200915023955.331008-1-luwei32@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix parameter description of tipc_link_bc_create()

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 16ad3f4022bb ("tipc: introduce variable window congestion control")
Signed-off-by: Lu Wei <luwei32@huawei.com>
---
 net/tipc/link.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index b7362556da95..cef38a910107 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -532,7 +532,8 @@ bool tipc_link_create(struct net *net, char *if_name, int bearer_id,
  * tipc_link_bc_create - create new link to be used for broadcast
  * @net: pointer to associated network namespace
  * @mtu: mtu to be used initially if no peers
- * @window: send window to be used
+ * @min_win: minimal send window to be used by link
+ * @max_win: maximal send window to be used by link
  * @inputq: queue to put messages ready for delivery
  * @namedq: queue to put binding table update messages ready for delivery
  * @link: return value, pointer to put the created link
-- 
2.17.1

