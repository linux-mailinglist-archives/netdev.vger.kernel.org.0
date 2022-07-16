Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37EFE579FA4
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 15:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238674AbiGSN3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 09:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbiGSN2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 09:28:53 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7AD85D7B;
        Tue, 19 Jul 2022 05:44:49 -0700 (PDT)
X-QQ-mid: bizesmtp80t1658234669tvmn9k4g
Received: from localhost.localdomain ( [171.223.96.21])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 19 Jul 2022 20:44:28 +0800 (CST)
X-QQ-SSF: 01000000002000F0U000C00A0000020
X-QQ-FEAT: lp8jUtqYSiDDgkQ6htSAhHXw3R+JIE18hH5zqlPK4KEjAEkbcSMTUUpXlLBlp
        1H04iEJevQVxvvOG2uUdm3INJLdcB/5vGV7gddqeh9KiMIc6NCWxpLTYynf1ALOP3Cndi/g
        2jzMMAyILgRrkS98kyn6HL9yuQlOStyVu/n9TEd0CrNgKhe4IUzB49lDVFUWRf/rMnmWlVT
        7PzQWdUSygasBX45K/JNm3H3+Zl5DYUgEPwPVVTBF7F4l546oQdKiiPQz1TFQkKJ+ruUiXy
        LrZAkhDEfzJbvMgZf1reC+yQMtCat1GdGJfn5zJIqvg0aKJ1d6/yj4oysiL5yAoY9DqnXpg
        ndDWHkQcVn9aVAy2qavSNM6QPZ/degQAUZoGuEpChagYVVwz8an1Cpu8wibKTEJe2C12Ewu
        NDrjWmKaE+FO/8pq9WI+Mw==
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     matthieu.baerts@tessares.net
Cc:     mathew.j.martineau@linux.intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] mptcp: Fix comment typo
Date:   Sat, 16 Jul 2022 12:42:26 +0800
Message-Id: <20220716044226.43587-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_PASS,T_SPF_HELO_TEMPERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The double `the' is duplicated in the comment, remove one.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 net/mptcp/token.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/token.c b/net/mptcp/token.c
index f52ee7b26aed..68b822691e36 100644
--- a/net/mptcp/token.c
+++ b/net/mptcp/token.c
@@ -288,7 +288,7 @@ EXPORT_SYMBOL_GPL(mptcp_token_get_sock);
  * token container starting from the specified position, or NULL.
  *
  * On successful iteration, the iterator is move to the next position and the
- * the acquires a reference to the returned socket.
+ * acquires a reference to the returned socket.
  */
 struct mptcp_sock *mptcp_token_iter_next(const struct net *net, long *s_slot,
 					 long *s_num)
-- 
2.35.1

