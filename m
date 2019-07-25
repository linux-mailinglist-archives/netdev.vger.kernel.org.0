Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDDED757A9
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 21:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbfGYTPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 15:15:24 -0400
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:39474 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfGYTPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 15:15:23 -0400
Received: from localhost.localdomain ([92.140.204.221])
        by mwinf5d13 with ME
        id h7EX2000F4n7eLC037EpXF; Thu, 25 Jul 2019 21:15:21 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 25 Jul 2019 21:15:21 +0200
X-ME-IP: 92.140.204.221
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     johannes@sipsolutions.net, kvalo@codeaurora.org,
        davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] mac80211_hwsim: Fix a typo in the name of function 'mac80211_hswim_he_capab()'
Date:   Thu, 25 Jul 2019 21:13:28 +0200
Message-Id: <20190725191328.18010-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function name should be 'mac80211_hwsim_he_capab()' (s wand w
switched) to be consistent with the rest of the file.
Fix and use it.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/wireless/mac80211_hwsim.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index b5274d1f30fa..64b0e51f8e8d 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2595,7 +2595,7 @@ static const struct ieee80211_sband_iftype_data he_capa_5ghz = {
 	},
 };
 
-static void mac80211_hswim_he_capab(struct ieee80211_supported_band *sband)
+static void mac80211_hwsim_he_capab(struct ieee80211_supported_band *sband)
 {
 	if (sband->band == NL80211_BAND_2GHZ)
 		sband->iftype_data =
@@ -2898,7 +2898,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 		sband->ht_cap.mcs.rx_mask[1] = 0xff;
 		sband->ht_cap.mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
 
-		mac80211_hswim_he_capab(sband);
+		mac80211_hwsim_he_capab(sband);
 
 		hw->wiphy->bands[band] = sband;
 	}
-- 
2.20.1

