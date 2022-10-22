Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB5DC608554
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 09:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbiJVHGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 03:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiJVHGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 03:06:01 -0400
Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.154.221.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4D02514D8;
        Sat, 22 Oct 2022 00:05:58 -0700 (PDT)
X-QQ-mid: bizesmtp66t1666422335tdg4ve7k
Received: from localhost.localdomain ( [182.148.15.254])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 22 Oct 2022 15:05:33 +0800 (CST)
X-QQ-SSF: 01000000000000C0E000000A0000000
X-QQ-FEAT: RFp2QSjOiS4sGX3HAs81Q2QTczxO4ZkgFMtpFaapn6fA4oCND6P3j/fp47kxt
        291qxxZRtD6dXgOXME4Q55/OSn2dEnfAGHIZVhafF8eBihENSLcXZWgY31Ytvh3y4ZqoWU5
        /5lLxsIYiwDqhrdwI1OiLgYMp6JQRhqfYDGspBZbY0A5/AtzaZVxSZDcMyKimastzpWi65m
        XppZM/NakT3q2vnFNOU+obvh9UmubpNV+17Kv/Wc2CTpuLuvsNdzMtN+nZzuE8jagX9TvsE
        Ltu/klACCgwo7MQhb4VRvnxbcv1StnfAgz2JRyhH6qTciXhSfWMSjbqVrjYURrvg7AOVpVK
        JofZOV8+kJ9UDXgh5ranmpgcRVkO0OCH+i6J9Zix8x8xnioTYFLfjfL67coiw==
X-QQ-GoodBg: 0
From:   wangjianli <wangjianli@cdjrlc.com>
To:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, wangjianli <wangjianli@cdjrlc.com>
Subject: [PATCH] net/mptcp: fix repeated words in comments
Date:   Sat, 22 Oct 2022 15:05:27 +0800
Message-Id: <20221022070527.55960-1-wangjianli@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr7
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'the'.

Signed-off-by: wangjianli <wangjianli@cdjrlc.com>
---
 net/mptcp/token.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/token.c b/net/mptcp/token.c
index f52ee7b26aed..b817c2564300 100644
--- a/net/mptcp/token.c
+++ b/net/mptcp/token.c
@@ -287,7 +287,7 @@ EXPORT_SYMBOL_GPL(mptcp_token_get_sock);
  * This function returns the first mptcp connection structure found inside the
  * token container starting from the specified position, or NULL.
  *
- * On successful iteration, the iterator is move to the next position and the
+ * On successful iteration, the iterator is move to the next position and
  * the acquires a reference to the returned socket.
  */
 struct mptcp_sock *mptcp_token_iter_next(const struct net *net, long *s_slot,
-- 
2.36.1

