Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082602212BF
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 18:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgGOQoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 12:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727873AbgGOQne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 12:43:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC679C061755;
        Wed, 15 Jul 2020 09:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=MW9P+vg1GZKyWc3VgtDlMrW2L1NHiHjl6pMxRzrg0vo=; b=rzkUCCsL7TBCmVkmEmfzE0LLYu
        YiP77DnYATWcjvziPG94QWlHMZfiVXql3qk9Y2aoLSchJQDsddSIsZI3xCW+zF7i9NxPWKcg8G+K9
        9tRgV9QkP3U4/qqpReTEO/oYmk2SQ1UE33U3MRKiy7EPoyiy1KLV275CZEkcelwGUnwlik+r+YRO8
        +Wy0XgL84KaucfbFlOvarUirvJZST5kW0QTJxUpZ3+2+Pz6iqNd9eV70xZ/EWxiQjOW53dCYoVUSs
        ti7V2dwRpgzV0+TQfbUDaT6ai0zz7hcceQa+TBuS8zNBoMsfwOQDdR4C7316v6ghJszmTcamiK/hu
        Dob7LGNQ==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvkVI-0000EP-2r; Wed, 15 Jul 2020 16:43:32 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 3/5 -next] net/wireless: cfg80211.h: drop duplicate words in comments
Date:   Wed, 15 Jul 2020 09:43:23 -0700
Message-Id: <20200715164325.9109-3-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715164325.9109-1-rdunlap@infradead.org>
References: <20200715164325.9109-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop doubled word "by" in a comment.
Change "operate in in" to "operate with in" as is used below.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: netdev@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20200714.orig/include/net/cfg80211.h
+++ linux-next-20200714/include/net/cfg80211.h
@@ -423,7 +423,7 @@ struct ieee80211_edmg {
  * This structure describes a frequency band a wiphy
  * is able to operate in.
  *
- * @channels: Array of channels the hardware can operate in
+ * @channels: Array of channels the hardware can operate with
  *	in this band.
  * @band: the band this structure represents
  * @n_channels: Number of channels in @channels
@@ -5510,7 +5510,7 @@ static inline int ieee80211_data_to_8023
  *
  * @skb: The input A-MSDU frame without any headers.
  * @list: The output list of 802.3 frames. It must be allocated and
- *	initialized by by the caller.
+ *	initialized by the caller.
  * @addr: The device MAC address.
  * @iftype: The device interface type.
  * @extra_headroom: The hardware extra headroom for SKBs in the @list.
