Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFBEA2C55C2
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 14:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390079AbgKZNdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 08:33:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390142AbgKZNcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 08:32:00 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24119C061A48
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 05:32:00 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id a3so2411781wmb.5
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 05:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AFvxbCSBD0dyE27qjUGJ2Xb0Ms2F6Ys3MDSISyE2R+M=;
        b=yggVGWPXHz3pJffklN/FeUMx+wBFcZjRvumVi8rpt68GuZDlqdSSGnhb5nyosks8Uv
         SzzGM/lUE5wPIhTQ8Rdy35FvaI0a8ZaR8KGW53v37OqdDHtFqXUgremy/v2WuKC368oQ
         t6pNnUyA8xklNSuZBUTWze0FsnYZ7e2CJ4lX/56T99+N1cuoXv/Nqk3Jalsk0o79qIM5
         0QA65OqJzQ/b2pUNFXqIL62zwxHogADMu5Ei2Qtdc0o34mgD9+Xy7JnAerZR+BPfvMpI
         eow75CfVvfaArnG88cNaxdHuX/uw+6zauc3S7Q8EDYLXww8/AinOjfGSbX1qleNjTzET
         qyGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AFvxbCSBD0dyE27qjUGJ2Xb0Ms2F6Ys3MDSISyE2R+M=;
        b=ARDVIOZlTcqrQUUvdOIKuxB2ShJpN3cNuXMhBCnqN6ETi70k8LFvxKII8SvHL8k7C9
         TJYtkECkhOUIal6NG+33pOc7uWllqrsfPK9Ecd+iAqT1znluBakwuxBrpkHO2iUaxsZI
         cEXx1Onh7D36SS+H/p98KhcbXGeYZ+WoSmdaYJ2oulNPiMgtFqSQFg0LygIGjWuz0Me5
         /Kfjf55FE9/FhHooeBNeIL1CwtvlwbmCzgVlxxtmltb2poKsOg8O0isYyRdb7WSAIl/i
         6AYmPdI7TXHOSW5gCZtxILMMETqzOpKt9DZ7o871W6+7jEw7Iyphsqlayc3957als9QL
         qKew==
X-Gm-Message-State: AOAM531ViZSauEvjgi2/JEaWAbQF1RkJxWfV/PrqUzEfTx9gwinuwRhw
        2ADcAO8/JsucrAaYBkdY9Rdujw==
X-Google-Smtp-Source: ABdhPJwT9ejnX73uvccj3LnjaNrr2kQXFa194LRYtXV1GrJlHXUmg2jbQeHhHnvbgFRHjV+Ou22TbA==
X-Received: by 2002:a05:600c:2601:: with SMTP id h1mr3467502wma.35.1606397518856;
        Thu, 26 Nov 2020 05:31:58 -0800 (PST)
Received: from dell.default ([91.110.221.235])
        by smtp.gmail.com with ESMTPSA id n10sm8701001wrv.77.2020.11.26.05.31.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 05:31:58 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org, kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 02/17] iwlwifi: mvm: rs: Demote non-conformant function documentation headers
Date:   Thu, 26 Nov 2020 13:31:37 +0000
Message-Id: <20201126133152.3211309-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201126133152.3211309-1-lee.jones@linaro.org>
References: <20201126133152.3211309-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also add documentation for 'mvm'.

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/intel/iwlwifi/mvm/rs.c:400: warning: cannot understand function prototype: 'const u16 expected_tpt_legacy[IWL_RATE_COUNT] = '
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c:684: warning: Function parameter or member 'mvm' not described in '_rs_collect_tx_data'
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c:684: warning: Function parameter or member 'tbl' not described in '_rs_collect_tx_data'
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c:684: warning: Function parameter or member 'scale_index' not described in '_rs_collect_tx_data'
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c:684: warning: Function parameter or member 'attempts' not described in '_rs_collect_tx_data'
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c:684: warning: Function parameter or member 'successes' not described in '_rs_collect_tx_data'
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c:684: warning: Function parameter or member 'window' not described in '_rs_collect_tx_data'
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c:2677: warning: duplicate section name 'NOTE'
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c:2682: warning: Function parameter or member 'mvm' not described in 'rs_initialize_lq'
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c:2682: warning: Function parameter or member 'sta' not described in 'rs_initialize_lq'
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c:2682: warning: Function parameter or member 'lq_sta' not described in 'rs_initialize_lq'
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c:2682: warning: Function parameter or member 'band' not described in 'rs_initialize_lq'
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c:3761: warning: Function parameter or member 'mvm' not described in 'rs_program_fix_rate'
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c:3761: warning: Function parameter or member 'lq_sta' not described in 'rs_program_fix_rate'
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c:4213: warning: Function parameter or member 'mvm' not described in 'iwl_mvm_tx_protection'

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
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index ed7382e7ea177..91b6541d579f5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -386,7 +386,7 @@ static void rs_fill_lq_cmd(struct iwl_mvm *mvm,
 			   const struct rs_rate *initial_rate);
 static void rs_stay_in_table(struct iwl_lq_sta *lq_sta, bool force_search);
 
-/**
+/*
  * The following tables contain the expected throughput metrics for all rates
  *
  *	1, 2, 5.5, 11, 6, 9, 12, 18, 24, 36, 48, 54, 60 MBits
@@ -396,7 +396,6 @@ static void rs_stay_in_table(struct iwl_lq_sta *lq_sta, bool force_search);
  * CCK rates are only valid in legacy table and will only be used in G
  * (2.4 GHz) band.
  */
-
 static const u16 expected_tpt_legacy[IWL_RATE_COUNT] = {
 	7, 13, 35, 58, 40, 57, 72, 98, 121, 154, 177, 186, 0, 0, 0
 };
@@ -670,7 +669,7 @@ static s32 get_expected_tpt(struct iwl_scale_tbl_info *tbl, int rs_index)
 	return 0;
 }
 
-/**
+/*
  * rs_collect_tx_data - Update the success/failure sliding window
  *
  * We keep a sliding window of the last 62 packets transmitted
@@ -2667,7 +2666,7 @@ void rs_update_last_rssi(struct iwl_mvm *mvm,
 	}
 }
 
-/**
+/*
  * rs_initialize_lq - Initialize a station's hardware rate table
  *
  * The uCode's station table contains a table of fallback rates
@@ -3756,7 +3755,7 @@ int rs_pretty_print_rate(char *buf, int bufsz, const u32 rate)
 }
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-/**
+/*
  * Program the device to use fixed rate for frame transmit
  * This is for debugging/testing only
  * once the device start use fixed rate, we need to reload the module
@@ -4211,6 +4210,7 @@ static int rs_drv_tx_protection(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta,
 
 /**
  * iwl_mvm_tx_protection - ask FW to enable RTS/CTS protection
+ * @mvm: The mvm component
  * @mvmsta: The station
  * @enable: Enable Tx protection?
  */
-- 
2.25.1

