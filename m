Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E771824CE21
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 08:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbgHUGlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 02:41:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726057AbgHUGle (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 02:41:34 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9264120732;
        Fri, 21 Aug 2020 06:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597992093;
        bh=zx1WG7372o1PzR/3ixloWF65ocSDbw/i79bZ5GZdrto=;
        h=Date:From:To:Cc:Subject:From;
        b=nCS0QGqwHdGXyMA8O6IaQbCQy5vQjpcWkIhd7UOSwZhj0uuEnctoc32wMXe8S0kYC
         2rd7swzD7dTpFszzAkbNKv6OXKk4xogU1K4YCSZMzlNm5ZHQmBGB05xrckmugfsvMn
         MXgS9xMSR9WBCRnjRAzxWvn30UaYU60NVWTonAUI=
Date:   Fri, 21 Aug 2020 01:47:20 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] mwifiex: Use fallthrough pseudo-keyword
Message-ID: <20200821064720.GA22182@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the existing /* fall through */ comments and its variants with
the new pseudo-keyword macro fallthrough[1].

[1] https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 8 ++++----
 drivers/net/wireless/marvell/mwifiex/ie.c       | 2 +-
 drivers/net/wireless/marvell/mwifiex/scan.c     | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 96848fa0e417..a6b9dc6700b1 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -1163,7 +1163,7 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 		case NL80211_IFTYPE_UNSPECIFIED:
 			mwifiex_dbg(priv->adapter, INFO,
 				    "%s: kept type as IBSS\n", dev->name);
-			/* fall through */
+			fallthrough;
 		case NL80211_IFTYPE_ADHOC:	/* This shouldn't happen */
 			return 0;
 		default:
@@ -1194,7 +1194,7 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 		case NL80211_IFTYPE_UNSPECIFIED:
 			mwifiex_dbg(priv->adapter, INFO,
 				    "%s: kept type as STA\n", dev->name);
-			/* fall through */
+			fallthrough;
 		case NL80211_IFTYPE_STATION:	/* This shouldn't happen */
 			return 0;
 		default:
@@ -1217,7 +1217,7 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 		case NL80211_IFTYPE_UNSPECIFIED:
 			mwifiex_dbg(priv->adapter, INFO,
 				    "%s: kept type as AP\n", dev->name);
-			/* fall through */
+			fallthrough;
 		case NL80211_IFTYPE_AP:		/* This shouldn't happen */
 			return 0;
 		default:
@@ -1257,7 +1257,7 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 		case NL80211_IFTYPE_UNSPECIFIED:
 			mwifiex_dbg(priv->adapter, INFO,
 				    "%s: kept type as P2P\n", dev->name);
-			/* fall through */
+			fallthrough;
 		case NL80211_IFTYPE_P2P_CLIENT:
 		case NL80211_IFTYPE_P2P_GO:
 			return 0;
diff --git a/drivers/net/wireless/marvell/mwifiex/ie.c b/drivers/net/wireless/marvell/mwifiex/ie.c
index 811abe963af2..40e99eaf5a30 100644
--- a/drivers/net/wireless/marvell/mwifiex/ie.c
+++ b/drivers/net/wireless/marvell/mwifiex/ie.c
@@ -374,7 +374,7 @@ static int mwifiex_uap_parse_tail_ies(struct mwifiex_private *priv,
 						    (const u8 *)hdr,
 						    token_len))
 				break;
-			/* fall through */
+			fallthrough;
 		default:
 			if (ie_len + token_len > IEEE_MAX_IE_SIZE) {
 				err = -EINVAL;
diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index 2fb69a590bd8..c2a685f63e95 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -1328,7 +1328,7 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 
 		case WLAN_EID_CHANNEL_SWITCH:
 			bss_entry->chan_sw_ie_present = true;
-			/* fall through */
+			fallthrough;
 		case WLAN_EID_PWR_CAPABILITY:
 		case WLAN_EID_TPC_REPORT:
 		case WLAN_EID_QUIET:
-- 
2.27.0

