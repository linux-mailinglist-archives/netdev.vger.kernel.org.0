Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32BA24EA54
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 01:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728677AbgHVXQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 19:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728664AbgHVXQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 19:16:28 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371C5C061573;
        Sat, 22 Aug 2020 16:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=EZnbOAcTuCcaexzwhZSY+in/0mQRLC+xi5Hz63sGS+c=; b=qMUE7/+zTsMrwVy5Dzm0c/nbiJ
        LyB8Mq8fVnWs8vkuKDaNEsDXrb8dJgnQl0+ihPEqOe8Gn76aktT3zjqumZSxIG9F287sqHxBtV549
        G4RfRUHlX9OiwlYMABZ0bjed8agxc5alFY6zsmaCq8MagrJ52s2TIwfAaDni4VmeacIm2nnUG9+xK
        XprHcm9U/KJMaLiJ1zwgb6i5D5sfwVKT0Kc0Vb3gQ8ax94m217zdXlC++B7MZOS/C1oL15RkJAa+b
        MOKqMcoqnsDkosyUghwd0M5hzb4WRKzXakivL2lYw7s9diJqEGXI49x1QKNzcmXDKvgE0rNX5Gmyr
        OoXsyNfQ==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9ckK-0006VD-AQ; Sat, 22 Aug 2020 23:16:25 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6/7] net: sctp: sm_make_chunk.c: delete duplicated words + fix typo
Date:   Sat, 22 Aug 2020 16:16:00 -0700
Message-Id: <20200822231601.32125-7-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200822231601.32125-1-rdunlap@infradead.org>
References: <20200822231601.32125-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop the repeated words "for", "that", and "a".
Change "his" to "this".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: linux-sctp@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/sctp/sm_make_chunk.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20200731.orig/net/sctp/sm_make_chunk.c
+++ linux-next-20200731/net/sctp/sm_make_chunk.c
@@ -1235,7 +1235,7 @@ nodata:
 
 /* Create an Operation Error chunk of a fixed size, specifically,
  * min(asoc->pathmtu, SCTP_DEFAULT_MAXSEGMENT) - overheads.
- * This is a helper function to allocate an error chunk for for those
+ * This is a helper function to allocate an error chunk for those
  * invalid parameter codes in which we may not want to report all the
  * errors, if the incoming chunk is large. If it can't fit in a single
  * packet, we ignore it.
@@ -1780,7 +1780,7 @@ no_hmac:
 	 * for init collision case of lost COOKIE ACK.
 	 * If skb has been timestamped, then use the stamp, otherwise
 	 * use current time.  This introduces a small possibility that
-	 * that a cookie may be considered expired, but his would only slow
+	 * a cookie may be considered expired, but this would only slow
 	 * down the new association establishment instead of every packet.
 	 */
 	if (sock_flag(ep->base.sk, SOCK_TIMESTAMP))
@@ -2319,7 +2319,7 @@ int sctp_process_init(struct sctp_associ
 
 	/* This implementation defaults to making the first transport
 	 * added as the primary transport.  The source address seems to
-	 * be a a better choice than any of the embedded addresses.
+	 * be a better choice than any of the embedded addresses.
 	 */
 	if (!sctp_assoc_add_peer(asoc, peer_addr, gfp, SCTP_ACTIVE))
 		goto nomem;
