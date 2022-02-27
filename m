Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2FDB4C5B4E
	for <lists+netdev@lfdr.de>; Sun, 27 Feb 2022 14:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbiB0NWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 08:22:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbiB0NWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 08:22:50 -0500
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07D86D4D1;
        Sun, 27 Feb 2022 05:22:13 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V5b5Y24_1645968129;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0V5b5Y24_1645968129)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 27 Feb 2022 21:22:10 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     pshelar@ovn.org
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] net: openvswitch: remove unneeded semicolon
Date:   Sun, 27 Feb 2022 21:22:08 +0800
Message-Id: <20220227132208.24658-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate the following coccicheck warning:
./net/openvswitch/flow.c:379:2-3: Unneeded semicolon

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 net/openvswitch/flow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index 8df73d86b968..372bf54a0ca9 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -376,7 +376,7 @@ static void get_ipv6_ext_hdrs(struct sk_buff *skb, struct ipv6hdr *nh,
 			break;
 		next_type = hp->nexthdr;
 		start += ipv6_optlen(hp);
-	};
+	}
 }
 
 static int parse_ipv6hdr(struct sk_buff *skb, struct sw_flow_key *key)
-- 
2.20.1.7.g153144c

