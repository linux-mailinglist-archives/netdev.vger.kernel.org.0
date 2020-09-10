Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C344263E55
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 09:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgIJHQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 03:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730136AbgIJG4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 02:56:31 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD71C061388
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 23:55:07 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id x23so4473294wmi.3
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 23:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=watylvtavvjnlIiL88AKksk2UODGv6ozdE6QDJoiV0Y=;
        b=NSqRghSS5cx169+IIyEEIA1pUSywUIf49yMu9NjwR/xkjzO8d+5PfOmm/TYRQ/f1mB
         6haERzzrHCa7y3x7YGpFMKZxl18fS2UOM03jbFZpzIxhw5FccwGMDO5OePh43gsFdrB/
         +5aespm/3GiFg8l6B+zhD45sSafvLk2OGp0CJXT8oBww2J9WynDl3a2vwR+iVNQ/RdbZ
         /9QQbYRMc2jiSjkec3omZrbtZFJ62tfzvXKNtCU7vvZIOV+Tj3mdh3z0cUa9dmXXIWS9
         x2RrSWUpMB6gM7zUhAPhiu+5qja0KiPaNBvVhZsENyHzniZz03hBFq+ediLRAtlirXcG
         UQWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=watylvtavvjnlIiL88AKksk2UODGv6ozdE6QDJoiV0Y=;
        b=Yyor2qs3JB3xuspb4RQUhtfq9b9ja7w2gR9LoDRFsWQxSj0MzkSS0kdtcD4y5yH3eM
         PlIs9G+zASIom0JKU6YbiPd3SnUWNANy3Q4IZXTmYykRy396i5DU5qB1lbOPJzIFkxwH
         QS7kOwGMAmexOJUCP9ccwAKNvQ65u8jtQebuiZAzpZnjr24g2GwBxL7ATDA3nwmzDprN
         IFo5cdRsxDA0DVfTu07PNLpKsJd+gi/+PasGmqm12nRfC45kdbri9hdSYWw8RqgryraX
         T3ipTl+E0A9MGICo3TR7dU4mMHN4Ndqc0/VVl9J+sffdRORd9OiwuzljUNsUTkHgrhhp
         DYDg==
X-Gm-Message-State: AOAM532jUbfeDVOgsEtHJv3Bx72i/fhmNFZNDW8lFSPHts2N4YYpHJ6q
        i9T74AnbklScvTAsTBlKZxASQg==
X-Google-Smtp-Source: ABdhPJzWXsjc1qiY/ASKSBUySqorjX/uq7tPPkWgWr2DpV+zKNAZ9eOWEtsMDRTvwiFH7rKrsK7pIw==
X-Received: by 2002:a1c:6254:: with SMTP id w81mr6750493wmb.94.1599720905943;
        Wed, 09 Sep 2020 23:55:05 -0700 (PDT)
Received: from dell.default ([91.110.221.246])
        by smtp.gmail.com with ESMTPSA id m3sm2444028wme.31.2020.09.09.23.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 23:55:05 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Subject: [PATCH 11/29] iwlwifi: dvm: scan: Demote a few nonconformant kernel-doc headers
Date:   Thu, 10 Sep 2020 07:54:13 +0100
Message-Id: <20200910065431.657636-12-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200910065431.657636-1-lee.jones@linaro.org>
References: <20200910065431.657636-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2 of which do not attempt to document their parameters, 1 does a poor job.

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/intel/iwlwifi/dvm/scan.c:193: warning: Function parameter or member 'priv' not described in 'iwl_scan_cancel'
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c:205: warning: Function parameter or member 'priv' not described in 'iwl_scan_cancel_timeout'
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c:570: warning: Function parameter or member 'frame' not described in 'iwl_fill_probe_req'
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c:570: warning: Function parameter or member 'ta' not described in 'iwl_fill_probe_req'
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c:570: warning: Function parameter or member 'ies' not described in 'iwl_fill_probe_req'
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c:570: warning: Function parameter or member 'ie_len' not described in 'iwl_fill_probe_req'
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c:570: warning: Function parameter or member 'ssid' not described in 'iwl_fill_probe_req'
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c:570: warning: Function parameter or member 'ssid_len' not described in 'iwl_fill_probe_req'
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c:570: warning: Function parameter or member 'left' not described in 'iwl_fill_probe_req'

Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: Intel Linux Wireless <linuxwifi@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/scan.c b/drivers/net/wireless/intel/iwlwifi/dvm/scan.c
index 1d8590046ff7d..832fcbb787e98 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/scan.c
@@ -186,7 +186,7 @@ static void iwl_do_scan_abort(struct iwl_priv *priv)
 		IWL_DEBUG_SCAN(priv, "Successfully send scan abort\n");
 }
 
-/**
+/*
  * iwl_scan_cancel - Cancel any currently executing HW scan
  */
 int iwl_scan_cancel(struct iwl_priv *priv)
@@ -196,10 +196,9 @@ int iwl_scan_cancel(struct iwl_priv *priv)
 	return 0;
 }
 
-/**
+/*
  * iwl_scan_cancel_timeout - Cancel any currently executing HW scan
  * @ms: amount of time to wait (in milliseconds) for scan to abort
- *
  */
 void iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
 {
@@ -560,10 +559,9 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 	return added;
 }
 
-/**
+/*
  * iwl_fill_probe_req - fill in all required fields and IE for probe request
  */
-
 static u16 iwl_fill_probe_req(struct ieee80211_mgmt *frame, const u8 *ta,
 			      const u8 *ies, int ie_len, const u8 *ssid,
 			      u8 ssid_len, int left)
-- 
2.25.1

