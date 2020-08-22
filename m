Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6913024EA76
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 01:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbgHVXkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 19:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727812AbgHVXkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 19:40:22 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E143C061573
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 16:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=Jw585x3cnWq7YnAJW6xOwXCdWyyiVHL4558RqPcFlqg=; b=2z0dEyPhEvstaTvFEG1lmqwH9j
        LvLdQQNnsB6WoWbeB/qooz6SIx87olAE+K1/1IwKQcAQqSC+4uaAZAFWgOaILW5Znkl2lkWMIp6nB
        Sw/QczKWcCSDJ9IjUiiGDoXPxBnbI32Q/EWF1TLthJyvkxPxFY4ckI3KRNAZG5R5AKxHuXNbzYrF/
        6u0NhmucNtV1qXzX6jICbHfs8hgH0DcCuH5a4GGJ3Ooyz7A+037nXGvTTCyyu0qO8y7U1lyIQDK4y
        5rKzqe0TC4ppFrylcCV/F9YdRMLQhkJzJdBnOpEiNzoocHe+qYKHhq4GfjWBBBIDh5EWvHFWeAhoL
        B46gViyg==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9d7T-0007Fe-4Z; Sat, 22 Aug 2020 23:40:19 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] net: netlink: delete repeated words
Date:   Sat, 22 Aug 2020 16:40:15 -0700
Message-Id: <20200822234015.2269-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop duplicated words in net/netlink/.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/netlink/af_netlink.c |    8 ++++----
 net/netlink/genetlink.c  |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

--- linux-next-20200821.orig/net/netlink/af_netlink.c
+++ linux-next-20200821/net/netlink/af_netlink.c
@@ -848,7 +848,7 @@ retry:
  *
  * Test to see if the opener of the socket we received the message
  * from had when the netlink socket was created and the sender of the
- * message has has the capability @cap in the user namespace @user_ns.
+ * message has the capability @cap in the user namespace @user_ns.
  */
 bool __netlink_ns_capable(const struct netlink_skb_parms *nsp,
 			struct user_namespace *user_ns, int cap)
@@ -867,7 +867,7 @@ EXPORT_SYMBOL(__netlink_ns_capable);
  *
  * Test to see if the opener of the socket we received the message
  * from had when the netlink socket was created and the sender of the
- * message has has the capability @cap in the user namespace @user_ns.
+ * message has the capability @cap in the user namespace @user_ns.
  */
 bool netlink_ns_capable(const struct sk_buff *skb,
 			struct user_namespace *user_ns, int cap)
@@ -883,7 +883,7 @@ EXPORT_SYMBOL(netlink_ns_capable);
  *
  * Test to see if the opener of the socket we received the message
  * from had when the netlink socket was created and the sender of the
- * message has has the capability @cap in all user namespaces.
+ * message has the capability @cap in all user namespaces.
  */
 bool netlink_capable(const struct sk_buff *skb, int cap)
 {
@@ -898,7 +898,7 @@ EXPORT_SYMBOL(netlink_capable);
  *
  * Test to see if the opener of the socket we received the message
  * from had when the netlink socket was created and the sender of the
- * message has has the capability @cap over the network namespace of
+ * message has the capability @cap over the network namespace of
  * the socket we received the message from.
  */
 bool netlink_net_capable(const struct sk_buff *skb, int cap)
--- linux-next-20200821.orig/net/netlink/genetlink.c
+++ linux-next-20200821/net/netlink/genetlink.c
@@ -222,7 +222,7 @@ static int genl_validate_assign_mc_group
 
 	family->mcgrp_offset = first_id;
 
-	/* if still initializing, can't and don't need to to realloc bitmaps */
+	/* if still initializing, can't and don't need to realloc bitmaps */
 	if (!init_net.genl_sock)
 		return 0;
 
