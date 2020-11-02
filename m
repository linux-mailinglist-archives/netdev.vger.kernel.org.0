Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BABC2A2978
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbgKBL2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:28:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728634AbgKBLY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:24:29 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15199C061A04
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:24:29 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id k18so9122089wmj.5
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AFvxbCSBD0dyE27qjUGJ2Xb0Ms2F6Ys3MDSISyE2R+M=;
        b=udOd7bGBOYKR4UprYlENO30OIAdWtb7NI3dl14b2U5dwS3lMoFi3AylTynoEmHqv7z
         rG1pcwZcA2GODT7vbsuT6GQ8pbldsq6Jeod8EM2YQfV5uxNSuAArsgJRMP1vm76MzIcx
         QI+9+mvC7fJZoInVjIf8AGVT0tpYx6YOdDl+EezDJ4VWJ/VUGjP3WIJRNERcZh4C0JzO
         87/q9MWt02/X9b0Sw1/SQtXKR6aWpxDdZPKLH45i9Qnorx7B4H5dqUFd9GBvrhMz5Fgr
         ELKdmNunluybHaK6LEIFgCm72LSkMDgX3+gOehmagAtZaHgml1cIAegkCqkA9dKakvGP
         GeyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AFvxbCSBD0dyE27qjUGJ2Xb0Ms2F6Ys3MDSISyE2R+M=;
        b=VwXiCUIveDXOSimsMWh27SGAt1vWmGpQaLGt+hW2peSf0ft2TLBvkVP98m/3GZzSom
         OS7KJH+0BO+1tHwFKAcgLkWr9SQG/C6E6vtXwq/ixOwbougrfdU2hwNaonC/dxlLzY7D
         PL99vqS+G5OiNIRPpRkzavU9l0eTo+MBDDXnXXUet2UXnLc5fVd33BU4cogYqBFc/fUo
         UbL1k2VPsw8dNXRqW9n84Ov34OHCLQcusdRNzxuYN53PWQECnTx0ZtatyRNIegLcVTjF
         7bM+2Cnrzej0FFx8NnpcP7+MdiYqpkhhpjOFH+mAjJtqqztGP1UFqWqT8LlUhlaTTWBC
         WeAQ==
X-Gm-Message-State: AOAM530IX4bS5S4MCFv7x3g2kyZJdvktbHpP06lb6eHFyQC/bjGur9sw
        MO7Dx9TVHRRmNyI3tbJnPz5ipQ==
X-Google-Smtp-Source: ABdhPJxV5TIbJuJEaGgVUX4DCaO0rJIH/Q2FlVRkiX97D+yCvj5LLTK0kFVE53PSH8kYpjObYrvtsA==
X-Received: by 2002:a7b:c7c3:: with SMTP id z3mr16926849wmk.43.1604316267805;
        Mon, 02 Nov 2020 03:24:27 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id m14sm21867354wro.43.2020.11.02.03.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:24:27 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 08/41] iwlwifi: mvm: rs: Demote non-conformant function documentation headers
Date:   Mon,  2 Nov 2020 11:23:37 +0000
Message-Id: <20201102112410.1049272-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102112410.1049272-1-lee.jones@linaro.org>
References: <20201102112410.1049272-1-lee.jones@linaro.org>
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

