Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC4322029C
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 05:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728131AbgGOC7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 22:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726930AbgGOC7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 22:59:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABCEC061794;
        Tue, 14 Jul 2020 19:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=3PCd8FgrmS1PhNvTlKavM59zD4cPi+6M/pikUlCiTMM=; b=ZHLcUut+5unzw0LXec/tQGCVoF
        AqMoKkfTsRozme76ouJbHQp/98DN8FD5kCQyPi6bxW5n9v8BiLRW1m4Lyms72iZibwSlXZRcZSVcK
        m31yCUfT0EASu9ImLHu+rCDfcdTl1GmhSlxr+Le3L1tbeJn0EigRzNAKgjRb9VNTKnVgCFWROoLxW
        4Z2HLrD+63LzZCm9erPmFc4r8L894kvjyYnPcCiEBz3CTAz2mJjWB3E+EnFK2vF5j8AMVHwqVPu+8
        sKXQ+Nv9La+Bjxh4RdViz7f/2owBIs5lL1DjnW+XgdWb8lDYzRFAPLMUenuMBJCZufORMp3KIGbA7
        8lVKfytQ==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvXdd-0001FT-S4; Wed, 15 Jul 2020 02:59:19 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 01/13 net-next] net: nl80211.h: drop duplicate words in comments
Date:   Tue, 14 Jul 2020 19:59:02 -0700
Message-Id: <20200715025914.28091-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
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
 include/uapi/linux/nl80211.h |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- linux-next-20200714.orig/include/uapi/linux/nl80211.h
+++ linux-next-20200714/include/uapi/linux/nl80211.h
@@ -363,7 +363,7 @@
  * @NL80211_CMD_SET_STATION: Set station attributes for station identified by
  *	%NL80211_ATTR_MAC on the interface identified by %NL80211_ATTR_IFINDEX.
  * @NL80211_CMD_NEW_STATION: Add a station with given attributes to the
- *	the interface identified by %NL80211_ATTR_IFINDEX.
+ *	interface identified by %NL80211_ATTR_IFINDEX.
  * @NL80211_CMD_DEL_STATION: Remove a station identified by %NL80211_ATTR_MAC
  *	or, if no MAC address given, all stations, on the interface identified
  *	by %NL80211_ATTR_IFINDEX. %NL80211_ATTR_MGMT_SUBTYPE and
@@ -383,7 +383,7 @@
  * @NL80211_CMD_DEL_MPATH: Delete a mesh path to the destination given by
  *	%NL80211_ATTR_MAC.
  * @NL80211_CMD_NEW_PATH: Add a mesh path with given attributes to the
- *	the interface identified by %NL80211_ATTR_IFINDEX.
+ *	interface identified by %NL80211_ATTR_IFINDEX.
  * @NL80211_CMD_DEL_PATH: Remove a mesh path identified by %NL80211_ATTR_MAC
  *	or, if no MAC address given, all mesh paths, on the interface identified
  *	by %NL80211_ATTR_IFINDEX.
@@ -934,7 +934,7 @@
  * @NL80211_CMD_SET_COALESCE: Configure coalesce rules or clear existing rules.
  *
  * @NL80211_CMD_CHANNEL_SWITCH: Perform a channel switch by announcing the
- *	the new channel information (Channel Switch Announcement - CSA)
+ *	new channel information (Channel Switch Announcement - CSA)
  *	in the beacon for some time (as defined in the
  *	%NL80211_ATTR_CH_SWITCH_COUNT parameter) and then change to the
  *	new channel. Userspace provides the new channel information (using
@@ -1113,7 +1113,7 @@
  *	randomization may be enabled and configured by specifying the
  *	%NL80211_ATTR_MAC and %NL80211_ATTR_MAC_MASK attributes.
  *	If a timeout is requested, use the %NL80211_ATTR_TIMEOUT attribute.
- *	A u64 cookie for further %NL80211_ATTR_COOKIE use is is returned in
+ *	A u64 cookie for further %NL80211_ATTR_COOKIE use is returned in
  *	the netlink extended ack message.
  *
  *	To cancel a measurement, close the socket that requested it.
@@ -1511,7 +1511,7 @@ enum nl80211_commands {
  *	rates as defined by IEEE 802.11 7.3.2.2 but without the length
  *	restriction (at most %NL80211_MAX_SUPP_RATES).
  * @NL80211_ATTR_STA_VLAN: interface index of VLAN interface to move station
- *	to, or the AP interface the station was originally added to to.
+ *	to, or the AP interface the station was originally added to.
  * @NL80211_ATTR_STA_INFO: information about a station, part of station info
  *	given for %NL80211_CMD_GET_STATION, nested attribute containing
  *	info as possible, see &enum nl80211_sta_info.
@@ -2084,7 +2084,7 @@ enum nl80211_commands {
  * @NL80211_ATTR_STA_SUPPORTED_CHANNELS: array of supported channels.
  *
  * @NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES: array of supported
- *      supported operating classes.
+ *      operating classes.
  *
  * @NL80211_ATTR_HANDLE_DFS: A flag indicating whether user space
  *	controls DFS operation in IBSS mode. If the flag is included in
@@ -2395,7 +2395,7 @@ enum nl80211_commands {
  *      nl80211_txq_stats)
  * @NL80211_ATTR_TXQ_LIMIT: Total packet limit for the TXQ queues for this phy.
  *      The smaller of this and the memory limit is enforced.
- * @NL80211_ATTR_TXQ_MEMORY_LIMIT: Total memory memory limit (in bytes) for the
+ * @NL80211_ATTR_TXQ_MEMORY_LIMIT: Total memory limit (in bytes) for the
  *      TXQ queues for this phy. The smaller of this and the packet limit is
  *      enforced.
  * @NL80211_ATTR_TXQ_QUANTUM: TXQ scheduler quantum (bytes). Number of bytes
@@ -5636,7 +5636,7 @@ enum nl80211_feature_flags {
  * enum nl80211_ext_feature_index - bit index of extended features.
  * @NL80211_EXT_FEATURE_VHT_IBSS: This driver supports IBSS with VHT datarates.
  * @NL80211_EXT_FEATURE_RRM: This driver supports RRM. When featured, user can
- *	can request to use RRM (see %NL80211_ATTR_USE_RRM) with
+ *	request to use RRM (see %NL80211_ATTR_USE_RRM) with
  *	%NL80211_CMD_ASSOCIATE and %NL80211_CMD_CONNECT requests, which will set
  *	the ASSOC_REQ_USE_RRM flag in the association request even if
  *	NL80211_FEATURE_QUIET is not advertized.
@@ -6045,7 +6045,7 @@ enum nl80211_dfs_state {
 };
 
 /**
- * enum enum nl80211_protocol_features - nl80211 protocol features
+ * enum nl80211_protocol_features - nl80211 protocol features
  * @NL80211_PROTOCOL_FEATURE_SPLIT_WIPHY_DUMP: nl80211 supports splitting
  *	wiphy dumps (if requested by the application with the attribute
  *	%NL80211_ATTR_SPLIT_WIPHY_DUMP. Also supported is filtering the
