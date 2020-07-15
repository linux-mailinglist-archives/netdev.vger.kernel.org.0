Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A77382212DB
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 18:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbgGOQpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 12:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbgGOQnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 12:43:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91AEFC08C5DB;
        Wed, 15 Jul 2020 09:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Wag+6AWqN8ATXVdQfk0Cfq9siIHE+ASqKdT77w0Aj3s=; b=BZ/0uNjuOL3EGBCl1bZI3KLvGP
        NAiZQITNDiERKzJxHI85GjbeVz1fmg0iB60ur81cRraB42FslsixcysOu+xoQP9lFRKQIAo2Vh85i
        ZWeV6ZoTmWLp+ftF+YDQ2/ge0RlYIt8ov/LlbXA3he/6mpfokMgtdUDrWeiaVMQKOPb1VVG5Mg4wo
        Fa8upnHvMYrAKTnC1VSZ04kEgwBSfhjgTX/uF6tqZk49DH9QkKEcCnuFCnVysPlb89fNVz8V+9XA3
        Z78U72CJOQMuhQt+rHBSbEgZ9io09febQhnO3m4q4LQoGluGGq/jAkPeOwyC/9KblRcyXJufLPgMo
        Arz0Aanw==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvkUp-0000Bh-QA; Wed, 15 Jul 2020 16:43:04 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 8/9 v2 net-next] net: sctp: drop duplicate words in comments
Date:   Wed, 15 Jul 2020 09:42:45 -0700
Message-Id: <20200715164246.9054-8-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715164246.9054-1-rdunlap@infradead.org>
References: <20200715164246.9054-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop doubled words in several comments.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
v2: move wireless patches to a separate patch series.

 include/net/sctp/sctp.h    |    2 +-
 include/net/sctp/structs.h |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- linux-next-20200714.orig/include/net/sctp/sctp.h
+++ linux-next-20200714/include/net/sctp/sctp.h
@@ -291,7 +291,7 @@ atomic_dec(&sctp_dbg_objcnt_## name)
 #define SCTP_DBG_OBJCNT(name) \
 atomic_t sctp_dbg_objcnt_## name = ATOMIC_INIT(0)
 
-/* Macro to help create new entries in in the global array of
+/* Macro to help create new entries in the global array of
  * objcnt counters.
  */
 #define SCTP_DBG_OBJCNT_ENTRY(name) \
--- linux-next-20200714.orig/include/net/sctp/structs.h
+++ linux-next-20200714/include/net/sctp/structs.h
@@ -1398,7 +1398,7 @@ struct sctp_stream_priorities {
 	struct list_head prio_sched;
 	/* List of streams scheduled */
 	struct list_head active;
-	/* The next stream stream in line */
+	/* The next stream in line */
 	struct sctp_stream_out_ext *next;
 	__u16 prio;
 };
@@ -1460,7 +1460,7 @@ struct sctp_stream {
 		struct {
 			/* List of streams scheduled */
 			struct list_head rr_list;
-			/* The next stream stream in line */
+			/* The next stream in line */
 			struct sctp_stream_out_ext *rr_next;
 		};
 	};
@@ -1770,7 +1770,7 @@ struct sctp_association {
 	int max_burst;
 
 	/* This is the max_retrans value for the association.  This value will
-	 * be initialized initialized from system defaults, but can be
+	 * be initialized from system defaults, but can be
 	 * modified by the SCTP_ASSOCINFO socket option.
 	 */
 	int max_retrans;
