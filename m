Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A786724975D
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 09:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgHSH3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 03:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbgHSHYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 03:24:21 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543BDC06135B
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:16 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id 3so1128916wmi.1
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DOjbJX83gJDY8f1/vIcwdpJ4Kow88m/y6XKP96xRsEA=;
        b=Sd8w5fY/YPVd1DFQ/uqbWtPwoLLwn1dYdDDX+iT0U6ENroYU/Zyf5KLdE6h1zDHyGx
         NkaqtyeOwci4grfqjJy1Cdo0GioYVQIDoqZIUkjEdGmWHUr5a1l03N2moGXVaD3TXLxh
         Su8+5wo/MFPFX2x4NdH3hPsXyy6p4jBKPR4YJ63U5bJbCwSGqrV2z18O52x8wnde4dD7
         Kz3L1bsKYeuGP4883KTZxMwiIr05VrFl6tiNj1/fZ6P6h3ojxTe8Wzaov+PZnfpxCmEI
         2Mo9JHbLonssqsCxB9fbMX9ZkFVrame84cD2oG+EjyxbWZAydCKGuN0B4y5QZ5mgrltA
         mvaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DOjbJX83gJDY8f1/vIcwdpJ4Kow88m/y6XKP96xRsEA=;
        b=tqeH2wNJ3DQ9dXB4XC7zU/YuYeZAtRey6XaDtRMXchAdNjOga0raZ+phi1W8JSd+2W
         HXwXOj28bfmqSXRbqT7now5dnzgp1UPz2toC/QqSXJNfWxNBwCqezFzrNeQ4m9jqWa+p
         Y/myUagwqYQjuZmR1sfKbpG8xGLNyHKhxMyuKyR87tMLtio8DaJkEGsIb59tKWf1S7bc
         gT3eiL6LUdVXLkDKFpGSXk6ggllPMrlli2WpXc74Ya73LJSO7gwqUuNmvv/K+X2Si0AZ
         MaRac2K/WBjUqHmyy+5xp7ncGfZfPX/br111Hy87hzTBOsfwLsAC3ejUJOWZqycPEZLL
         p5Pg==
X-Gm-Message-State: AOAM5302C69QdP+Jz9gBKpjj7wgIUPLtCRnN2DvTBx+c4L+kRP1EnQjk
        FCz/xZJyYgqzOj55xoeVdzJKoosDemPZdg==
X-Google-Smtp-Source: ABdhPJy0UFYNRBMrq6eI6vpVl0W7txr6OhB2et0zRKMpSV4SVc6y6PGjO2CMl8P+H5NxD1g3ELgsig==
X-Received: by 2002:a1c:7e02:: with SMTP id z2mr3573600wmc.138.1597821854997;
        Wed, 19 Aug 2020 00:24:14 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id c145sm3795808wmd.7.2020.08.19.00.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 00:24:14 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Subject: [PATCH 08/28] wireless: intel: iwlwifi: rs: Demote non-compliant kernel-doc headers
Date:   Wed, 19 Aug 2020 08:23:42 +0100
Message-Id: <20200819072402.3085022-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200819072402.3085022-1-lee.jones@linaro.org>
References: <20200819072402.3085022-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

None of these headers attempt to document any function parameters.

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/intel/iwlwifi/dvm/rs.c:165: warning: cannot understand function prototype: 'const u16 expected_tpt_legacy[IWL_RATE_COUNT] = '
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c:329: warning: Function parameter or member 'priv' not described in 'rs_program_fix_rate'
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c:329: warning: Function parameter or member 'lq_sta' not described in 'rs_program_fix_rate'
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c:452: warning: Function parameter or member 'tbl' not described in 'rs_collect_tx_data'
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c:452: warning: Function parameter or member 'scale_index' not described in 'rs_collect_tx_data'
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c:452: warning: Function parameter or member 'attempts' not described in 'rs_collect_tx_data'
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c:452: warning: Function parameter or member 'successes' not described in 'rs_collect_tx_data'
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c:681: warning: Function parameter or member 'sta' not described in 'rs_use_green'
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c:702: warning: Function parameter or member 'lq_sta' not described in 'rs_get_supported_rates'
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c:702: warning: Function parameter or member 'hdr' not described in 'rs_get_supported_rates'
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c:702: warning: Function parameter or member 'rate_type' not described in 'rs_get_supported_rates'
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c:2628: warning: duplicate section name 'NOTE'
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c:2632: warning: Function parameter or member 'priv' not described in 'rs_initialize_lq'
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c:2632: warning: Function parameter or member 'sta' not described in 'rs_initialize_lq'
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c:2632: warning: Function parameter or member 'lq_sta' not described in 'rs_initialize_lq'

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
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
index 4fa4eab2d7f38..548540dd0c0f7 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
@@ -151,7 +151,7 @@ static void rs_dbgfs_set_mcs(struct iwl_lq_sta *lq_sta,
 {}
 #endif
 
-/**
+/*
  * The following tables contain the expected throughput metrics for all rates
  *
  *	1, 2, 5.5, 11, 6, 9, 12, 18, 24, 36, 48, 54, 60 MBits
@@ -318,7 +318,7 @@ static u8 rs_tl_add_packet(struct iwl_lq_sta *lq_data,
 }
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-/**
+/*
  * Program the device to use fixed rate for frame transmit
  * This is for debugging/testing only
  * once the device start use fixed rate, we need to reload the module
@@ -440,7 +440,7 @@ static s32 get_expected_tpt(struct iwl_scale_tbl_info *tbl, int rs_index)
 	return 0;
 }
 
-/**
+/*
  * rs_collect_tx_data - Update the success/failure sliding window
  *
  * We keep a sliding window of the last 62 packets transmitted
@@ -673,7 +673,7 @@ static int rs_toggle_antenna(u32 valid_ant, u32 *rate_n_flags,
 	return 1;
 }
 
-/**
+/*
  * Green-field mode is valid if the station supports it and
  * there are no non-GF stations present in the BSS.
  */
@@ -689,7 +689,7 @@ static bool rs_use_green(struct ieee80211_sta *sta)
 	return false;
 }
 
-/**
+/*
  * rs_get_supported_rates - get the available rates
  *
  * if management frame or broadcast frame only return
@@ -2612,7 +2612,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	lq_sta->last_txrate_idx = index;
 }
 
-/**
+/*
  * rs_initialize_lq - Initialize a station's hardware rate table
  *
  * The uCode's station table contains a table of fallback rates
-- 
2.25.1

