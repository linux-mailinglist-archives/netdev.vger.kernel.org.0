Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD21026F530
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 06:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgIREfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 00:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgIREfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 00:35:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C1D4C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 21:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=/qvS/tqTlhxoXGz98gVaEtgW10uxMPAr10zF6O+kpvM=; b=B1HzrZmX+b+oK1QOngbiaaTcHU
        200l2qfmqjr6oM1Nbo5/FsmnZZQXZPzTRXuY8Y/D/H3DhMxp85OJNc+6aOt7M4cK89zZB86uFshiP
        pJiQ0rEm6YwV6o6yuNeqH++RIFt6yR8pXn92ycdepIVkvvcWxDhARtw9fXCP+f0X5qCCTP6B6cAdx
        o4r7Y4bQFKxeqPORN7QWv7tAzF+7gjusMwGhy4GDya393hOCCiBDD1OjxT0TXfSeZfpgBZ4KvX3ks
        mFpVy29dq5MdRV8/EJxUYNtBaqnEkPOecH9uY4iz10FowQdk8/SM5yVFqDasfBb+NY92A04/syuZO
        jiGf85Yg==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJ87T-0003Ci-PD; Fri, 18 Sep 2020 04:35:36 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH 5/7 net-next] net: tipc: delete duplicated words
Date:   Thu, 17 Sep 2020 21:35:19 -0700
Message-Id: <20200918043521.17346-6-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200918043521.17346-1-rdunlap@infradead.org>
References: <20200918043521.17346-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop repeated words in net/tipc/.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jon Maloy <jmaloy@redhat.com>
Cc: Ying Xue <ying.xue@windriver.com>
Cc: tipc-discussion@lists.sourceforge.net
---
 net/tipc/msg.c    |    2 +-
 net/tipc/socket.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20200917.orig/net/tipc/msg.c
+++ linux-next-20200917/net/tipc/msg.c
@@ -582,7 +582,7 @@ bundle:
  *  @pos: position in outer message of msg to be extracted.
  *        Returns position of next msg
  *  Consumes outer buffer when last packet extracted
- *  Returns true when when there is an extracted buffer, otherwise false
+ *  Returns true when there is an extracted buffer, otherwise false
  */
 bool tipc_msg_extract(struct sk_buff *skb, struct sk_buff **iskb, int *pos)
 {
--- linux-next-20200917.orig/net/tipc/socket.c
+++ linux-next-20200917/net/tipc/socket.c
@@ -54,7 +54,7 @@
 #define CONN_PROBING_INTV	msecs_to_jiffies(3600000)  /* [ms] => 1 h */
 #define TIPC_MAX_PORT		0xffffffff
 #define TIPC_MIN_PORT		1
-#define TIPC_ACK_RATE		4       /* ACK at 1/4 of of rcv window size */
+#define TIPC_ACK_RATE		4       /* ACK at 1/4 of rcv window size */
 
 enum {
 	TIPC_LISTEN = TCP_LISTEN,
