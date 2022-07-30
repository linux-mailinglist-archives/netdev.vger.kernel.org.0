Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47462585953
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 11:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbiG3JIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 05:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiG3JIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 05:08:17 -0400
Received: from mail-m973.mail.163.com (mail-m973.mail.163.com [123.126.97.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 232EA357EF;
        Sat, 30 Jul 2022 02:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=tcP2m
        m4DtplDocqbYqdu/vxCgy6tDyjtagLsytmyRzU=; b=mAAWN2NkWG2yssZj7wRN9
        aI9lflNHtzfEyGGT2pdtaZRfvCioneh9p/yWasAMlddv//UONMQoI2cx19Vnh9PO
        +Hpc0oUD8K/tDfOTM7pj2FsvZ1l/8taCrQu5Z3cNNNzDpCTGu27pZd3ojYmutHS8
        cbnEOQgQfp5VbrgOpKmXIA=
Received: from localhost.localdomain (unknown [123.58.221.99])
        by smtp3 (Coremail) with SMTP id G9xpCgCHs1yL9ORimkc0SQ--.24840S2;
        Sat, 30 Jul 2022 17:06:21 +0800 (CST)
From:   studentxswpy@163.com
To:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org
Cc:     Xie Shaowen <studentxswpy@163.com>,
        Hacash Robot <hacashRobot@santino.com>
Subject: [PATCH net-next] mptcp: Fix spelling mistakes and cleanup code
Date:   Sat, 30 Jul 2022 17:06:17 +0800
Message-Id: <20220730090617.3101386-1-studentxswpy@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: G9xpCgCHs1yL9ORimkc0SQ--.24840S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7KFW7Cr1DXr4kKw43Jr13Arb_yoW8WF1xpr
        W7Ka93GFs7JFWxXr4kAF4kZr9ruan8WFnakFyj9w1fArs8uryaq345KFW5ZrWUCrs5XFZx
        XrW2ga13Ca1DuaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j5Ma8UUUUU=
X-Originating-IP: [123.58.221.99]
X-CM-SenderInfo: xvwxvv5qw024ls16il2tof0z/xtbBEQ1OJFaEJ33FQgAAs5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie Shaowen <studentxswpy@163.com>

fix follow spelling misktakes:
	regarless ==> regardless
	interaces ==> interfaces

Reported-by: Hacash Robot <hacashRobot@santino.com>
Signed-off-by: Xie Shaowen <studentxswpy@163.com>
---
 net/mptcp/pm_netlink.c | 2 +-
 net/mptcp/subflow.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 7c7395b58944..5bdb559d5242 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1134,7 +1134,7 @@ void mptcp_pm_nl_subflow_chk_stale(const struct mptcp_sock *msk, struct sock *ss
 			}
 			unlock_sock_fast(ssk, slow);
 
-			/* always try to push the pending data regarless of re-injections:
+			/* always try to push the pending data regardless of re-injections:
 			 * we can possibly use backup subflows now, and subflow selection
 			 * is cheap under the msk socket lock
 			 */
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index af28f3b60389..901c763dcdbb 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1634,7 +1634,7 @@ int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
 	/* the newly created socket really belongs to the owning MPTCP master
 	 * socket, even if for additional subflows the allocation is performed
 	 * by a kernel workqueue. Adjust inode references, so that the
-	 * procfs/diag interaces really show this one belonging to the correct
+	 * procfs/diag interfaces really show this one belonging to the correct
 	 * user.
 	 */
 	SOCK_INODE(sf)->i_ino = SOCK_INODE(sk->sk_socket)->i_ino;
-- 
2.25.1

