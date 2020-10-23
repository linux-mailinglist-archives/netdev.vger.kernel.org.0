Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01333297494
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 18:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752259AbgJWQhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 12:37:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751827AbgJWQdt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 12:33:49 -0400
Received: from mail.kernel.org (ip5f5ad5a3.dynamic.kabel-deutschland.de [95.90.213.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0D0E2466D;
        Fri, 23 Oct 2020 16:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603470827;
        bh=BrsZBR7koQ2qqaFL6eRPtePdqxTR24Sc0qDlBGevrWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oimw/63ihrsrByKmuEIfkXz18LwbL23JWKnDIaq4NZvGnZjQUJuE4FN72bBwDL4VD
         d7+Z3kniZAlRjNTgEYrQQF2yXs608iKz5N+PisrjCLBkZGdXTvb20GEtFV3A1xKZas
         BnRm7o2v/Eft026HnzfziiCeiVW+ViCc+RZTxqU0=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kW00f-002AwE-J5; Fri, 23 Oct 2020 18:33:45 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v3 21/56] mac80211: fix kernel-doc markups
Date:   Fri, 23 Oct 2020 18:33:08 +0200
Message-Id: <978d35eef2dc76e21c81931804e4eaefbd6d635e.1603469755.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1603469755.git.mchehab+huawei@kernel.org>
References: <cover.1603469755.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some identifiers have different names between their prototypes
and the kernel-doc markup.

Others need to be fixed, as kernel-doc markups should use this format:
        identifier - description

In the specific case of __sta_info_flush(), add a documentation
for sta_info_flush(), as this one is the one used outside
sta_info.c.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 include/net/cfg80211.h  | 9 +++++----
 include/net/mac80211.h  | 7 ++++---
 net/mac80211/sta_info.h | 9 ++++++++-
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 661edfc8722e..d5ab8d99739f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1444,7 +1444,7 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
 				  enum cfg80211_station_type statype);
 
 /**
- * enum station_info_rate_flags - bitrate info flags
+ * enum rate_info_flags - bitrate info flags
  *
  * Used by the driver to indicate the specific rate transmission
  * type for 802.11n transmissions.
@@ -1517,7 +1517,7 @@ struct rate_info {
 };
 
 /**
- * enum station_info_rate_flags - bitrate info flags
+ * enum bss_param_flags - bitrate info flags
  *
  * Used by the driver to indicate the specific rate transmission
  * type for 802.11n transmissions.
@@ -6467,7 +6467,8 @@ void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
 			  struct ieee80211_channel *channel, gfp_t gfp);
 
 /**
- * cfg80211_notify_new_candidate - notify cfg80211 of a new mesh peer candidate
+ * cfg80211_notify_new_peer_candidate - notify cfg80211 of a new mesh peer
+ * 					candidate
  *
  * @dev: network device
  * @macaddr: the MAC address of the new candidate
@@ -7606,7 +7607,7 @@ u32 cfg80211_calculate_bitrate(struct rate_info *rate);
 void cfg80211_unregister_wdev(struct wireless_dev *wdev);
 
 /**
- * struct cfg80211_ft_event - FT Information Elements
+ * struct cfg80211_ft_event_params - FT Information Elements
  * @ies: FT IEs
  * @ies_len: length of the FT IE in bytes
  * @target_ap: target AP's MAC address
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e8e295dae744..dcdba96814a2 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3311,7 +3311,7 @@ enum ieee80211_roc_type {
 };
 
 /**
- * enum ieee80211_reconfig_complete_type - reconfig type
+ * enum ieee80211_reconfig_type - reconfig type
  *
  * This enum is used by the reconfig_complete() callback to indicate what
  * reconfiguration type was completed.
@@ -6334,7 +6334,8 @@ bool ieee80211_tx_prepare_skb(struct ieee80211_hw *hw,
 			      int band, struct ieee80211_sta **sta);
 
 /**
- * Sanity-check and parse the radiotap header of injected frames
+ * ieee80211_parse_tx_radiotap - Sanity-check and parse the radiotap header
+ *				 of injected frames
  * @skb: packet injected by userspace
  * @dev: the &struct device of this 802.11 device
  */
@@ -6389,7 +6390,7 @@ int ieee80211_parse_p2p_noa(const struct ieee80211_p2p_noa_attr *attr,
 void ieee80211_update_p2p_noa(struct ieee80211_noa_data *data, u32 tsf);
 
 /**
- * ieee80211_tdls_oper - request userspace to perform a TDLS operation
+ * ieee80211_tdls_oper_request - request userspace to perform a TDLS operation
  * @vif: virtual interface
  * @peer: the peer's destination address
  * @oper: the requested TDLS operation
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 00ae81e9e1a1..7afd07636b81 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -785,7 +785,7 @@ int sta_info_init(struct ieee80211_local *local);
 void sta_info_stop(struct ieee80211_local *local);
 
 /**
- * sta_info_flush - flush matching STA entries from the STA table
+ * __sta_info_flush - flush matching STA entries from the STA table
  *
  * Returns the number of removed STA entries.
  *
@@ -794,6 +794,13 @@ void sta_info_stop(struct ieee80211_local *local);
  */
 int __sta_info_flush(struct ieee80211_sub_if_data *sdata, bool vlans);
 
+/**
+ * sta_info_flush - flush matching STA entries from the STA table
+ *
+ * Returns the number of removed STA entries.
+ *
+ * @sdata: sdata to remove all stations from
+ */
 static inline int sta_info_flush(struct ieee80211_sub_if_data *sdata)
 {
 	return __sta_info_flush(sdata, false);
-- 
2.26.2

