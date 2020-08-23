Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A3724EAA7
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 03:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgHWBHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 21:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgHWBHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 21:07:25 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57055C061573;
        Sat, 22 Aug 2020 18:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=rsvb64LGinNZbCALCyrv8WkRC2cBW80GfSBf4aFnjSM=; b=DDVsgZ2DTr4AvA7jKr+r0tLXfZ
        9+VqOLOhEPccUAPXjKr/hO7e6jUvBeQxFKhZfgaw18TQtnJpbaHr3BUPqEH4mCyOyHrmsrvyxPhtM
        blHc/Io2PO3E6SZgTX++d7LtysMf3J/ukbU5a9gLV8YkmEBbrmaTl3g6xhgB1ZzCHtAw3E6nGB2ZY
        HQVdZ3zgo9k06aPpboGk9tW7Ati/WoxgYA1aWY9qoJE9ghrWMPlM+RF1YaZR+D2J7L3I1doNQu9p1
        /nSQ1OXxF1zj3lGbyPb68GplImrna0tYK3ZQujMDkimPo83tdgrczjfzfEgIAi/OKQpLqsae6GH9l
        aN5J8Fdg==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9eTf-0005Ki-2J; Sun, 23 Aug 2020 01:07:19 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>, dccp@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] net: dccp: delete repeated words
Date:   Sat, 22 Aug 2020 18:07:13 -0700
Message-Id: <20200823010713.4728-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop duplicated words in /net/dccp/.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Gerrit Renker <gerrit@erg.abdn.ac.uk>
Cc: dccp@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/dccp/ackvec.c |    2 +-
 net/dccp/ipv4.c   |    2 +-
 net/dccp/timer.c  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20200821.orig/net/dccp/ackvec.c
+++ linux-next-20200821/net/dccp/ackvec.c
@@ -274,7 +274,7 @@ void dccp_ackvec_input(struct dccp_ackve
 /**
  * dccp_ackvec_clear_state  -  Perform house-keeping / garbage-collection
  * This routine is called when the peer acknowledges the receipt of Ack Vectors
- * up to and including @ackno. While based on on section A.3 of RFC 4340, here
+ * up to and including @ackno. While based on section A.3 of RFC 4340, here
  * are additional precautions to prevent corrupted buffer state. In particular,
  * we use tail_ackno to identify outdated records; it always marks the earliest
  * packet of group (2) in 11.4.2.
--- linux-next-20200821.orig/net/dccp/ipv4.c
+++ linux-next-20200821/net/dccp/ipv4.c
@@ -731,7 +731,7 @@ int dccp_invalid_packet(struct sk_buff *
 		return 1;
 	}
 	/*
-	 * If P.Data Offset is too too large for packet, drop packet and return
+	 * If P.Data Offset is too large for packet, drop packet and return
 	 */
 	if (!pskb_may_pull(skb, dccph_doff * sizeof(u32))) {
 		DCCP_WARN("P.Data Offset(%u) too large\n", dccph_doff);
--- linux-next-20200821.orig/net/dccp/timer.c
+++ linux-next-20200821/net/dccp/timer.c
@@ -85,7 +85,7 @@ static void dccp_retransmit_timer(struct
 	struct inet_connection_sock *icsk = inet_csk(sk);
 
 	/*
-	 * More than than 4MSL (8 minutes) has passed, a RESET(aborted) was
+	 * More than 4MSL (8 minutes) has passed, a RESET(aborted) was
 	 * sent, no need to retransmit, this sock is dead.
 	 */
 	if (dccp_write_timeout(sk))
