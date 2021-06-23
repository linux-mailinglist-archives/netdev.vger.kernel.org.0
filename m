Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 193AA3B1128
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 02:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhFWAzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 20:55:45 -0400
Received: from m12-11.163.com ([220.181.12.11]:49309 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229751AbhFWAzp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 20:55:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=riv/d
        1fiZZvZXSAHNlPrcNY0KX3T2Arv+m2otWF3/Rw=; b=bmK6Kw6kLWbGKhP6uiiOb
        plTFSAEH9GsiuAzisBhhGQGeY+hQi/5R4lx/xaC+yPtqChaKFMKW0ZT9+va/GQPO
        jWg9FJRjriqMvskWBC3VnG7/WDeg3awmjdzd0GMY0z/HIP28+EQYo8mkCCYOxH+f
        GrDlrBJ0lecBRk31vNzxFQ=
Received: from ubuntu.localdomain (unknown [218.17.89.92])
        by smtp7 (Coremail) with SMTP id C8CowABHVn72hdJg0WmrjQ--.23263S2;
        Wed, 23 Jun 2021 08:53:11 +0800 (CST)
From:   13145886936@163.com
To:     roopa@nvidia.com, nikolay@nvidia.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gushengxian <gushengxian@yulong.com>
Subject: [PATCH] net: bridge: remove redundant return
Date:   Tue, 22 Jun 2021 17:53:07 -0700
Message-Id: <20210623005307.6215-1-13145886936@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: C8CowABHVn72hdJg0WmrjQ--.23263S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7JrWUJFyrAw17tFWrJw4UCFg_yoWkAwbEv3
        s5ZrWI93yUXr92yrnrCw4qvF1rta1xur18CFnIgFW7trZ5Ar4Ig3WDJrs8trsFkw1xuFyU
        Ar9YkFZIvr13KjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5FYLPUUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5zrdx5xxdq6xppld0qqrwthudrp/xtbBdhe6g1UMRWteoQAAsQ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: gushengxian <gushengxian@yulong.com>

Return statements are not needed in Void function.

Signed-off-by: gushengxian <gushengxian@yulong.com>
---
 net/bridge/br_netlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 8642e56059fb..b70075939721 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -619,7 +619,7 @@ void br_ifinfo_notify(int event, const struct net_bridge *br,
 {
 	u32 filter = RTEXT_FILTER_BRVLAN_COMPRESSED;
 
-	return br_info_notify(event, br, port, filter);
+	br_info_notify(event, br, port, filter);
 }
 
 /*
@@ -814,7 +814,7 @@ static const struct nla_policy br_port_policy[IFLA_BRPORT_MAX + 1] = {
 	[IFLA_BRPORT_MODE]	= { .type = NLA_U8 },
 	[IFLA_BRPORT_GUARD]	= { .type = NLA_U8 },
 	[IFLA_BRPORT_PROTECT]	= { .type = NLA_U8 },
-	[IFLA_BRPORT_FAST_LEAVE]= { .type = NLA_U8 },
+	[IFLA_BRPORT_FAST_LEAVE] = { .type = NLA_U8 },
 	[IFLA_BRPORT_LEARNING]	= { .type = NLA_U8 },
 	[IFLA_BRPORT_UNICAST_FLOOD] = { .type = NLA_U8 },
 	[IFLA_BRPORT_PROXYARP]	= { .type = NLA_U8 },
-- 
2.25.1

