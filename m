Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72AFA249731
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 09:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbgHSH04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 03:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727971AbgHSHZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 03:25:31 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70AABC061378
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:31 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id d190so1074106wmd.4
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k4LfX+eIfhn84bRaVRDxoln04YUE9cE/pEH4N9WzhVc=;
        b=NcS4Udy+0QfOJQwXZnRDrZJmvaN2ZwNGPq6ZoO600fVBkw9RPWxmkzVYF1VN+3IA4S
         vMwso+oG3++JIQGteREEqHxFeavfGuaPBkGdKGHhrmaIxTJwua3GJDfmuZMwif2kTi09
         AiM5ckOi4lS9Ocz6Z2uP6eVaGKqeyTwpsE2Ash7GQd8jLSb6tiJ2NFRulVjestOWaUWj
         1ct0Djil1qFzn67t0Xh/KhWykwTVKv/iYmie6x2ADQVzHuOACqNGGi6aHqiwzqE+NGCO
         47XiO2WlfQspdYZ9nT8Q/o+X8+gubw0CtquMiFJThj3pyWM503+X4wwgIwSHqbXJRnul
         mRLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k4LfX+eIfhn84bRaVRDxoln04YUE9cE/pEH4N9WzhVc=;
        b=D+vrrXNCsThObRCrg4OvGZhS6DoYG2Pg7oab8BYGW6JgRq3VvDIdfFboDQfN7jnw+K
         81c7Efa5olsWejvXNJJ3cDn97f5lwiI43NEApPd2Ai5ByLnE8Lmq88y2GUWp0VCz7oQ3
         xAVrpuxl7DKFmlpsuNlcfHBtvBsluPE6GeMbSPnNNdpCvsc/gQ6MpVHpIxOBZBhrshDf
         n3pris4euSEItwQGsOOp+xAPuEzvVxtR7lrony6f1hOzwnF1ZVAqQvx1lyv2/+HvuqbW
         d9edaCDqTYegfSDo1qB0oS4Bhch4C2WMdvT+ewIHZwisC2yb3He7lMkmO+sxGiqggjVF
         NRlQ==
X-Gm-Message-State: AOAM532hLLcKkCzYrze3pi5a0TeP8YARQFQF6fZBji4iozcIflzr5gQf
        pex6HYobUA1rkJGegpGieHExwQ==
X-Google-Smtp-Source: ABdhPJz5JRvSNntryjeJKBrQf1j82+qhnh0KHjwJL0WiJkTm9GoN/DXGc4rUsjvdHE+Uo0MZO9FpPg==
X-Received: by 2002:a1c:4104:: with SMTP id o4mr3513338wma.101.1597821870048;
        Wed, 19 Aug 2020 00:24:30 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id c145sm3795808wmd.7.2020.08.19.00.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 00:24:29 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>
Subject: [PATCH 20/28] wireless: rsi: rsi_91x_mgmt: Fix a myriad of documentation issues
Date:   Wed, 19 Aug 2020 08:23:54 +0100
Message-Id: <20200819072402.3085022-21-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200819072402.3085022-1-lee.jones@linaro.org>
References: <20200819072402.3085022-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Too many, not enough, misnamed and formatting problems, all resolved.

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/rsi/rsi_91x_mgmt.c:24: warning: cannot understand function prototype: 'struct bootup_params boot_params_20 = '
 drivers/net/wireless/rsi/rsi_91x_mgmt.c:487: warning: Excess function parameter 'type' description in 'rsi_mgmt_pkt_to_core'
 drivers/net/wireless/rsi/rsi_91x_mgmt.c:538: warning: Function parameter or member 'sta_id' not described in 'rsi_hal_send_sta_notify_frame'
 drivers/net/wireless/rsi/rsi_91x_mgmt.c:538: warning: Function parameter or member 'vif' not described in 'rsi_hal_send_sta_notify_frame'
 drivers/net/wireless/rsi/rsi_91x_mgmt.c:615: warning: Function parameter or member 'sta_id' not described in 'rsi_send_aggregation_params_frame'
 drivers/net/wireless/rsi/rsi_91x_mgmt.c:711: warning: Function parameter or member 'mode' not described in 'rsi_set_vap_capabilities'
 drivers/net/wireless/rsi/rsi_91x_mgmt.c:711: warning: Function parameter or member 'mac_addr' not described in 'rsi_set_vap_capabilities'
 drivers/net/wireless/rsi/rsi_91x_mgmt.c:711: warning: Function parameter or member 'vap_id' not described in 'rsi_set_vap_capabilities'
 drivers/net/wireless/rsi/rsi_91x_mgmt.c:711: warning: Function parameter or member 'vap_status' not described in 'rsi_set_vap_capabilities'
 drivers/net/wireless/rsi/rsi_91x_mgmt.c:711: warning: Excess function parameter 'opmode' description in 'rsi_set_vap_capabilities'
 drivers/net/wireless/rsi/rsi_91x_mgmt.c:794: warning: Function parameter or member 'sta_id' not described in 'rsi_hal_load_key'
 drivers/net/wireless/rsi/rsi_91x_mgmt.c:794: warning: Function parameter or member 'vif' not described in 'rsi_hal_load_key'
 drivers/net/wireless/rsi/rsi_91x_mgmt.c:1053: warning: Function parameter or member 'curchan' not described in 'rsi_band_check'
 drivers/net/wireless/rsi/rsi_91x_mgmt.c:1173: warning: Excess function parameter 'channel' description in 'rsi_send_radio_params_update'
 drivers/net/wireless/rsi/rsi_91x_mgmt.c:1299: warning: Function parameter or member 'sta' not described in 'rsi_send_auto_rate_request'
 drivers/net/wireless/rsi/rsi_91x_mgmt.c:1299: warning: Function parameter or member 'sta_id' not described in 'rsi_send_auto_rate_request'
 drivers/net/wireless/rsi/rsi_91x_mgmt.c:1299: warning: Function parameter or member 'vif' not described in 'rsi_send_auto_rate_request'
 drivers/net/wireless/rsi/rsi_91x_mgmt.c:1459: warning: Function parameter or member 'opmode' not described in 'rsi_inform_bss_status'
 drivers/net/wireless/rsi/rsi_91x_mgmt.c:1459: warning: Function parameter or member 'addr' not described in 'rsi_inform_bss_status'
 drivers/net/wireless/rsi/rsi_91x_mgmt.c:1459: warning: Function parameter or member 'sta' not described in 'rsi_inform_bss_status'
 drivers/net/wireless/rsi/rsi_91x_mgmt.c:1459: warning: Function parameter or member 'sta_id' not described in 'rsi_inform_bss_status'
 drivers/net/wireless/rsi/rsi_91x_mgmt.c:1459: warning: Function parameter or member 'assoc_cap' not described in 'rsi_inform_bss_status'
 drivers/net/wireless/rsi/rsi_91x_mgmt.c:1459: warning: Function parameter or member 'vif' not described in 'rsi_inform_bss_status'
 drivers/net/wireless/rsi/rsi_91x_mgmt.c:1459: warning: Excess function parameter 'bssid' description in 'rsi_inform_bss_status'
 drivers/net/wireless/rsi/rsi_91x_mgmt.c:1543: warning: Function parameter or member 'common' not described in 'rsi_send_block_unblock_frame'
 drivers/net/wireless/rsi/rsi_91x_mgmt.c:1543: warning: Function parameter or member 'block_event' not described in 'rsi_send_block_unblock_frame'
 drivers/net/wireless/rsi/rsi_91x_mgmt.c:1587: warning: Excess function parameter 'Return' description in 'rsi_send_rx_filter_frame'

Cc: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: Siva Rebbagondla <siva8118@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 30 +++++++++++++++++--------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 9cc8a335d519d..c331084bdc170 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Copyright (c) 2014 Redpine Signals Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
@@ -477,7 +477,6 @@ static int rsi_load_radio_caps(struct rsi_common *common)
  * @common: Pointer to the driver private structure.
  * @msg: Pointer to received packet.
  * @msg_len: Length of the received packet.
- * @type: Type of received packet.
  *
  * Return: 0 on success, -1 on failure.
  */
@@ -528,6 +527,8 @@ static int rsi_mgmt_pkt_to_core(struct rsi_common *common,
  * @bssid: bssid.
  * @qos_enable: Qos is enabled.
  * @aid: Aid (unique for all STA).
+ * @sta_id: station id.
+ * @vif: Pointer to the ieee80211_vif structure.
  *
  * Return: status: 0 on success, corresponding negative error code on failure.
  */
@@ -603,6 +604,7 @@ int rsi_hal_send_sta_notify_frame(struct rsi_common *common, enum opmode opmode,
  * @ssn: ssn.
  * @buf_size: buffer size.
  * @event: notification about station connection.
+ * @sta_id: station id.
  *
  * Return: 0 on success, corresponding negative error code on failure.
  */
@@ -699,7 +701,7 @@ static int rsi_program_bb_rf(struct rsi_common *common)
 /**
  * rsi_set_vap_capabilities() - This function send vap capability to firmware.
  * @common: Pointer to the driver private structure.
- * @opmode: Operating mode of device.
+ * @mode: Operating mode of device.
  *
  * Return: 0 on success, corresponding negative error code on failure.
  */
@@ -780,6 +782,8 @@ int rsi_set_vap_capabilities(struct rsi_common *common,
  * @key_type: Type of key: GROUP/PAIRWISE.
  * @key_id: Key index.
  * @cipher: Type of cipher used.
+ * @sta_id: Station id.
+ * @vif: Pointer to the ieee80211_vif structure.
  *
  * Return: 0 on success, -1 on failure.
  */
@@ -1045,6 +1049,7 @@ static int rsi_send_reset_mac(struct rsi_common *common)
 /**
  * rsi_band_check() - This function programs the band
  * @common: Pointer to the driver private structure.
+ * @curchan: Pointer to the current channel structure.
  *
  * Return: 0 on success, corresponding error code on failure.
  */
@@ -1165,7 +1170,6 @@ int rsi_set_channel(struct rsi_common *common,
  * rsi_send_radio_params_update() - This function sends the radio
  *				parameters update to device
  * @common: Pointer to the driver private structure.
- * @channel: Channel value to be set.
  *
  * Return: 0 on success, corresponding error code on failure.
  */
@@ -1289,6 +1293,9 @@ static bool rsi_map_rates(u16 rate, int *offset)
  * rsi_send_auto_rate_request() - This function is to set rates for connection
  *				  and send autorate request to firmware.
  * @common: Pointer to the driver private structure.
+ * @sta: mac80211 station.
+ * @sta_id: station id.
+ * @vif: Pointer to the ieee80211_vif structure.
  *
  * Return: 0 on success, corresponding error code on failure.
  */
@@ -1439,10 +1446,15 @@ static int rsi_send_auto_rate_request(struct rsi_common *common,
  *			     help of sta notify params by sending an internal
  *			     management frame to firmware.
  * @common: Pointer to the driver private structure.
+ * @opmode: Operating mode of device.
  * @status: Bss status type.
- * @bssid: Bssid.
+ * @addr: Address of the register.
  * @qos_enable: Qos is enabled.
  * @aid: Aid (unique for all STAs).
+ * @sta: mac80211 station.
+ * @sta_id: station id.
+ * @assoc_cap: capabilities.
+ * @vif: Pointer to the ieee80211_vif structure.
  *
  * Return: None.
  */
@@ -1535,9 +1547,9 @@ static int rsi_eeprom_read(struct rsi_common *common)
  * This function sends a frame to block/unblock
  * data queues in the firmware
  *
- * @param common Pointer to the driver private structure.
- * @param block event - block if true, unblock if false
- * @return 0 on success, -1 on failure.
+ * @common: Pointer to the driver private structure.
+ * @block_event: Event block if true, unblock if false
+ * returns 0 on success, -1 on failure.
  */
 int rsi_send_block_unblock_frame(struct rsi_common *common, bool block_event)
 {
@@ -1581,7 +1593,7 @@ int rsi_send_block_unblock_frame(struct rsi_common *common, bool block_event)
  * @common: Pointer to the driver private structure.
  * @rx_filter_word: Flags of filter packets
  *
- * @Return: 0 on success, -1 on failure.
+ * Returns 0 on success, -1 on failure.
  */
 int rsi_send_rx_filter_frame(struct rsi_common *common, u16 rx_filter_word)
 {
-- 
2.25.1

