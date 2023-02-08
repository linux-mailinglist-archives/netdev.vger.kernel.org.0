Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 889CA68E527
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 01:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjBHA4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 19:56:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjBHA4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 19:56:31 -0500
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA13E2A15E;
        Tue,  7 Feb 2023 16:56:30 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0Vb92B8B_1675817787;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0Vb92B8B_1675817787)
          by smtp.aliyun-inc.com;
          Wed, 08 Feb 2023 08:56:28 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, edumazet@google.com, razor@blackwall.org,
        roopa@nvidia.com, pabeni@redhat.com,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] net: bridge: clean up one inconsistent indenting
Date:   Wed,  8 Feb 2023 08:56:26 +0800
Message-Id: <20230208005626.56847-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

./net/bridge/br_netlink_tunnel.c:317:4-27: code aligned with following code on line 318

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3977
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 net/bridge/br_netlink_tunnel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_netlink_tunnel.c b/net/bridge/br_netlink_tunnel.c
index 17abf092f7ca..eff949bfdd83 100644
--- a/net/bridge/br_netlink_tunnel.c
+++ b/net/bridge/br_netlink_tunnel.c
@@ -315,7 +315,7 @@ int br_process_vlan_tunnel_info(const struct net_bridge *br,
 
 			if (curr_change)
 				*changed = curr_change;
-			 __vlan_tunnel_handle_range(p, &v_start, &v_end, v,
+			__vlan_tunnel_handle_range(p, &v_start, &v_end, v,
 						    curr_change);
 		}
 		if (v_start && v_end)
-- 
2.20.1.7.g153144c

