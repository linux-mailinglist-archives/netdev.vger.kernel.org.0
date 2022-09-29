Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A3C5EF2DB
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 11:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbiI2J5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 05:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235029AbiI2J5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 05:57:46 -0400
Received: from m15111.mail.126.com (m15111.mail.126.com [220.181.15.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1DF7A12CC85;
        Thu, 29 Sep 2022 02:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=/fY8K
        sB46XGI3QCAlksi/2qSFW9aNDiWxE4e9SWdPR8=; b=bImUZYreBQCFrNEwAjseg
        80r/VgjKLxMjxRCo0VwMYfuAGmN6+P7vUBm1k3BDCtwDgxqLu/HALS1vC12QY+H5
        ZoXR2eLG0FavGK7spmMPl8RKE2Tu1KnOCkr/OYct9pyBJy0kmuFGCzGV/Teko0qy
        leyd8eYpf8kRElh+vVn5dk=
Received: from localhost.localdomain (unknown [39.99.236.58])
        by smtp1 (Coremail) with SMTP id C8mowACnTnLsazVjoJjdCQ--.41508S2;
        Thu, 29 Sep 2022 17:57:01 +0800 (CST)
From:   Hongbin Wang <wh_bin@126.com>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH] seg6: Delete invalid code
Date:   Thu, 29 Sep 2022 05:56:49 -0400
Message-Id: <20220929095649.2764540-1-wh_bin@126.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: C8mowACnTnLsazVjoJjdCQ--.41508S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUznmRDUUUU
X-Originating-IP: [39.99.236.58]
X-CM-SenderInfo: xzkbuxbq6rjloofrz/1tbiHQ2LolpEHHNTZwAAs8
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

void function return statements are not generally useful

Signed-off-by: Hongbin Wang <wh_bin@126.com>
---
 net/ipv6/seg6_local.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index b7de5e46fdd8..a799ac83df3a 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -1830,8 +1830,6 @@ static void seg6_local_destroy_state(struct lwtunnel_state *lwt)
 	seg6_local_lwtunnel_destroy_state(slwt);
 
 	destroy_attrs(slwt);
-
-	return;
 }
 
 static int seg6_local_fill_encap(struct sk_buff *skb,
-- 
2.25.1

