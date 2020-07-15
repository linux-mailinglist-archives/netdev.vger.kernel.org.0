Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B59322029E
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 05:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgGOC7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 22:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728400AbgGOC7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 22:59:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40C5C061755;
        Tue, 14 Jul 2020 19:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=ORcolOAe5BW2I3S5N0q+4FqMmkEjAg/Ue/Nr3QdbNh0=; b=qwiboJu/byqKqqJUPanUlmOcgG
        CQpki8EO8UoGKTAr7B0CVMebwBa1/LRKy6wQVmsagJ6TeSLyJ1w3HD75EiInSBinqP9w83g+0Kcwy
        4GjmIgxBrf2vrpaK1qgVzAdrotZD67+Ski/A3njDb+1ahdRw83fjb2ii2XoqYXnyt2Kf45dmgni1Z
        Ms+0V4XTeQhziY2KSKJZD2sG0hKlYbOoy9Hv/pmcfVwePvkOHSht37ZWU6r/h8Ufb+nEZUoC+S5BB
        mFIFCK/+sPY82p+zW68cjYfcg/P53xEF36hKu36oxmR3U944OmBtF01DCQFV6m/rWS9n/iCgksM/w
        2HbsxH4w==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvXdt-0001FT-RM; Wed, 15 Jul 2020 02:59:35 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 08/13 net-next] net: cfg80211.h: drop duplicate words in comments
Date:   Tue, 14 Jul 2020 19:59:09 -0700
Message-Id: <20200715025914.28091-8-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715025914.28091-1-rdunlap@infradead.org>
References: <20200715025914.28091-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop doubled word "by" in a comment.
Change "operate in in" to "operate with in" as is used below.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
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
