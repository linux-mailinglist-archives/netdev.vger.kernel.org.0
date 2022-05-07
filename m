Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F16AA51E3D9
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 05:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445461AbiEGDqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 23:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232700AbiEGDqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 23:46:22 -0400
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5C736152;
        Fri,  6 May 2022 20:42:36 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R251e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VCUhPF._1651894943;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VCUhPF._1651894943)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 07 May 2022 11:42:32 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     ralf@linux-mips.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] [NET] ROSE: Remove unused code and clean up some inconsistent indenting
Date:   Sat,  7 May 2022 11:42:07 +0800
Message-Id: <20220507034207.18651-1-jiapeng.chong@linux.alibaba.com>
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

Eliminate the follow smatch warning:

net/rose/rose_route.c:1136 rose_node_show() warn: inconsistent
indenting.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 net/rose/rose_route.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index e2e6b6b78578..fee6409c2bb3 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -1128,22 +1128,15 @@ static int rose_node_show(struct seq_file *seq, void *v)
 		seq_puts(seq, "address    mask n neigh neigh neigh\n");
 	else {
 		const struct rose_node *rose_node = v;
-		/* if (rose_node->loopback) {
-			seq_printf(seq, "%-10s %04d 1 loopback\n",
-				   rose2asc(rsbuf, &rose_node->address),
-				   rose_node->mask);
-		} else { */
-			seq_printf(seq, "%-10s %04d %d",
-				   rose2asc(rsbuf, &rose_node->address),
-				   rose_node->mask,
-				   rose_node->count);
-
-			for (i = 0; i < rose_node->count; i++)
-				seq_printf(seq, " %05d",
-					rose_node->neighbour[i]->number);
-
-			seq_puts(seq, "\n");
-		/* } */
+		seq_printf(seq, "%-10s %04d %d",
+			   rose2asc(rsbuf, &rose_node->address),
+			   rose_node->mask,
+			   rose_node->count);
+
+		for (i = 0; i < rose_node->count; i++)
+			seq_printf(seq, " %05d", rose_node->neighbour[i]->number);
+
+		seq_puts(seq, "\n");
 	}
 	return 0;
 }
-- 
2.20.1.7.g153144c

