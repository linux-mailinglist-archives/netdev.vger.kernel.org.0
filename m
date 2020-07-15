Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DED9B220294
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 04:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbgGOC72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 22:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728400AbgGOC71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 22:59:27 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E903DC061755;
        Tue, 14 Jul 2020 19:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=mVHy83G7pEXwI9BgD2a/q+FOfNR4hZzrhDfASssAAeQ=; b=tijZ3PQdVjKLVP03vqgoLHjpPB
        angGynbx23svFmL1ClWPr0RmNC7UGFmLs3mn9tw4Dmu70pn0gsNzn8edyacwKQx2axo1QhwvEaBBb
        pzODTlXrDmC+dOCm+PSooM6W8snLmymtcLRE+u7oiNmzcShsU4v2OWcMdw0vYylGXpq2yz876sxR6
        /xFPhmB7kAZ+JfFoRf8Oql/mWQljvUN9D7hMHAYIEXuD/W+3dlnRh6Nl9slGgau5fCPUPIQj+4yL6
        0kzH8qVDFSazRwmMpdrP8aXUYK5nczNYTQGBrtOeGnyCWblFP6XBBaWirHhmzbOSVLXVW7eF5I1Xg
        0FOdQNxQ==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvXdk-0001FT-T3; Wed, 15 Jul 2020 02:59:25 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 04/13 net-next] net: skbuff.h: drop duplicate words in comments
Date:   Tue, 14 Jul 2020 19:59:05 -0700
Message-Id: <20200715025914.28091-4-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715025914.28091-1-rdunlap@infradead.org>
References: <20200715025914.28091-1-rdunlap@infradead.org>
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
 include/linux/skbuff.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20200714.orig/include/linux/skbuff.h
+++ linux-next-20200714/include/linux/skbuff.h
@@ -1329,7 +1329,7 @@ void skb_flow_dissect_meta(const struct
 			   void *target_container);
 
 /* Gets a skb connection tracking info, ctinfo map should be a
- * a map of mapsize to translate enum ip_conntrack_info states
+ * map of mapsize to translate enum ip_conntrack_info states
  * to user states.
  */
 void
@@ -3813,7 +3813,7 @@ static inline bool skb_defer_rx_timestam
  * must call this function to return the skb back to the stack with a
  * timestamp.
  *
- * @skb: clone of the the original outgoing packet
+ * @skb: clone of the original outgoing packet
  * @hwtstamps: hardware time stamps
  *
  */
