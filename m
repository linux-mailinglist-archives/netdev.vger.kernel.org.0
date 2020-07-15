Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99DF2212C8
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 18:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgGOQoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 12:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbgGOQni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 12:43:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACFFC08C5DB;
        Wed, 15 Jul 2020 09:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=lOw7LLm37gBW3xZOKycJ6H4GjQelBKlNOP/LzyOKyQg=; b=ksVnOff3KlfGYP1eZ+pbZBLv1/
        QANAc1kCkRuxUezSJEDZkKUyY3jleXLO+GTSVDNJel67pWCbUcsOea+2KCx0jhFlAq3f2eR50bs8k
        NTMMEaXhFyFqFFcCBkXo6BYUyoEbybqZ6gi1YWIGvlSJEQdAekeNKqXH43GWdRs6YcPH8LmJ+j0ko
        Drwq6OydgPvuGpeG9Rn6XDQG4hhSn1z5aBiIUorqgla7UjTdmrvQ9m/IrB8VUkfyGJA0X77tXa4Ub
        lsoEf1umEBineE3D+JNUr6msBSpZxtXwHHmhsJ/ZTovSMOfil4KG+NISN9tL+CLDgllQ7Up+F9s2J
        zSE2I3Zg==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvkVL-0000EP-Uu; Wed, 15 Jul 2020 16:43:36 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 5/5 -next] net/wireless: regulatory.h: drop duplicate word in comment
Date:   Wed, 15 Jul 2020 09:43:25 -0700
Message-Id: <20200715164325.9109-5-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715164325.9109-1-rdunlap@infradead.org>
References: <20200715164325.9109-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop doubled word "of" in a comment.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: netdev@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
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
