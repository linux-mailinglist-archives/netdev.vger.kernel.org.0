Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD201B76B8
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 15:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgDXNOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 09:14:55 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:48482 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726301AbgDXNOy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 09:14:54 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3DDF3565A1EA18174230;
        Fri, 24 Apr 2020 21:14:50 +0800 (CST)
Received: from localhost (10.166.215.154) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Fri, 24 Apr 2020
 21:14:39 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <mareklindner@neomailbox.ch>, <sw@simonwunderlich.de>,
        <a@unstable.cc>, <sven@narfation.org>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <b.a.t.m.a.n@lists.open-mesh.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] batman-adv: remove unsued inline function batadv_arp_change_timeout
Date:   Fri, 24 Apr 2020 21:14:37 +0800
Message-ID: <20200424131437.48124-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.166.215.154]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's no callers in-tree.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/batman-adv/distributed-arp-table.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/batman-adv/distributed-arp-table.h b/net/batman-adv/distributed-arp-table.h
index 2bff2f4a325c..4e031661682a 100644
--- a/net/batman-adv/distributed-arp-table.h
+++ b/net/batman-adv/distributed-arp-table.h
@@ -163,11 +163,6 @@ static inline void batadv_dat_init_own_addr(struct batadv_priv *bat_priv,
 {
 }
 
-static inline void batadv_arp_change_timeout(struct net_device *soft_iface,
-					     const char *name)
-{
-}
-
 static inline int batadv_dat_init(struct batadv_priv *bat_priv)
 {
 	return 0;
-- 
2.17.1


