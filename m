Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA8405574B7
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 10:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbiFWIBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 04:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbiFWIBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 04:01:50 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6059D47389;
        Thu, 23 Jun 2022 01:01:47 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id B521E1E80CCC;
        Thu, 23 Jun 2022 16:01:28 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Pa5kxhsLTUu4; Thu, 23 Jun 2022 16:01:26 +0800 (CST)
Received: from localhost.localdomain (unknown [112.64.61.33])
        (Authenticated sender: jiaming@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 5388D1E80C85;
        Thu, 23 Jun 2022 16:01:25 +0800 (CST)
From:   Zhang Jiaming <jiaming@nfschina.com>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        liqiong@nfschina.com, renyu@nfschina.com,
        Zhang Jiaming <jiaming@nfschina.com>
Subject: [PATCH] netfilter: Fix spelling mistake
Date:   Thu, 23 Jun 2022 16:01:41 +0800
Message-Id: <20220623080141.7567-1-jiaming@nfschina.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change 'succesful' to 'successful'.
Change 'transation' to 'transaction'.

Signed-off-by: Zhang Jiaming <jiaming@nfschina.com>
---
 net/netfilter/nft_set_bitmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_set_bitmap.c b/net/netfilter/nft_set_bitmap.c
index e7ae5914971e..96081ac8d2b4 100644
--- a/net/netfilter/nft_set_bitmap.c
+++ b/net/netfilter/nft_set_bitmap.c
@@ -21,7 +21,7 @@ struct nft_bitmap_elem {
  * the element state in the current and the future generation.
  *
  * An element can be in three states. The generation cursor is represented using
- * the ^ character, note that this cursor shifts on every succesful transaction.
+ * the ^ character, note that this cursor shifts on every successful transaction.
  * If no transaction is going on, we observe all elements are in the following
  * state:
  *
@@ -39,7 +39,7 @@ struct nft_bitmap_elem {
  * 10 = this element is active in the current generation and it becomes inactive
  * ^    in the next one. This happens when the element is deactivated but commit
  *      path has not yet been executed yet, so removal is still pending. On
- *      transation abortion, the next generation bit is reset to go back to
+ *      transaction abortion, the next generation bit is reset to go back to
  *      restore its previous state.
  */
 struct nft_bitmap {
-- 
2.25.1

