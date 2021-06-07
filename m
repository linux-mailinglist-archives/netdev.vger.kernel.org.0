Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E67B39E212
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbhFGQPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:15:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231621AbhFGQOm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:14:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC2C76141E;
        Mon,  7 Jun 2021 16:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082370;
        bh=0Tu5Uz0GUjDfRA36Cq/kM4LadVNUM41ye8xS8GOdVhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q+qKzKEFkIuNtIUtgNM7bnoPlSFLk6MMY0ZJgkx5c3cKzHuaY6sI4FXaOfxluayUt
         0UM9mFRU95zpWE0da6mS/ckAKHNUhmvtkX/no9XRddJ+h1jAzbE2gzE6GHeBIS4JRV
         BzDCyU2MFo5P7IiQMJDHMkSkx0ojapvzw7iVed6O8J6obUNptYlOCeXLj8jvj6LO7k
         uGurb6N1SIz/mN474HKqPPwy+z0o4OTgfzvImInQhttckecWYuEARXGQ3vd/Lp9G2X
         xay9Yp/ZJCREdoY6LQDNaZXHq3fsOVk+y/5uIeNrctD/jVa8PTVAe7mRsIhNtv5lwI
         W4j8IevOd/m+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 28/49] mt76: mt7921: remove leftover 80+80 HE capability
Date:   Mon,  7 Jun 2021 12:11:54 -0400
Message-Id: <20210607161215.3583176-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161215.3583176-1-sashal@kernel.org>
References: <20210607161215.3583176-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit d4826d17b3931cf0d8351d8f614332dd4b71efc4 ]

Fixes interop issues with some APs that disable HE Tx if this is present

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210528120304.34751-1-nbd@nbd.name
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index ada943c7a950..2c781b6f89e5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -74,8 +74,7 @@ mt7921_init_he_caps(struct mt7921_phy *phy, enum nl80211_band band,
 				IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_40MHZ_IN_2G;
 		else if (band == NL80211_BAND_5GHZ)
 			he_cap_elem->phy_cap_info[0] =
-				IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_40MHZ_80MHZ_IN_5G |
-				IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_80PLUS80_MHZ_IN_5G;
+				IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_40MHZ_80MHZ_IN_5G;
 
 		he_cap_elem->phy_cap_info[1] =
 			IEEE80211_HE_PHY_CAP1_LDPC_CODING_IN_PAYLOAD;
-- 
2.30.2

