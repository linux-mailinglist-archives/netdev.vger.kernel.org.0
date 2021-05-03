Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57AA7371AA8
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 18:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbhECQkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 12:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbhECQjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 12:39:09 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E325DC06137A;
        Mon,  3 May 2021 09:36:45 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id m37so4016093pgb.8;
        Mon, 03 May 2021 09:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=pOu7PdLtcf7SkIIMfjGdD4cGCPeaE8uB/RndMpSh6wE=;
        b=R0WwnEy3HQBPTR5C/qPN7mjzOlx9ztBV04EwCY5B+4LysW0qqbWJKBJIf2MZ+JYxlj
         FCIlvPjEKLVblnjvXyiSyiK4d2wlW4w7kz5A/FBHQHDaQGjbRyD5K14TuqD2m++3+LCj
         wdTX3wAsfszfK63K6lcrpprznSM8z0DgLoD9XPQdOdsvF0XSpMOaEXtuhvZFef5DRJFe
         b3DiQJ96qELZvv61bBXrMLPg4Y5I9MTaEv5vBwbQxxzL30nAgR9wQEPKs/eWdSOsDEds
         rgdpphC/eoSgFRpzolcpLYbK9ee3gkxlxoV4Fxv8X/T8YUDMIuUCyDjW3zOMCmlOZt7R
         uBog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=pOu7PdLtcf7SkIIMfjGdD4cGCPeaE8uB/RndMpSh6wE=;
        b=uXK1Rx00sv5/mcHMmNZiFvl3yv20KoKJfUgTeton7bAb5Qic4wN3gjbQnsQzCR4z35
         q+FFZPTM7guIHommQ8D6v2oghH9XtQ9pjT00p+IlwlLw3qJUtjEHOUQS17pU0tu6tvLA
         yFn8zJ1PPMbF7NauFsRK6QSL8Aa1rzzHz0Av5FBrn/vPZVJ1r4OVFrdikUJBYwdNktP+
         YV5KGJH/ZoSiUNcpy3GLhV5EZ2XOLRP/r1cL3zyFBJjnRO4gRlQ07YpympoRSZpu4JI3
         mGc9+hfY+Z9+Pq2C2B/XvxeAuG4Lyp5pIWdeO7QeAdjUhMvoHGkNdrJ1pEzaavJMUZ90
         V5zw==
X-Gm-Message-State: AOAM531o0wzLcGZl2Ma29xrQWv56JITYvGmj4NR6k0VxnFj/qUY6L5Hv
        4QXx5ygl5kAMzPdeb3wCHaE=
X-Google-Smtp-Source: ABdhPJzJNcuCOI+JcHs1QhFMQ7XGPv/xxkw3BGzuZUhaOeHRi0qoSxSWuj4tc5CR9j58GkDzbb6SgQ==
X-Received: by 2002:aa7:80d6:0:b029:258:9404:13e with SMTP id a22-20020aa780d60000b02902589404013emr19375494pfn.37.1620059805390;
        Mon, 03 May 2021 09:36:45 -0700 (PDT)
Received: from localhost ([157.45.29.210])
        by smtp.gmail.com with ESMTPSA id js6sm344960pjb.0.2021.05.03.09.36.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 May 2021 09:36:44 -0700 (PDT)
Date:   Mon, 3 May 2021 22:06:36 +0530
From:   Shubhankar Kuranagatti <shubhankarvk@gmail.com>
To:     johannes@sipsolutions.net
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: wireless: reg.c: Remove spaces at the start of line
Message-ID: <20210503163636.hoy3odhmpmqh7fl7@kewl-virtual-machine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Spaces have been removed at the start of the line
Tabs have been used in place of spaces
New line added after declaration
The closing */ has been shifted to new line
This is done to maintain code uniformity

Signed-off-by: Shubhankar Kuranagatti <shubhankarvk@gmail.com>
---
 net/wireless/reg.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 21536c48deec..52ec7d87bfe5 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -241,14 +241,15 @@ static const struct ieee80211_regdomain world_regdom = {
 		REG_RULE(2467-10, 2472+10, 20, 6, 20,
 			NL80211_RRF_NO_IR | NL80211_RRF_AUTO_BW),
 		/* IEEE 802.11 channel 14 - Only JP enables
-		 * this and for 802.11b only */
+		 * this and for 802.11b only
+		 */
 		REG_RULE(2484-10, 2484+10, 20, 6, 20,
 			NL80211_RRF_NO_IR |
 			NL80211_RRF_NO_OFDM),
 		/* IEEE 802.11a, channel 36..48 */
 		REG_RULE(5180-10, 5240+10, 80, 6, 20,
-                        NL80211_RRF_NO_IR |
-                        NL80211_RRF_AUTO_BW),
+			NL80211_RRF_NO_IR |
+			NL80211_RRF_AUTO_BW),
 
 		/* IEEE 802.11a, channel 52..64 - DFS required */
 		REG_RULE(5260-10, 5320+10, 80, 6, 20,
@@ -1563,6 +1564,7 @@ regdom_intersect(const struct ieee80211_regdomain *rd1,
 static u32 map_regdom_flags(u32 rd_flags)
 {
 	u32 channel_flags = 0;
+
 	if (rd_flags & NL80211_RRF_NO_IR_ALL)
 		channel_flags |= IEEE80211_CHAN_NO_IR;
 	if (rd_flags & NL80211_RRF_DFS)
-- 
2.17.1

