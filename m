Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD677374E4B
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 06:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhEFESJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 00:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhEFESI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 00:18:08 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F4AC061574;
        Wed,  5 May 2021 21:17:11 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id k19so4189240pfu.5;
        Wed, 05 May 2021 21:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=cUcH8PCyuKxxWH0B21SELBwroBtwWU2e6ZCH9Q1x7rE=;
        b=rp9odEzzlhnx82O9YcW7k9uR9NfXdvb8wb3fXQaAUW/G7/OCn0xVyOc+rSHAWTCy0x
         L8wkrb3OuMMIuFtrNFY6YqiGj+w31uHljZ22HNp6nADLSBPoDdCb0fjFBQrig2DRGNNR
         z650tScq37rJkRw5OB7QjC02w+qHh2nSCYD8gt12iXvTXS9DApBoJ2xMQPtovv3Hll1/
         oHDnc1/zjNvo7Ea3VI/3lm2PR1BCzlBIhoEUbWU4a0nBqSZxap8U0kMwu+b/x3iu5TIu
         D1r85ZZ5jEUFuDWTElSv4mOvLs5b7oAHNpfBkt/2KJDlvsThNFHHIZo/UsPnJhF57+At
         xjww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=cUcH8PCyuKxxWH0B21SELBwroBtwWU2e6ZCH9Q1x7rE=;
        b=dXoMVZyN0dBi2TeoJmXsvmb99WlvWxL/UBkQxOfFJoyILfKVvqKk+dHo4IsUjk8kN4
         CMWWZALYId6dwiBVT1k1erw4Ci8thtu3AYFQQ9beg8K1ROHe1tsAC+G2cj+lqw93wNDI
         ko489SndFiVSz6XJBPEFe6BfpQupFnFFrvTxGdAv80UB9Y9Cue4b7CTQjCtrvF6TuSRH
         43TBk7Nl3eEHpbwSi42qS4bv3T3NxowIBV+0sHaoRaagl//HpmVmOZS+iWdUHJ8GKYP3
         YtZkLMtp8rKAnzl0aSDF0JNppDQsXgZ8RhPqlQI+qyGjceAMqObZnpKfOA4b56PJMSXm
         TZLQ==
X-Gm-Message-State: AOAM531H4N9XWR4+9oV36S7fr1680Cpzb8HSvdnFTIC1OAVfalosZgpY
        eLIyu58Vp4TKN4o13bIjk0O5mCapNA8=
X-Google-Smtp-Source: ABdhPJxWiCMxR3OdZ8ocwtGr+7peeUVDXrYe/IuxOxB3UAgxPnUzqRhQM1QGrXneL5YZIbXVcbAd9g==
X-Received: by 2002:a62:ee09:0:b029:211:1113:2e7c with SMTP id e9-20020a62ee090000b029021111132e7cmr2262101pfi.49.1620274630665;
        Wed, 05 May 2021 21:17:10 -0700 (PDT)
Received: from user ([2001:4490:4409:27b0:f9dc:322b:84de:6680])
        by smtp.gmail.com with ESMTPSA id m188sm672343pfm.167.2021.05.05.21.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 21:17:09 -0700 (PDT)
Date:   Thu, 6 May 2021 09:47:03 +0530
From:   Saurav Girepunje <saurav.girepunje@gmail.com>
To:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     saurav.girepunje@hotmail.com
Subject: [PATCH] net: mac80211: remove unused local variable
Message-ID: <20210506041703.GA5681@user>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ieee80211_process_addba_request() first argument is never
used.

Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
---
 net/mac80211/agg-rx.c      | 3 +--
 net/mac80211/ieee80211_i.h | 3 +--
 net/mac80211/iface.c       | 4 ++--
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index cce28e3b2232..3075570e7968 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -471,8 +471,7 @@ static void __ieee80211_start_rx_ba_session(struct sta_info *sta,
 	mutex_unlock(&sta->ampdu_mlme.mtx);
 }

-void ieee80211_process_addba_request(struct ieee80211_local *local,
-				     struct sta_info *sta,
+void ieee80211_process_addba_request(struct sta_info *sta,
 				     struct ieee80211_mgmt *mgmt,
 				     size_t len)
 {
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 8fcbaa1eedf3..9e3e5aaddaf6 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1859,8 +1859,7 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
 				  struct sta_info *sta,
 				  struct ieee80211_mgmt *mgmt,
 				  size_t len);
-void ieee80211_process_addba_request(struct ieee80211_local *local,
-				     struct sta_info *sta,
+void ieee80211_process_addba_request(struct sta_info *sta,
 				     struct ieee80211_mgmt *mgmt,
 				     size_t len);

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 7032a2b59249..4fe599bf9f9c 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1351,8 +1351,8 @@ static void ieee80211_iface_work(struct work_struct *work)
 			if (sta) {
 				switch (mgmt->u.action.u.addba_req.action_code) {
 				case WLAN_ACTION_ADDBA_REQ:
-					ieee80211_process_addba_request(
-							local, sta, mgmt, len);
+					ieee80211_process_addba_request(sta,
+									mgmt, len);
 					break;
 				case WLAN_ACTION_ADDBA_RESP:
 					ieee80211_process_addba_resp(local, sta,
--
2.25.1

