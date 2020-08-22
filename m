Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B672424EA49
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 01:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728585AbgHVXQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 19:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728021AbgHVXQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 19:16:12 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976E3C061573;
        Sat, 22 Aug 2020 16:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=w9GETTYDkBsz3Sq/Hk7ivWJfP/PyQ+NfmwvQQHnutdM=; b=ixD5P5F51gV1Ln0Isro9I/UyGP
        6m4mS2AQ9/reG7JyS2QTbNnwf0Jx8vCBLiMtz6FWEYTeniXeU5ziJwLpurcBibqDOTw9tTt1zJf85
        4EOcX/zFA7Af1DZoXbvyT7LamUVGl4B6dLxNTegNs7s0Cab0qNCieGkLBqVCEYs0IAWh86nRXQGoy
        dhmHVqgs44rZs9o/xypLobEA06ijagHbbeJ91TTJXt/viKi0WjVQ4Eiu59IKDOIlOoSfu+GcQzTEW
        FP8fUHxQdg0KrSqWqBA3h69iPi/NpqA0OwThEuN9QHFRrP3yCmd4AQ6d4B0Z8Q1ZMlscvhOPaO+2T
        InLARLKQ==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9ck5-0006VD-2p; Sat, 22 Aug 2020 23:16:09 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 1/7] net: sctp: associola.c: delete duplicated words
Date:   Sat, 22 Aug 2020 16:15:55 -0700
Message-Id: <20200822231601.32125-2-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200822231601.32125-1-rdunlap@infradead.org>
References: <20200822231601.32125-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop the repeated word "the" in two places.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: linux-sctp@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/sctp/associola.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20200731.orig/net/sctp/associola.c
+++ linux-next-20200731/net/sctp/associola.c
@@ -1351,7 +1351,7 @@ static void sctp_select_active_and_retra
 	}
 
 	/* We did not find anything useful for a possible retransmission
-	 * path; either primary path that we found is the the same as
+	 * path; either primary path that we found is the same as
 	 * the current one, or we didn't generally find an active one.
 	 */
 	if (trans_sec == NULL)
@@ -1537,7 +1537,7 @@ void sctp_assoc_rwnd_decrease(struct sct
 
 	/* If we've reached or overflowed our receive buffer, announce
 	 * a 0 rwnd if rwnd would still be positive.  Store the
-	 * the potential pressure overflow so that the window can be restored
+	 * potential pressure overflow so that the window can be restored
 	 * back to original value.
 	 */
 	if (rx_count >= asoc->base.sk->sk_rcvbuf)
