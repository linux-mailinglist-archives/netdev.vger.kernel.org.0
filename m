Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9DB424EAA9
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 03:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbgHWBHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 21:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgHWBHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 21:07:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3DB5C061573;
        Sat, 22 Aug 2020 18:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=SC10+AGp7h0aSAsNuFUaoLCxuLvepP72vyB8zKvDnRg=; b=BhlMSYojoSYHT2cQWShj0VgiGp
        flhUct9moLM4I0bJ9huGDfy5pZ9kjTyD8iSOz/wwtdUGk5LT+6d0Ax1TzjIMsyiRYCLyRQZWHz8Im
        evc6q/aOghFSjmt2DO4pQe4+/mR6gX85r0n4TrbOw61TDpHYrX+k7X+cETMiZn+NMItVqmqWqZ2cn
        Zrw73FR2uaNH/7IlFqFFnJ1EAvoNOfAyXL1wQV++6mDza49wMDwoz7u/eRc+FPHXRr5h6kuG1Fr0w
        ZUNK8E5D5c7ZQMcq0xJQh/UWEpWTbchtRlL1AJGLcmyJKaz4ELNOdhfALu1oe8RYlH2Gh7I2mkVh0
        ZziXAZpA==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9eTr-0005Mc-2k; Sun, 23 Aug 2020 01:07:31 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH] net: netfilter: delete repeated words
Date:   Sat, 22 Aug 2020 18:07:27 -0700
Message-Id: <20200823010727.4786-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop duplicated words in net/netfilter/ and net/ipv4/netfilter/.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org
---
 net/ipv4/netfilter/nf_nat_pptp.c       |    2 +-
 net/netfilter/nf_conntrack_pptp.c      |    2 +-
 net/netfilter/nf_conntrack_proto_tcp.c |    2 +-
 net/netfilter/xt_recent.c              |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- linux-next-20200821.orig/net/ipv4/netfilter/nf_nat_pptp.c
+++ linux-next-20200821/net/ipv4/netfilter/nf_nat_pptp.c
@@ -3,7 +3,7 @@
  * nf_nat_pptp.c
  *
  * NAT support for PPTP (Point to Point Tunneling Protocol).
- * PPTP is a a protocol for creating virtual private networks.
+ * PPTP is a protocol for creating virtual private networks.
  * It is a specification defined by Microsoft and some vendors
  * working with Microsoft.  PPTP is built on top of a modified
  * version of the Internet Generic Routing Encapsulation Protocol.
--- linux-next-20200821.orig/net/netfilter/nf_conntrack_pptp.c
+++ linux-next-20200821/net/netfilter/nf_conntrack_pptp.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * Connection tracking support for PPTP (Point to Point Tunneling Protocol).
- * PPTP is a a protocol for creating virtual private networks.
+ * PPTP is a protocol for creating virtual private networks.
  * It is a specification defined by Microsoft and some vendors
  * working with Microsoft.  PPTP is built on top of a modified
  * version of the Internet Generic Routing Encapsulation Protocol.
--- linux-next-20200821.orig/net/netfilter/nf_conntrack_proto_tcp.c
+++ linux-next-20200821/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1152,7 +1152,7 @@ int nf_conntrack_tcp_packet(struct nf_co
 		   && (old_state == TCP_CONNTRACK_SYN_RECV
 		       || old_state == TCP_CONNTRACK_ESTABLISHED)
 		   && new_state == TCP_CONNTRACK_ESTABLISHED) {
-		/* Set ASSURED if we see see valid ack in ESTABLISHED
+		/* Set ASSURED if we see valid ack in ESTABLISHED
 		   after SYN_RECV or a valid answer for a picked up
 		   connection. */
 		set_bit(IPS_ASSURED_BIT, &ct->status);
--- linux-next-20200821.orig/net/netfilter/xt_recent.c
+++ linux-next-20200821/net/netfilter/xt_recent.c
@@ -640,7 +640,7 @@ static void __net_exit recent_proc_net_e
 	struct recent_table *t;
 
 	/* recent_net_exit() is called before recent_mt_destroy(). Make sure
-	 * that the parent xt_recent proc entry is is empty before trying to
+	 * that the parent xt_recent proc entry is empty before trying to
 	 * remove it.
 	 */
 	spin_lock_bh(&recent_lock);
