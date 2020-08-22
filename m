Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3644524EA53
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 01:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728661AbgHVXQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 19:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbgHVXQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 19:16:24 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0EAC061573;
        Sat, 22 Aug 2020 16:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=homh8fpwndT7ZC40hZu7Zm4w4XuTvWlAprBv3e2gJ+c=; b=iy+s6bBukJCDu3sVPccyYd8xoc
        8XTB5fP7Ke4ZTgjFH1yNhKkzdW+N5o556yYwNE+W+7nEOr2zscXcggXsBYDQWiCMIAcmCGUq9Hd4X
        1guLy9xhaz1F7Gx2XxSaftb65MirrgyIRpUo0ilAYYMKwSN+LkEDZuNfoc3tMVQNJuk5OVuB+bHZD
        pfiwi+X8Sh0a0cw1HDLh6hv7ArJFZrn8u5gJM4JSLHgcyTCSljVModNvvk6V2qYvlPtglWZOmusUB
        GIyboOssxfu2sobLz/OtMH7NNk1lymJab2Kkixzpcsr6DtGEN8vCwRW4+2Tstpkopr1tpmg2eZHeR
        aUHiRjYw==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9ckH-0006VD-9S; Sat, 22 Aug 2020 23:16:21 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5/7] net: sctp: protocol.c: delete duplicated words + punctuation
Date:   Sat, 22 Aug 2020 16:15:59 -0700
Message-Id: <20200822231601.32125-6-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200822231601.32125-1-rdunlap@infradead.org>
References: <20200822231601.32125-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop the repeated words "of" and "that".
Add some punctuation for readability.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: linux-sctp@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/sctp/protocol.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-next-20200731.orig/net/sctp/protocol.c
+++ linux-next-20200731/net/sctp/protocol.c
@@ -372,7 +372,7 @@ static int sctp_v4_available(union sctp_
  * Level 3 - private addresses.
  * Level 4 - global addresses
  * For INIT and INIT-ACK address list, let L be the level of
- * of requested destination address, sender and receiver
+ * requested destination address, sender and receiver
  * SHOULD include all of its addresses with level greater
  * than or equal to L.
  *
@@ -1483,10 +1483,10 @@ static __init int sctp_init(void)
 	num_entries = (1UL << order) * PAGE_SIZE /
 		      sizeof(struct sctp_bind_hashbucket);
 
-	/* And finish by rounding it down to the nearest power of two
-	 * this wastes some memory of course, but its needed because
+	/* And finish by rounding it down to the nearest power of two.
+	 * This wastes some memory of course, but it's needed because
 	 * the hash function operates based on the assumption that
-	 * that the number of entries is a power of two
+	 * the number of entries is a power of two.
 	 */
 	sctp_port_hashsize = rounddown_pow_of_two(num_entries);
 
