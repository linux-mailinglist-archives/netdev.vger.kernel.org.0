Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71D4249732
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 09:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgHSH1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 03:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728082AbgHSH0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 03:26:17 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B260BC0612F0
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:36 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id g75so1116952wme.4
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cz1UC4tnS3N8DfKT/RtvxsKvZMZZyg6WgaNOLEC941U=;
        b=xP92MXSLUJF3MJNxFN2jeR6pwzN57N/17nqzMGHc349bnPEp6WCiOuot+K7OgLfpJt
         f0iYoa4HWJlB8sCgu0wHg+/N2DTzUhcBln+Rneg4GeQiflniB8HAy6sxoV0ZNCMJzZvq
         G3z/S4LMbYHqIfaYEiLpccEGjThSuOHB8PkUjnPqN25gmPp9mNGcrW8CK/iwHlUl2TWV
         4y0FXqmcVCp22aJZDOBa7fK+OjzFdIEmVnv2xLCQ9JMB6zGygnUjqPecdtoHPsNoX6D2
         h40jX+Nq2G4g95pz6XLeCpAlECwkZkbtHuyMcS+H8TIY8Nn90RTKYb23YIa+6/o7nmOx
         1hzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cz1UC4tnS3N8DfKT/RtvxsKvZMZZyg6WgaNOLEC941U=;
        b=sraunuwYO1G7P/uZ+Cex1W+KkVG7cxfmt1oEyHfMi/z9cyvlfVpSuqVgRcSOqHS97d
         KfOO1fTUxebZGJujfOHdrRJXvteuJSeO2TNUApJTInMhWFteV14+zSgwwMyigtg/4f3K
         3O+2Yi60Tc75IP27cdqRsmljEwa+co3xdZg2EyJzOvTUL8bAf2gNgrv7VCkAC2Iz0i2c
         cuu36shnItgtGZkPDujVdGsYUGfhz3XtItcFc5/IbvOnqZW6PTgP/p6aTjffuUc9OJol
         4VzqyZlLo3k8JCuiZE64SprIecgBuY8FA4R/e3yi3KyTCm61RT5KW3A4eS2PrN7i+EsZ
         621g==
X-Gm-Message-State: AOAM5335agR3HaxpQj/hmrFB6FwUPA2jOOQKnNqSd0uPdNmaFN5v4pSP
        4U2VWSDqoEQRe3m7i4mGXQF30A==
X-Google-Smtp-Source: ABdhPJwtVnZKagyZXI9pcJiwCbCXkQ4Bf54YFPC6HZzcK+Hqr8GYuPzY3WQ0Lkp1eyxkiIw0iE6kGA==
X-Received: by 2002:a05:600c:2184:: with SMTP id e4mr3459650wme.24.1597821875302;
        Wed, 19 Aug 2020 00:24:35 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id c145sm3795808wmd.7.2020.08.19.00.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 00:24:34 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Linux Wireless <ilw@linux.intel.com>
Subject: [PATCH 24/28] wireless: intel: iwlegacy: 4965: Demote a bunch of nonconformant kernel-doc headers
Date:   Wed, 19 Aug 2020 08:23:58 +0100
Message-Id: <20200819072402.3085022-25-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200819072402.3085022-1-lee.jones@linaro.org>
References: <20200819072402.3085022-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/intel/iwlegacy/4965.c:35: warning: Function parameter or member 'il' not described in 'il4965_verify_inst_sparse'
 drivers/net/wireless/intel/iwlegacy/4965.c:35: warning: Function parameter or member 'image' not described in 'il4965_verify_inst_sparse'
 drivers/net/wireless/intel/iwlegacy/4965.c:35: warning: Function parameter or member 'len' not described in 'il4965_verify_inst_sparse'
 drivers/net/wireless/intel/iwlegacy/4965.c:66: warning: Function parameter or member 'il' not described in 'il4965_verify_inst_full'
 drivers/net/wireless/intel/iwlegacy/4965.c:66: warning: Function parameter or member 'image' not described in 'il4965_verify_inst_full'
 drivers/net/wireless/intel/iwlegacy/4965.c:66: warning: Function parameter or member 'len' not described in 'il4965_verify_inst_full'
 drivers/net/wireless/intel/iwlegacy/4965.c:105: warning: Function parameter or member 'il' not described in 'il4965_verify_ucode'
 drivers/net/wireless/intel/iwlegacy/4965.c:329: warning: Function parameter or member 'il' not described in 'il4965_load_bsm'
 drivers/net/wireless/intel/iwlegacy/4965.c:416: warning: Function parameter or member 'il' not described in 'il4965_set_ucode_ptrs'
 drivers/net/wireless/intel/iwlegacy/4965.c:451: warning: Function parameter or member 'il' not described in 'il4965_init_alive_start'
 drivers/net/wireless/intel/iwlegacy/4965.c:583: warning: Function parameter or member 'eeprom_voltage' not described in 'il4965_get_voltage_compensation'
 drivers/net/wireless/intel/iwlegacy/4965.c:583: warning: Function parameter or member 'current_voltage' not described in 'il4965_get_voltage_compensation'
 drivers/net/wireless/intel/iwlegacy/4965.c:668: warning: Function parameter or member 'il' not described in 'il4965_interpolate_chan'
 drivers/net/wireless/intel/iwlegacy/4965.c:668: warning: Function parameter or member 'channel' not described in 'il4965_interpolate_chan'
 drivers/net/wireless/intel/iwlegacy/4965.c:668: warning: Function parameter or member 'chan_info' not described in 'il4965_interpolate_chan'
 drivers/net/wireless/intel/iwlegacy/4965.c:1242: warning: Function parameter or member 'il' not described in 'il4965_send_tx_power'
 drivers/net/wireless/intel/iwlegacy/4965.c:1537: warning: Function parameter or member 'il' not described in 'il4965_txq_update_byte_cnt_tbl'
 drivers/net/wireless/intel/iwlegacy/4965.c:1537: warning: Function parameter or member 'txq' not described in 'il4965_txq_update_byte_cnt_tbl'
 drivers/net/wireless/intel/iwlegacy/4965.c:1537: warning: Function parameter or member 'byte_cnt' not described in 'il4965_txq_update_byte_cnt_tbl'
 drivers/net/wireless/intel/iwlegacy/4965.c:1564: warning: Function parameter or member 'il' not described in 'il4965_hw_get_temperature'
 drivers/net/wireless/intel/iwlegacy/4965.c:1564: warning: Excess function parameter 'stats' description in 'il4965_hw_get_temperature'
 drivers/net/wireless/intel/iwlegacy/4965.c:1633: warning: Function parameter or member 'il' not described in 'il4965_is_temp_calib_needed'

Cc: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/intel/iwlegacy/4965.c | 25 +++++++++++-----------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/4965.c b/drivers/net/wireless/intel/iwlegacy/4965.c
index fc8fa5818de7e..9fa556486511c 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965.c
@@ -25,7 +25,7 @@
 #include "common.h"
 #include "4965.h"
 
-/**
+/*
  * il_verify_inst_sparse - verify runtime uCode image in card vs. host,
  *   using sample data 100 bytes apart.  If these sample points are good,
  *   it's a pretty good bet that everything between them is good, too.
@@ -57,7 +57,7 @@ il4965_verify_inst_sparse(struct il_priv *il, __le32 * image, u32 len)
 	return ret;
 }
 
-/**
+/*
  * il4965_verify_inst_full - verify runtime uCode image in card vs. host,
  *     looking at all data.
  */
@@ -96,7 +96,7 @@ il4965_verify_inst_full(struct il_priv *il, __le32 * image, u32 len)
 	return ret;
 }
 
-/**
+/*
  * il4965_verify_ucode - determine which instruction image is in SRAM,
  *    and verify its contents
  */
@@ -292,7 +292,7 @@ il4965_verify_bsm(struct il_priv *il)
 	return 0;
 }
 
-/**
+/*
  * il4965_load_bsm - Load bootstrap instructions
  *
  * BSM operation:
@@ -402,7 +402,7 @@ il4965_load_bsm(struct il_priv *il)
 	return 0;
 }
 
-/**
+/*
  * il4965_set_ucode_ptrs - Set uCode address location
  *
  * Tell initialization uCode where to find runtime uCode.
@@ -435,7 +435,7 @@ il4965_set_ucode_ptrs(struct il_priv *il)
 	return 0;
 }
 
-/**
+/*
  * il4965_init_alive_start - Called after N_ALIVE notification received
  *
  * Called after N_ALIVE notification received from "initialize" uCode.
@@ -567,7 +567,7 @@ il4965_math_div_round(s32 num, s32 denom, s32 * res)
 	return 1;
 }
 
-/**
+/*
  * il4965_get_voltage_compensation - Power supply voltage comp for txpower
  *
  * Determines power supply voltage compensation for txpower calculations.
@@ -654,7 +654,7 @@ il4965_interpolate_value(s32 x, s32 x1, s32 y1, s32 x2, s32 y2)
 	}
 }
 
-/**
+/*
  * il4965_interpolate_chan - Interpolate factory measurements for one channel
  *
  * Interpolates factory measurements from the two sample channels within a
@@ -1231,7 +1231,7 @@ il4965_fill_txpower_tbl(struct il_priv *il, u8 band, u16 channel, u8 is_ht40,
 	return 0;
 }
 
-/**
+/*
  * il4965_send_tx_power - Configure the TXPOWER level user limit
  *
  * Uses the active RXON for channel, band, and characteristics (ht40, high)
@@ -1528,7 +1528,7 @@ il4965_hw_channel_switch(struct il_priv *il,
 	return il_send_cmd_pdu(il, C_CHANNEL_SWITCH, sizeof(cmd), &cmd);
 }
 
-/**
+/*
  * il4965_txq_update_byte_cnt_tbl - Set up entry in Tx byte-count array
  */
 static void
@@ -1553,9 +1553,8 @@ il4965_txq_update_byte_cnt_tbl(struct il_priv *il, struct il_tx_queue *txq,
 		    bc_ent;
 }
 
-/**
+/*
  * il4965_hw_get_temperature - return the calibrated temperature (in Kelvin)
- * @stats: Provides the temperature reading from the uCode
  *
  * A return of <0 indicates bogus data in the stats
  */
@@ -1619,7 +1618,7 @@ il4965_hw_get_temperature(struct il_priv *il)
 /* Adjust Txpower only if temperature variance is greater than threshold. */
 #define IL_TEMPERATURE_THRESHOLD   3
 
-/**
+/*
  * il4965_is_temp_calib_needed - determines if new calibration is needed
  *
  * If the temperature changed has changed sufficiently, then a recalibration
-- 
2.25.1

