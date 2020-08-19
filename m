Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B653E249752
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 09:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgHSH25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 03:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726978AbgHSHZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 03:25:19 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2AA9C061373
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:28 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id 88so20470608wrh.3
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OmSKHzIzkJi68F2fKwgFCX3ILOuvM+7+kNq4/3nmwoQ=;
        b=vBNBtXIZSWF7g27W+eeXxr7ZjwuIqe6jFQIMTyxVridWuKQOwrbwEeyB835OdGK1AZ
         YT4VAcdYpQggD5sWVnsFlZ3avb1db8mOMmF8paflWmNkkgqPxXA9hbLBcZ0BIYkvg9UD
         qQO+NOvhJzOqGHQt4uQN9s7e3YYfPsAqQTx0Z7RDCa0UTH2zWeonkDJRquXo9hy1UwKd
         Lxx1sR70MKCwaXOKz6IpLk0t/RGVWverH5HLZBP8OfBp48NlmwWSjOTjLFI8jVWj/SH8
         Jo9WrdBRUL4n7pAyKcYPMcTro9QmpVtXoctyEetp/61ed1wBlqkFW/h5UgnQMS+jVulL
         qIQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OmSKHzIzkJi68F2fKwgFCX3ILOuvM+7+kNq4/3nmwoQ=;
        b=qhkf+P4svAqSvnOHu78mrwu9zv8FFHb44PzHVIlE+oiPjVwxheAKI5jDXnWGDG8FgB
         p94Wmjo/W98wRUXjZ6cEtDZna7lRBHWUeOpFUXyfdH5FhEtQNQj27qqQ2xAdD0l/go2N
         Pk2nQmtyxuPSPzyC/daEpRTSRkJglSh8O0xBY5IeC2MiCmTmd3c8CV6oBu//gl1kxCqN
         50Ed4HVNtu2A8zbeV7kndQFENRwfJPgFTE7hOgn0t42qfR6NkNhjBJwqPSfR6rl8spML
         qZmccG8QHaMGEGFiSdgpfI5n40rasRGa+PLktUvkjZzUPaEM715tTpcK0a7BijIdmc7K
         /nsw==
X-Gm-Message-State: AOAM533xQ9mMrDnIdcz2JcumY+xVsN+fmWZ/vIMbnwV9oy9vY2n9aqqZ
        L8mRvQRmiAvX1E/ITre7OVAWdA==
X-Google-Smtp-Source: ABdhPJyfOF3Q1D/IOxq7KP8+D1xDF7iLQJJIEb/pu6aOZR1FBQagN9KKg3Tos6kds0DO+TYqxC3p5g==
X-Received: by 2002:adf:c981:: with SMTP id f1mr23428625wrh.14.1597821867580;
        Wed, 19 Aug 2020 00:24:27 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id c145sm3795808wmd.7.2020.08.19.00.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 00:24:26 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>
Subject: [PATCH 18/28] wireless: rsi: rsi_91x_mac80211: Fix a few kerneldoc misdemeanours
Date:   Wed, 19 Aug 2020 08:23:52 +0100
Message-Id: <20200819072402.3085022-19-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200819072402.3085022-1-lee.jones@linaro.org>
References: <20200819072402.3085022-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 - File headers should not be kernel-doc
 - Misnaming issues
 - Missing function parameter documentation

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/rsi/rsi_91x_mac80211.c:24: warning: cannot understand function prototype: 'const struct ieee80211_channel rsi_2ghz_channels[] = '
 drivers/net/wireless/rsi/rsi_91x_mac80211.c:739: warning: Function parameter or member 'vif' not described in 'rsi_get_connected_channel'
 drivers/net/wireless/rsi/rsi_91x_mac80211.c:739: warning: Excess function parameter 'adapter' description in 'rsi_get_connected_channel'
 drivers/net/wireless/rsi/rsi_91x_mac80211.c:868: warning: Function parameter or member 'changed_flags' not described in 'rsi_mac80211_conf_filter'
 drivers/net/wireless/rsi/rsi_91x_mac80211.c:868: warning: Excess function parameter 'changed' description in 'rsi_mac80211_conf_filter'
 drivers/net/wireless/rsi/rsi_91x_mac80211.c:946: warning: Function parameter or member 'sta' not described in 'rsi_hal_key_config'
 drivers/net/wireless/rsi/rsi_91x_mac80211.c:1245: warning: Function parameter or member 'vif' not described in 'rsi_perform_cqm'

Cc: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: Siva Rebbagondla <siva8118@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 5c0adb0efc5d6..ce223e680cba6 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Copyright (c) 2014 Redpine Signals Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
@@ -731,7 +731,7 @@ static int rsi_mac80211_config(struct ieee80211_hw *hw,
 /**
  * rsi_get_connected_channel() - This function is used to get the current
  *				 connected channel number.
- * @adapter: Pointer to the adapter structure.
+ * @vif: Pointer to the ieee80211_vif structure.
  *
  * Return: Current connected AP's channel number is returned.
  */
@@ -855,7 +855,7 @@ static void rsi_mac80211_bss_info_changed(struct ieee80211_hw *hw,
 /**
  * rsi_mac80211_conf_filter() - This function configure the device's RX filter.
  * @hw: Pointer to the ieee80211_hw structure.
- * @changed: Changed flags set.
+ * @changed_flags: Changed flags set.
  * @total_flags: Total initial flags set.
  * @multicast: Multicast.
  *
@@ -936,6 +936,7 @@ static int rsi_mac80211_conf_tx(struct ieee80211_hw *hw,
  * @hw: Pointer to the ieee80211_hw structure.
  * @vif: Pointer to the ieee80211_vif structure.
  * @key: Pointer to the ieee80211_key_conf structure.
+ * @sta: Pointer to the ieee80211_sta structure.
  *
  * Return: status: 0 on success, negative error codes on failure.
  */
@@ -1008,7 +1009,6 @@ static int rsi_hal_key_config(struct ieee80211_hw *hw,
  * @hw: Pointer to the ieee80211_hw structure.
  * @cmd: enum set_key_cmd.
  * @vif: Pointer to the ieee80211_vif structure.
- * @sta: Pointer to the ieee80211_sta structure.
  * @key: Pointer to the ieee80211_key_conf structure.
  *
  * Return: status: 0 on success, negative error code on failure.
@@ -1237,6 +1237,7 @@ static int rsi_mac80211_set_rate_mask(struct ieee80211_hw *hw,
  * @common: Pointer to the driver private structure.
  * @bssid: pointer to the bssid.
  * @rssi: RSSI value.
+ * @vif: Pointer to the ieee80211_vif structure.
  */
 static void rsi_perform_cqm(struct rsi_common *common,
 			    u8 *bssid,
-- 
2.25.1

