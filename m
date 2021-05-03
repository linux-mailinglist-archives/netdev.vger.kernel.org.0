Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCD637192A
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 18:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbhECQXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 12:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbhECQXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 12:23:07 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7BFC06174A;
        Mon,  3 May 2021 09:22:13 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id f11-20020a17090a638bb02901524d3a3d48so6046066pjj.3;
        Mon, 03 May 2021 09:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=5DHl9TH+vewH7WPAMN5qqbONOKccpVnMyLI5oNyNcgs=;
        b=HzDkVw2Vfc7plARSpLKHN/hcJOBkP5DAz8su2aJPyr37bs5YH8Qp25t8OrV6q8BOVQ
         NkWHBQYr5+q5Edl/nktYPIhC8X8najTbUzKD4KLUNw79EN1uxBLlxRjP/RvOLEQvmjA4
         lSLUiqCWzPztfhqhmbTg8WFc0RgHcEIlcWfcSJMmvW1iwPtAjCe97DYEiEbtaXMbn9J1
         vRiYzZmJGx1gGfNNO6coLd88YF0hDE43GegGXXM75exPPg2JqsmLPpXKkck4zVnTUM4r
         +0yoUaA212qQtmwu45KLWo3U+iStkOPmDrqQ+oKy3UfuUlB0t3iIozvD4NsKCD7hYdDE
         6Deg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=5DHl9TH+vewH7WPAMN5qqbONOKccpVnMyLI5oNyNcgs=;
        b=T3t5mT4mN5TeVcPz87LHqMBihbzuXN9ZN5XIpRBKIyXuS/iycxYzhPEB2WXv18xcfM
         a0zyVu6Mz1C4Z/ws65JV7WL1XJ71ulxkYl3PZQQla+Zzm7aJOJbtQeULYrBpRy+ShlGi
         89ITxZASQ5KfCHnqdochWbNkN9pQ3lNn6B0MqMxvFArQhgF4+92iCINuOCx8G7eqpIM0
         PWVupk0JMgdUs892PAokF31tm+AxKRM6BKJ7elIzw6Ir0CQtfOeUpu0mdXcH8ByC2Hsi
         RdwmWSVC+LZaV71dEXIHEmM+dtWIYA/jEWMe76kr5RK9oJkvBxwlNrkmrJeR00m118bp
         KMIQ==
X-Gm-Message-State: AOAM531zq35HE1CZW6b1p/bAQsttRgcWVTz7xD0KkkJm0Yd4IZ9MPh3n
        iPgGT9+gPKaa5I62tGITxWI=
X-Google-Smtp-Source: ABdhPJy57Oze2sG2KoqhYMkWVtCBcB54276UmTfwilVTs8NQOgO5R8LdpByLoz+0iFec3VX/1TNyjg==
X-Received: by 2002:a17:902:d48a:b029:ee:dc91:862 with SMTP id c10-20020a170902d48ab02900eedc910862mr4353002plg.60.1620058933037;
        Mon, 03 May 2021 09:22:13 -0700 (PDT)
Received: from localhost ([157.45.34.47])
        by smtp.gmail.com with ESMTPSA id 33sm73982pgq.21.2021.05.03.09.22.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 May 2021 09:22:12 -0700 (PDT)
Date:   Mon, 3 May 2021 21:52:04 +0530
From:   Shubhankar Kuranagatti <shubhankarvk@gmail.com>
To:     johannes@sipsolutions.net
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: wireless: scan.c: Remove space at start of line
Message-ID: <20210503162204.3lvtlgctprrez4uc@kewl-virtual-machine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Spaces have been removed at the start of the line
Instead of spaces tabs have been used
This is done to maintain code uniformity.

Signed-off-by: Shubhankar Kuranagatti <shubhankarvk@gmail.com>
---
 net/wireless/scan.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 019952d4fc7d..0dbdf4e820cc 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -72,7 +72,7 @@
 static int bss_entries_limit = 1000;
 module_param(bss_entries_limit, int, 0644);
 MODULE_PARM_DESC(bss_entries_limit,
-                 "limit to number of scan BSS entries (per wiphy, default 1000)");
+		"limit to number of scan BSS entries (per wiphy, default 1000)");
 
 #define IEEE80211_SCAN_RESULT_EXPIRE	(30 * HZ)
 
@@ -164,6 +164,7 @@ static inline void bss_ref_put(struct cfg80211_registered_device *rdev,
 
 	if (bss->pub.hidden_beacon_bss) {
 		struct cfg80211_internal_bss *hbss;
+
 		hbss = container_of(bss->pub.hidden_beacon_bss,
 				    struct cfg80211_internal_bss,
 				    pub);
@@ -1154,6 +1155,7 @@ int cfg80211_stop_sched_scan_req(struct cfg80211_registered_device *rdev,
 
 	if (!driver_initiated) {
 		int err = rdev_sched_scan_stop(rdev, req->dev, req->reqid);
+
 		if (err)
 			return err;
 	}
@@ -1181,7 +1183,7 @@ int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 }
 
 void cfg80211_bss_age(struct cfg80211_registered_device *rdev,
-                      unsigned long age_secs)
+		unsigned long age_secs)
 {
 	struct cfg80211_internal_bss *bss;
 	unsigned long age_jiffies = msecs_to_jiffies(age_secs * MSEC_PER_SEC);
@@ -1987,7 +1989,7 @@ static const struct element
 	/*
 	 * If it is not the last subelement in current MBSSID IE or there isn't
 	 * a next MBSSID IE - profile is complete.
-	*/
+	 */
 	if ((sub_elem->data + sub_elem->datalen < mbssid_end - 1) ||
 	    !next_mbssid)
 		return NULL;
@@ -2727,6 +2729,7 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 			if (wreq && wreq->num_channels) {
 				int k;
 				int wiphy_freq = wiphy->bands[band]->channels[j].center_freq;
+
 				for (k = 0; k < wreq->num_channels; k++) {
 					struct iw_freq *freq =
 						&wreq->channel_list[k];
-- 
2.17.1

