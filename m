Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D16B724CED2
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 09:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbgHUHS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 03:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728223AbgHUHSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 03:18:04 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318F0C061378
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:17:18 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id x5so838474wmi.2
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4gn8qz7mdeM+KJv2Goskpg63XeKb8kIfVsEGkRwpuww=;
        b=apPHSRdgB/3MNG9reCq6xCgMRg/mCa41Z1HvbnqH9l0KRmFouQgus1aGJwwdw7B8q4
         lA4IBmkje2fpTJ1SENRtLaEbN0xpteqLL/wJM0p8JUOGlPG6OEkdtRLdMxcFm/lkOw1K
         1QkADdlGZaTWJ6ksQKuJ5Qpc689mVRZ0YeoOtFkF10hogtepQz4qUnyNdtjGB8F4k5wv
         i3YHHHEUCBjPmO9BePTSH+6HhVAdjo9gxFZepAKpMHKED7wwxZnaID1PJ2n4aH1Ri6oN
         iW3+IlyFqizs2X2OJ3TFSlOQSOJyOmUKIVFuj7v8+is/3v7gFcViIYsFkOVsokzJDFrB
         TkjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4gn8qz7mdeM+KJv2Goskpg63XeKb8kIfVsEGkRwpuww=;
        b=ioQ8Kt1GvIwuwREuUP3fH6kXJyHMpzxLueM86eurnKmar0U4jLT6uV7/CRqMy/UELU
         LpiRRd8b0MkSUwV2uCDz0UCnvHVRB3GaRIWu73C2uo+ZsW8YY7TYd47O+yXcEiynoGUo
         yH3+L2GfeLsY5D4oCYQUNgn44X5uFtDnXtdVva7snwIEg90X3DXWL6MSxjTVyCv25nBl
         MyNV8D08Vm0syFKLkgixh+RluIVG534hQoZ597XM/66+6XwVgofNxrk8hhrNHSZwMRrg
         ClQa9vX+HT9E7u6wpOtrJR4Yrm1pqpYVCdFxFoM8mKj/YiXGKs8TXR/hXUno6ScwKFgJ
         JLWA==
X-Gm-Message-State: AOAM531b8D4L4jzjFTl9dHZhaUS7UDRJKcQYgL7Iv8VoqbOmvI5rMTZJ
        YiPtCsS+spx7OJT1ilFfe0O6YQ==
X-Google-Smtp-Source: ABdhPJwM2+amhs/MmGVeBUrg8zh11cdxTFLh10Xc9dNEuqLMQKRRlVzcQFYP3tLR06HDZvt2G8WZ+A==
X-Received: by 2002:a1c:105:: with SMTP id 5mr2444020wmb.83.1597994235935;
        Fri, 21 Aug 2020 00:17:15 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id y24sm2667957wmi.17.2020.08.21.00.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 00:17:15 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Linux Wireless <ilw@linux.intel.com>
Subject: [PATCH 22/32] wireless: intel: iwlegacy: 4965-rs: Demote non kernel-doc headers to standard comment blocks
Date:   Fri, 21 Aug 2020 08:16:34 +0100
Message-Id: <20200821071644.109970-23-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821071644.109970-1-lee.jones@linaro.org>
References: <20200821071644.109970-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/intel/iwlegacy/4965-rs.c:156: warning: cannot understand function prototype: 's32 expected_tpt_legacy[RATE_COUNT] = '
 drivers/net/wireless/intel/iwlegacy/4965-rs.c:406: warning: Function parameter or member 'tbl' not described in 'il4965_rs_collect_tx_data'
 drivers/net/wireless/intel/iwlegacy/4965-rs.c:406: warning: Function parameter or member 'scale_idx' not described in 'il4965_rs_collect_tx_data'
 drivers/net/wireless/intel/iwlegacy/4965-rs.c:406: warning: Function parameter or member 'attempts' not described in 'il4965_rs_collect_tx_data'
 drivers/net/wireless/intel/iwlegacy/4965-rs.c:406: warning: Function parameter or member 'successes' not described in 'il4965_rs_collect_tx_data'
 drivers/net/wireless/intel/iwlegacy/4965-rs.c:629: warning: Function parameter or member 'il' not described in 'il4965_rs_use_green'
 drivers/net/wireless/intel/iwlegacy/4965-rs.c:629: warning: Function parameter or member 'sta' not described in 'il4965_rs_use_green'
 drivers/net/wireless/intel/iwlegacy/4965-rs.c:645: warning: Function parameter or member 'lq_sta' not described in 'il4965_rs_get_supported_rates'
 drivers/net/wireless/intel/iwlegacy/4965-rs.c:645: warning: Function parameter or member 'hdr' not described in 'il4965_rs_get_supported_rates'
 drivers/net/wireless/intel/iwlegacy/4965-rs.c:645: warning: Function parameter or member 'rate_type' not described in 'il4965_rs_get_supported_rates'
 drivers/net/wireless/intel/iwlegacy/4965-rs.c:2130: warning: duplicate section name 'NOTE'
 drivers/net/wireless/intel/iwlegacy/4965-rs.c:2134: warning: Function parameter or member 'il' not described in 'il4965_rs_initialize_lq'
 drivers/net/wireless/intel/iwlegacy/4965-rs.c:2134: warning: Function parameter or member 'conf' not described in 'il4965_rs_initialize_lq'
 drivers/net/wireless/intel/iwlegacy/4965-rs.c:2134: warning: Function parameter or member 'sta' not described in 'il4965_rs_initialize_lq'
 drivers/net/wireless/intel/iwlegacy/4965-rs.c:2134: warning: Function parameter or member 'lq_sta' not described in 'il4965_rs_initialize_lq'

Cc: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/intel/iwlegacy/4965-rs.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/4965-rs.c b/drivers/net/wireless/intel/iwlegacy/4965-rs.c
index 1f196665d21f1..9a491e5db75bd 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-rs.c
@@ -142,7 +142,7 @@ il4965_rs_dbgfs_set_mcs(struct il_lq_sta *lq_sta, u32 * rate_n_flags, int idx)
 }
 #endif
 
-/**
+/*
  * The following tables contain the expected throughput metrics for all rates
  *
  *	1, 2, 5.5, 11, 6, 9, 12, 18, 24, 36, 48, 54, 60 MBits
@@ -393,7 +393,7 @@ il4965_get_expected_tpt(struct il_scale_tbl_info *tbl, int rs_idx)
 	return 0;
 }
 
-/**
+/*
  * il4965_rs_collect_tx_data - Update the success/failure sliding win
  *
  * We keep a sliding win of the last 62 packets transmitted
@@ -620,7 +620,7 @@ il4965_rs_toggle_antenna(u32 valid_ant, u32 *rate_n_flags,
 	return 1;
 }
 
-/**
+/*
  * Green-field mode is valid if the station supports it and
  * there are no non-GF stations present in the BSS.
  */
@@ -631,7 +631,7 @@ il4965_rs_use_green(struct il_priv *il, struct ieee80211_sta *sta)
 	       !il->ht.non_gf_sta_present;
 }
 
-/**
+/*
  * il4965_rs_get_supported_rates - get the available rates
  *
  * if management frame or broadcast frame only return
@@ -2114,7 +2114,7 @@ il4965_rs_rate_scale_perform(struct il_priv *il, struct sk_buff *skb,
 	lq_sta->last_txrate_idx = i;
 }
 
-/**
+/*
  * il4965_rs_initialize_lq - Initialize a station's hardware rate table
  *
  * The uCode's station table contains a table of fallback rates
-- 
2.25.1

