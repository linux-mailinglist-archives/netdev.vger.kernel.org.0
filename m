Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF16220259
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 04:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgGOCbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 22:31:36 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:52448 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726933AbgGOCbg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 22:31:36 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 663955E75DFDB15AD290;
        Wed, 15 Jul 2020 10:31:33 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Wed, 15 Jul 2020
 10:31:24 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <yuehaibing@huawei.com>,
        <fw@strlen.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: flow: Remove unused inline function
Date:   Wed, 15 Jul 2020 10:31:19 +0800
Message-ID: <20200715023119.22108-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is not used since commit 09c7570480f7 ("xfrm: remove flow cache")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 include/net/flow.h | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/include/net/flow.h b/include/net/flow.h
index a50fb77a0b27..929d3ca614d0 100644
--- a/include/net/flow.h
+++ b/include/net/flow.h
@@ -204,24 +204,6 @@ static inline struct flowi *flowidn_to_flowi(struct flowidn *fldn)
 	return container_of(fldn, struct flowi, u.dn);
 }
 
-typedef unsigned long flow_compare_t;
-
-static inline unsigned int flow_key_size(u16 family)
-{
-	switch (family) {
-	case AF_INET:
-		BUILD_BUG_ON(sizeof(struct flowi4) % sizeof(flow_compare_t));
-		return sizeof(struct flowi4) / sizeof(flow_compare_t);
-	case AF_INET6:
-		BUILD_BUG_ON(sizeof(struct flowi6) % sizeof(flow_compare_t));
-		return sizeof(struct flowi6) / sizeof(flow_compare_t);
-	case AF_DECnet:
-		BUILD_BUG_ON(sizeof(struct flowidn) % sizeof(flow_compare_t));
-		return sizeof(struct flowidn) / sizeof(flow_compare_t);
-	}
-	return 0;
-}
-
 __u32 __get_hash_from_flowi6(const struct flowi6 *fl6, struct flow_keys *keys);
 
 #endif
-- 
2.17.1


