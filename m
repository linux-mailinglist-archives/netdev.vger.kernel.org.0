Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6034F4DBD87
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 04:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbiCQDYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 23:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbiCQDYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 23:24:39 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFFD92C112
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 20:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1647487401; x=1679023401;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GdKBqBfgj+s1++P5Gcv4iaik7FS0Bdr2eLNuQnU5p5o=;
  b=lf+iLd53dDpy99RR9P9wKQVmpm9pKre9STdgfGDMNU1qe/xjVRVQajfN
   P8SJMHKIeF1gCDiIzn7Tc/zyJYhlxvlX9SwkiQEwkYBXpxDF0vCi0XE64
   Xyg1f89YOjYXx8TuaLvAR9CESRwi4NMXZKeLsrWvtXCh2SvQqvef/TCji
   0=;
X-IronPort-AV: E=Sophos;i="5.90,188,1643673600"; 
   d="scan'208";a="71600701"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-11a39b7d.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 17 Mar 2022 03:23:21 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-11a39b7d.us-west-2.amazon.com (Postfix) with ESMTPS id 638ED41F79;
        Thu, 17 Mar 2022 03:23:20 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Thu, 17 Mar 2022 03:23:17 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.124) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Thu, 17 Mar 2022 03:23:15 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH net-next] af_unix: Remove unnecessary brackets around CONFIG_AF_UNIX_OOB.
Date:   Thu, 17 Mar 2022 12:23:08 +0900
Message-ID: <20220317032308.65372-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.124]
X-ClientProxiedBy: EX13D22UWB001.ant.amazon.com (10.43.161.198) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's remove unnecessary brackets around CONFIG_AF_UNIX_OOB.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
This is a follow up patch from
https://lore.kernel.org/netdev/20220316194614.3e38cadc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/#t
---
 net/unix/af_unix.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 3e0d6281fd1e..4247c4134f31 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2049,7 +2049,7 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
  */
 #define UNIX_SKB_FRAGS_SZ (PAGE_SIZE << get_order(32768))
 
-#if (IS_ENABLED(CONFIG_AF_UNIX_OOB))
+#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
 static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other)
 {
 	struct unix_sock *ousk = unix_sk(other);
@@ -2115,7 +2115,7 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 
 	err = -EOPNOTSUPP;
 	if (msg->msg_flags & MSG_OOB) {
-#if (IS_ENABLED(CONFIG_AF_UNIX_OOB))
+#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
 		if (len)
 			len--;
 		else
@@ -2186,7 +2186,7 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 		sent += size;
 	}
 
-#if (IS_ENABLED(CONFIG_AF_UNIX_OOB))
+#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
 	if (msg->msg_flags & MSG_OOB) {
 		err = queue_oob(sock, msg, other);
 		if (err)
-- 
2.30.2

