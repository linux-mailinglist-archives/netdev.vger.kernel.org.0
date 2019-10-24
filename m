Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3D2E3B08
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 20:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394152AbfJXScQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 14:32:16 -0400
Received: from smtprelay0156.hostedemail.com ([216.40.44.156]:32801 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726155AbfJXScQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 14:32:16 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 029588E78;
        Thu, 24 Oct 2019 18:32:15 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:800:960:966:973:988:989:1260:1277:1311:1313:1314:1345:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:2899:3138:3139:3140:3141:3142:3353:3865:3867:3868:3870:3871:3874:4250:4321:4385:5007:6117:6119:7875:7903:10004:10400:11026:11473:11658:11914:12043:12296:12297:12438:12555:12760:13141:13230:13439:14096:14097:14181:14394:14659:14721:21080:21433:21451:21611:21627:30046:30054,0,RBL:47.151.135.224:@perches.com:.lbl8.mailshell.net-62.8.0.100 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:26,LUA_SUMMARY:none
X-HE-Tag: vest26_87e0d9178874e
X-Filterd-Recvd-Size: 2764
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Thu, 24 Oct 2019 18:32:13 +0000 (UTC)
Message-ID: <4d53be6c963542878d370ff1a6dc7c3a89b28d23.camel@perches.com>
Subject: [PATCH] mac80211.h: Trivial typo fixes
From:   Joe Perches <joe@perches.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Thu, 24 Oct 2019 11:32:12 -0700
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just typos...

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/net/mac80211.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d69081..edd6d0 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1702,7 +1702,7 @@ struct wireless_dev *ieee80211_vif_to_wdev(struct ieee80211_vif *vif);
  *	%IEEE80211_KEY_FLAG_SW_MGMT_TX flag to encrypt such frames in SW.
  * @IEEE80211_KEY_FLAG_GENERATE_IV_MGMT: This flag should be set by the
  *	driver for a CCMP/GCMP key to indicate that is requires IV generation
- *	only for managment frames (MFP).
+ *	only for management frames (MFP).
  * @IEEE80211_KEY_FLAG_RESERVE_TAILROOM: This flag should be set by the
  *	driver for a key to indicate that sufficient tailroom must always
  *	be reserved for ICV or MIC, even when HW encryption is enabled.
@@ -2626,7 +2626,7 @@ ieee80211_get_alt_retry_rate(const struct ieee80211_hw *hw,
  * @hw: the hardware
  * @skb: the skb
  *
- * Free a transmit skb. Use this funtion when some failure
+ * Free a transmit skb. Use this function when some failure
  * to transmit happened and thus status cannot be reported.
  */
 void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb);
@@ -3193,7 +3193,7 @@ enum ieee80211_rate_control_changed {
  *
  * @IEEE80211_ROC_TYPE_NORMAL: There are no special requirements for this ROC.
  * @IEEE80211_ROC_TYPE_MGMT_TX: The remain on channel request is required
- *	for sending managment frames offchannel.
+ *	for sending management frames offchannel.
  */
 enum ieee80211_roc_type {
 	IEEE80211_ROC_TYPE_NORMAL = 0,
@@ -5616,7 +5616,7 @@ void ieee80211_iter_keys_rcu(struct ieee80211_hw *hw,
 
 /**
  * ieee80211_iter_chan_contexts_atomic - iterate channel contexts
- * @hw: pointre obtained from ieee80211_alloc_hw().
+ * @hw: pointer obtained from ieee80211_alloc_hw().
  * @iter: iterator function
  * @iter_data: data passed to iterator function
  *


