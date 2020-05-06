Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A171C684E
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727871AbgEFGRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:17:11 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3808 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726495AbgEFGRK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 02:17:10 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 2F845A04B3344AC12140;
        Wed,  6 May 2020 14:17:05 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Wed, 6 May 2020
 14:16:55 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH net-next] net: bridge: return false in br_mrp_enabled()
Date:   Wed, 6 May 2020 14:16:16 +0800
Message-ID: <20200506061616.18929-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

net/bridge/br_private.h:1334:8-9: WARNING: return of 0/1 in function
'br_mrp_enabled' with return type bool

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 net/bridge/br_private.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index c35647cb138a..78d3a951180d 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1331,7 +1331,7 @@ static inline int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb)
 
 static inline bool br_mrp_enabled(struct net_bridge *br)
 {
-	return 0;
+	return false;
 }
 
 static inline void br_mrp_port_del(struct net_bridge *br,
-- 
2.21.1

