Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68CFB2202A7
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 05:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbgGOC74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 22:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728531AbgGOC7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 22:59:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7430CC061755;
        Tue, 14 Jul 2020 19:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=nt19uHTbTV/K5R5n37IbEuFWPn5I8ywiC4uLamYow5M=; b=pTSjTP5vvJIjhfY6kpCXzROzBe
        KohVkFWTuDSSlsKo32uuGHYZad+PnOdRzJ6QiPXz52vpRvTAT6CBLFGvgJRqfd2P+3hK0aiQozhyw
        8OpDTwpNc/4z2Mm3aT6nvwIAQh85WKvupD5hZJm/2Uk9GWa+iuQTyhansfirNSPSEzK3y3qUw+57+
        P8B7DWaP9Ke0Bko8orLBSKV63NSMxLOl1rWxs5NIA5MxALezV0BglhOHXKARkDtFOTBpWzgLlXqlj
        Xsts+MTvlxUnYSkwxtaf+11vMrAAuo+QcNeZBk8Rw8FcDu7SwjfYLYI3aiyPCKyRXqklzkKIZElw4
        4I+v2BHg==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvXe2-0001FT-KW; Wed, 15 Jul 2020 02:59:43 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 12/13 net-next] net: regulatory.h: drop duplicate word in comment
Date:   Tue, 14 Jul 2020 19:59:13 -0700
Message-Id: <20200715025914.28091-12-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715025914.28091-1-rdunlap@infradead.org>
References: <20200715025914.28091-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop doubled word "of" in a comment.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
 include/net/regulatory.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200714.orig/include/net/regulatory.h
+++ linux-next-20200714/include/net/regulatory.h
@@ -44,7 +44,7 @@ enum environment_cap {
  *	and potentially inform users of which devices specifically
  *	cased the conflicts.
  * @initiator: indicates who sent this request, could be any of
- *	of those set in nl80211_reg_initiator (%NL80211_REGDOM_SET_BY_*)
+ *	those set in nl80211_reg_initiator (%NL80211_REGDOM_SET_BY_*)
  * @alpha2: the ISO / IEC 3166 alpha2 country code of the requested
  *	regulatory domain. We have a few special codes:
  *	00 - World regulatory domain
