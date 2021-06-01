Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC97C3977DA
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 18:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbhFAQWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 12:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbhFAQWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 12:22:47 -0400
Received: from mail-lj1-x264.google.com (mail-lj1-x264.google.com [IPv6:2a00:1450:4864:20::264])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07A3C06174A
        for <netdev@vger.kernel.org>; Tue,  1 Jun 2021 09:21:04 -0700 (PDT)
Received: by mail-lj1-x264.google.com with SMTP id p20so20044248ljj.8
        for <netdev@vger.kernel.org>; Tue, 01 Jun 2021 09:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flowbird.group; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=In/GkSHT/rgtsc6Ydue2MWFy5Ook8SgyWRFS6hmgR5E=;
        b=YKq+L2DtNMcsyYCaHkMqQSRpDrNBXJoN4hEECDawVb1DwrIir6Nlb4oX8Bk9+aKSln
         t5y5TdSPmWBjUcAnd4AoUGE/D11UUAnhbGRTmUfHvsUrMJ9mkLg/sIITSO2RYg+HN3+w
         F6APyqxk9qRXLWpPoZ1z2rrhfgprxc1b0eNYd7H4RM1PwwXnrppXfYhneCg28UEuDM5d
         2OGOT07qXtizYBO0bnbWiXPzxnNDpD0XR/oxdNKhLJ+K2qbo/jWnEIcqXsCBUtWTgck5
         9GW1PfNZxHUxe2EHbNnzz87vTcN5m9p5hyeE5f1DJ+m6AVWnGxYXrygOdXzY2Ib3j+lO
         oPlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=In/GkSHT/rgtsc6Ydue2MWFy5Ook8SgyWRFS6hmgR5E=;
        b=dbWwdORcjJF7UKWEa2N2VYIGfHCO3YX/75NZbMRkWlnfsV1lg7ns07vmgrLTPidJ2K
         Sy1StAxDmPddoTjYCYQ54KHzyV2Lbj8KHPCFwgPGJPm3UmTh3mZ78YazQTHa694eX5l6
         CRyTgJMvaR2kA5ddAbEut2c2LB5m+TelS1xXIlkVzpmBhpsbXv4H8RETvCcA7L8taSFt
         QTw+Tuhn7RV97GvNe1FyJze7XdTbGoI+724c9TIQfPFy/+49Cmu2jNZ8vbdg4kSwzu2s
         qu/O/VZqUmBv8QBCYcsO8ee1C5v4ccyaaYBXlr59Nyn0exDCAr3Vu9Vv7aL74c0zMNse
         BvOQ==
X-Gm-Message-State: AOAM533gWPiAi2qH0mscgEs9aLLHeAL4ORp6bqbiUuJuEVpVtNZ1Rmw9
        fAOmwTkaJCh7Wv2Two7mWEtDtasElsaxGmi2shyFy39x89Qk
X-Google-Smtp-Source: ABdhPJyBKXLzlICbLObTVI8H+umyehJ1gJWyJA7M7jf+bsMkLTbXmXKJGRqj7qjgcAGw2zucxg5IMH40Uamb
X-Received: by 2002:a2e:b4b0:: with SMTP id q16mr21472002ljm.434.1622564461573;
        Tue, 01 Jun 2021 09:21:01 -0700 (PDT)
Received: from mta1.parkeon.com ([185.149.63.251])
        by smtp-relay.gmail.com with ESMTPS id w18sm403369lji.37.2021.06.01.09.21.01
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Tue, 01 Jun 2021 09:21:01 -0700 (PDT)
X-Relaying-Domain: flowbird.group
Received: from [172.16.13.234] (port=34414 helo=PC12445-BES.dynamic.besancon.parkeon.com)
        by mta1.parkeon.com with esmtp (Exim 4.71)
        (envelope-from <martin.fuzzey@flowbird.group>)
        id 1lo78W-0006tW-MD; Tue, 01 Jun 2021 18:21:00 +0200
From:   Martin Fuzzey <martin.fuzzey@flowbird.group>
To:     Amitkumar Karwar <amitkarwar@gmail.com>
Cc:     stable@vger.kernel.org, Siva Rebbagondla <siva8118@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>, Marek Vasut <marex@denx.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2] rsi: fix AP mode with WPA failure due to encrypted EAPOL
Date:   Tue,  1 Jun 2021 18:19:53 +0200
Message-Id: <1622564459-24430-1-git-send-email-martin.fuzzey@flowbird.group>
X-Mailer: git-send-email 1.9.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In AP mode WPA2-PSK connections were not established.

The reason was that the AP was sending the first message
of the 4 way handshake encrypted, even though no pairwise
key had (correctly) yet been set.

Encryption was enabled if the "security_enable" driver flag
was set and encryption was not explicitly disabled by
IEEE80211_TX_INTFL_DONT_ENCRYPT.

However security_enable was set when *any* key, including
the AP GTK key, had been set which was causing unwanted
encryption even if no key was avaialble for the unicast
packet to be sent.

Fix this by adding a check that we have a key and drop
the old security_enable driver flag which is insufficient
and redundant.

The Redpine downstream out of tree driver does it this way too.

Regarding the Fixes tag the actual code being modified was
introduced earlier, with the original driver submission, in
dad0d04fa7ba ("rsi: Add RS9113 wireless driver"), however
at that time AP mode was not yet supported so there was
no bug at that point.

So I have tagged the introduction of AP support instead
which was part of the patch set "rsi: support for AP mode" [1]

It is not clear whether AP WPA has ever worked, I can see nothing
on the kernel side that broke it afterwards yet the AP support
patch series says "Tests are performed to confirm aggregation,
connections in WEP and WPA/WPA2 security."

One possibility is that the initial tests were done with a modified
userspace (hostapd).

[1] https://www.spinics.net/lists/linux-wireless/msg165302.html

Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
Fixes: 38ef62353acb ("rsi: security enhancements for AP mode")
CC: stable@vger.kernel.org
---

V2:
        Remove security_enable driver flag
        Remove unnecessary parantheses
        Improve $SUBJECT

 drivers/net/wireless/rsi/rsi_91x_hal.c      | 2 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 3 ---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 3 +--
 drivers/net/wireless/rsi/rsi_main.h         | 1 -
 4 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index ce98921..a51cb0a 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -203,7 +203,7 @@ int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 		wh->frame_control |= cpu_to_le16(RSI_SET_PS_ENABLE);
 
 	if ((!(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT)) &&
-	    (common->secinfo.security_enable)) {
+	    info->control.hw_key) {
 		if (rsi_is_cipher_wep(common))
 			ieee80211_size += 4;
 		else
diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 1602530..57c9e35 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -1028,7 +1028,6 @@ static int rsi_mac80211_set_key(struct ieee80211_hw *hw,
 	mutex_lock(&common->mutex);
 	switch (cmd) {
 	case SET_KEY:
-		secinfo->security_enable = true;
 		status = rsi_hal_key_config(hw, vif, key, sta);
 		if (status) {
 			mutex_unlock(&common->mutex);
@@ -1047,8 +1046,6 @@ static int rsi_mac80211_set_key(struct ieee80211_hw *hw,
 		break;
 
 	case DISABLE_KEY:
-		if (vif->type == NL80211_IFTYPE_STATION)
-			secinfo->security_enable = false;
 		rsi_dbg(ERR_ZONE, "%s: RSI del key\n", __func__);
 		memset(key, 0, sizeof(struct ieee80211_key_conf));
 		status = rsi_hal_key_config(hw, vif, key, sta);
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 33c76d3..b6d050a 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1803,8 +1803,7 @@ int rsi_send_wowlan_request(struct rsi_common *common, u16 flags,
 			RSI_WIFI_MGMT_Q);
 	cmd_frame->desc.desc_dword0.frame_type = WOWLAN_CONFIG_PARAMS;
 	cmd_frame->host_sleep_status = sleep_status;
-	if (common->secinfo.security_enable &&
-	    common->secinfo.gtk_cipher)
+	if (common->secinfo.gtk_cipher)
 		flags |= RSI_WOW_GTK_REKEY;
 	if (sleep_status)
 		cmd_frame->wow_flags = flags;
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index a1065e5..0f53585 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -151,7 +151,6 @@ enum edca_queue {
 };
 
 struct security_info {
-	bool security_enable;
 	u32 ptk_cipher;
 	u32 gtk_cipher;
 };
-- 
1.9.1

