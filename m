Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89E1244916
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 13:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbgHNLmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 07:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728172AbgHNLkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 07:40:16 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F471C061345
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:40:06 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id p14so7224313wmg.1
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ioTbdyF7ZnnTsyhXWAjqAkPMWfFUxsVFhTEP8b9U5Ow=;
        b=Tm5KUqJWljzUdr7xsy2PC2tok0tpmeHO5HLNhe8YW2Bi3vhAQwmCEhbcNN1S88WhbB
         V0xDyMslwlrzY/KCVS/y1OTL3NDd6biLzevveTKBfzlfk+M1AYhsytbNFIF9xvKjJdG2
         LMan+PkOkWBs6rbEnzEgJxYS+27zli/5NQQPqSh8PT5fUjIhEtVzxpoEAuOGK0ZRHWBC
         eYsibuP4Hm4RsF6eTLKnE0X0LYF/U4BWGnQMjcV+taSak4Kz4g50WddxXGOxKSH8pHrA
         0G3tFyjVvdzpzsRMdejU6MyMx4Btt70a5LezLC/75X/eiIP/eHOxJKgWYdEo0ugQih5P
         Q8Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ioTbdyF7ZnnTsyhXWAjqAkPMWfFUxsVFhTEP8b9U5Ow=;
        b=tCJjQdPT8uA/vjWVtvEdaXOWFncsxemh2SXuMkNc07hYwgaAMbQ+uM+L65/UpjNX+q
         KcBgbQxLI8tARNE5qtRY0c+V3mMD22mr+N59/NywMQsG1o17Krd8Srqkbt+L/qENhseZ
         FWYcoasVnkv3z56Mz4Nz0z0LkvMQNVWMJXVFy70fcENEMgSzFEornYpuiJx0lXIhW60x
         evKKPKk03nJ4uC4a4KaiRd9p6OU+4oIdfZJc5GrKZe5hVR35924m9ZjERXXdrEf39obF
         PROwlPgBW/VOz8xTHC4AR9zsuuBjodH1+O+INlzC81J63ul23xKWLyOeESKJ1NqGaml1
         ZmAg==
X-Gm-Message-State: AOAM531lyOzOLvfXww2G9k0DvZ0+wry4by1gWIxsNMfZ8+62v/CesPCM
        yT4J0w+Rz7iilI0Y6JkZ1YdQ3w==
X-Google-Smtp-Source: ABdhPJxxHTkFiz1PqlLl6Z9qVCo69yqHucBCLysaWcGypLjtM158p4xlRs+D2A6JmEEMUbh4Dr6GTA==
X-Received: by 2002:a7b:c1c2:: with SMTP id a2mr2185291wmj.74.1597405204972;
        Fri, 14 Aug 2020 04:40:04 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id 32sm16409129wrh.18.2020.08.14.04.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 04:40:04 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Kalle Valo <kvalo@codeaurora.org>,
        Linux Wireless <ilw@linux.intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 15/30] net: wireless: intel: iwlegacy: common: Demote kerneldoc headers to standard comment blocks
Date:   Fri, 14 Aug 2020 12:39:18 +0100
Message-Id: <20200814113933.1903438-16-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200814113933.1903438-1-lee.jones@linaro.org>
References: <20200814113933.1903438-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Almost all of the headers in this file fail to reach the standards
required by kernel-doc and no "kernel-doc::" references are made to it
from the kernel's Documentation.

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/intel/iwlegacy/common.c: In function ‘il_enqueue_hcmd’:
 drivers/net/wireless/intel/iwlegacy/common.c:3126:6: warning: variable ‘len’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/intel/iwlegacy/common.c:697: warning: Function parameter or member 'il' not described in 'il_eeprom_init'
 drivers/net/wireless/intel/iwlegacy/common.c:848: warning: Function parameter or member 'il' not described in 'il_mod_ht40_chan_info'
 drivers/net/wireless/intel/iwlegacy/common.c:848: warning: Function parameter or member 'band' not described in 'il_mod_ht40_chan_info'
 drivers/net/wireless/intel/iwlegacy/common.c:848: warning: Function parameter or member 'channel' not described in 'il_mod_ht40_chan_info'
 drivers/net/wireless/intel/iwlegacy/common.c:848: warning: Function parameter or member 'eeprom_ch' not described in 'il_mod_ht40_chan_info'
 drivers/net/wireless/intel/iwlegacy/common.c:848: warning: Function parameter or member 'clear_ht40_extension_channel' not described in 'il_mod_ht40_chan_info'
 drivers/net/wireless/intel/iwlegacy/common.c:885: warning: Function parameter or member 'il' not described in 'il_init_channel_map'
 drivers/net/wireless/intel/iwlegacy/common.c:1035: warning: Function parameter or member 'il' not described in 'il_get_channel_info'
 drivers/net/wireless/intel/iwlegacy/common.c:1035: warning: Function parameter or member 'band' not described in 'il_get_channel_info'
 drivers/net/wireless/intel/iwlegacy/common.c:1035: warning: Function parameter or member 'channel' not described in 'il_get_channel_info'
 drivers/net/wireless/intel/iwlegacy/common.c:1351: warning: Function parameter or member 'il' not described in 'il_scan_cancel'
 drivers/net/wireless/intel/iwlegacy/common.c:1365: warning: Function parameter or member 'il' not described in 'il_scan_cancel_timeout'
 drivers/net/wireless/intel/iwlegacy/common.c:1617: warning: Function parameter or member 'il' not described in 'il_fill_probe_req'
 drivers/net/wireless/intel/iwlegacy/common.c:1617: warning: Function parameter or member 'frame' not described in 'il_fill_probe_req'
 drivers/net/wireless/intel/iwlegacy/common.c:1617: warning: Function parameter or member 'ta' not described in 'il_fill_probe_req'
 drivers/net/wireless/intel/iwlegacy/common.c:1617: warning: Function parameter or member 'ies' not described in 'il_fill_probe_req'
 drivers/net/wireless/intel/iwlegacy/common.c:1617: warning: Function parameter or member 'ie_len' not described in 'il_fill_probe_req'
 drivers/net/wireless/intel/iwlegacy/common.c:1617: warning: Function parameter or member 'left' not described in 'il_fill_probe_req'
 drivers/net/wireless/intel/iwlegacy/common.c:1924: warning: Function parameter or member 'il' not described in 'il_prep_station'
 drivers/net/wireless/intel/iwlegacy/common.c:1924: warning: Function parameter or member 'addr' not described in 'il_prep_station'
 drivers/net/wireless/intel/iwlegacy/common.c:1924: warning: Function parameter or member 'is_ap' not described in 'il_prep_station'
 drivers/net/wireless/intel/iwlegacy/common.c:1924: warning: Function parameter or member 'sta' not described in 'il_prep_station'
 drivers/net/wireless/intel/iwlegacy/common.c:2009: warning: Function parameter or member 'il' not described in 'il_add_station_common'
 drivers/net/wireless/intel/iwlegacy/common.c:2009: warning: Function parameter or member 'addr' not described in 'il_add_station_common'
 drivers/net/wireless/intel/iwlegacy/common.c:2009: warning: Function parameter or member 'is_ap' not described in 'il_add_station_common'
 drivers/net/wireless/intel/iwlegacy/common.c:2009: warning: Function parameter or member 'sta' not described in 'il_add_station_common'
 drivers/net/wireless/intel/iwlegacy/common.c:2009: warning: Function parameter or member 'sta_id_r' not described in 'il_add_station_common'
 drivers/net/wireless/intel/iwlegacy/common.c:2070: warning: Function parameter or member 'il' not described in 'il_sta_ucode_deactivate'
 drivers/net/wireless/intel/iwlegacy/common.c:2070: warning: Function parameter or member 'sta_id' not described in 'il_sta_ucode_deactivate'
 drivers/net/wireless/intel/iwlegacy/common.c:2144: warning: Function parameter or member 'il' not described in 'il_remove_station'
 drivers/net/wireless/intel/iwlegacy/common.c:2144: warning: Function parameter or member 'sta_id' not described in 'il_remove_station'
 drivers/net/wireless/intel/iwlegacy/common.c:2144: warning: Function parameter or member 'addr' not described in 'il_remove_station'
 drivers/net/wireless/intel/iwlegacy/common.c:2205: warning: Function parameter or member 'il' not described in 'il_clear_ucode_stations'
 drivers/net/wireless/intel/iwlegacy/common.c:2237: warning: Function parameter or member 'il' not described in 'il_restore_stations'
 drivers/net/wireless/intel/iwlegacy/common.c:2372: warning: Function parameter or member 'il' not described in 'il_is_lq_table_valid'
 drivers/net/wireless/intel/iwlegacy/common.c:2372: warning: Function parameter or member 'lq' not described in 'il_is_lq_table_valid'
 drivers/net/wireless/intel/iwlegacy/common.c:2401: warning: Function parameter or member 'il' not described in 'il_send_lq_cmd'
 drivers/net/wireless/intel/iwlegacy/common.c:2401: warning: Function parameter or member 'lq' not described in 'il_send_lq_cmd'
 drivers/net/wireless/intel/iwlegacy/common.c:2401: warning: Function parameter or member 'flags' not described in 'il_send_lq_cmd'
 drivers/net/wireless/intel/iwlegacy/common.c:2539: warning: Function parameter or member 'q' not described in 'il_rx_queue_space'
 drivers/net/wireless/intel/iwlegacy/common.c:2556: warning: Function parameter or member 'il' not described in 'il_rx_queue_update_write_ptr'
 drivers/net/wireless/intel/iwlegacy/common.c:2556: warning: Function parameter or member 'q' not described in 'il_rx_queue_update_write_ptr'
 drivers/net/wireless/intel/iwlegacy/common.c:2711: warning: Function parameter or member 'il' not described in 'il_txq_update_write_ptr'
 drivers/net/wireless/intel/iwlegacy/common.c:2711: warning: Function parameter or member 'txq' not described in 'il_txq_update_write_ptr'
 drivers/net/wireless/intel/iwlegacy/common.c:2751: warning: Function parameter or member 'il' not described in 'il_tx_queue_unmap'
 drivers/net/wireless/intel/iwlegacy/common.c:2751: warning: Function parameter or member 'txq_id' not described in 'il_tx_queue_unmap'
 drivers/net/wireless/intel/iwlegacy/common.c:2775: warning: Function parameter or member 'il' not described in 'il_tx_queue_free'
 drivers/net/wireless/intel/iwlegacy/common.c:2775: warning: Function parameter or member 'txq_id' not described in 'il_tx_queue_free'
 drivers/net/wireless/intel/iwlegacy/common.c:2775: warning: Excess function parameter 'txq' description in 'il_tx_queue_free'
 drivers/net/wireless/intel/iwlegacy/common.c:2813: warning: Function parameter or member 'il' not described in 'il_cmd_queue_unmap'
 drivers/net/wireless/intel/iwlegacy/common.c:2856: warning: Function parameter or member 'il' not described in 'il_cmd_queue_free'
 drivers/net/wireless/intel/iwlegacy/common.c:2856: warning: Excess function parameter 'txq' description in 'il_cmd_queue_free'
 drivers/net/wireless/intel/iwlegacy/common.c:2932: warning: Function parameter or member 'il' not described in 'il_queue_init'
 drivers/net/wireless/intel/iwlegacy/common.c:2932: warning: Function parameter or member 'q' not described in 'il_queue_init'
 drivers/net/wireless/intel/iwlegacy/common.c:2932: warning: Function parameter or member 'slots' not described in 'il_queue_init'
 drivers/net/wireless/intel/iwlegacy/common.c:2932: warning: Function parameter or member 'id' not described in 'il_queue_init'
 drivers/net/wireless/intel/iwlegacy/common.c:2966: warning: Function parameter or member 'il' not described in 'il_tx_queue_alloc'
 drivers/net/wireless/intel/iwlegacy/common.c:2966: warning: Function parameter or member 'txq' not described in 'il_tx_queue_alloc'
 drivers/net/wireless/intel/iwlegacy/common.c:2966: warning: Function parameter or member 'id' not described in 'il_tx_queue_alloc'
 drivers/net/wireless/intel/iwlegacy/common.c:3006: warning: Function parameter or member 'il' not described in 'il_tx_queue_init'
 drivers/net/wireless/intel/iwlegacy/common.c:3006: warning: Function parameter or member 'txq_id' not described in 'il_tx_queue_init'
 drivers/net/wireless/intel/iwlegacy/common.c:3245: warning: Function parameter or member 'il' not described in 'il_hcmd_queue_reclaim'
 drivers/net/wireless/intel/iwlegacy/common.c:3245: warning: Function parameter or member 'txq_id' not described in 'il_hcmd_queue_reclaim'
 drivers/net/wireless/intel/iwlegacy/common.c:3245: warning: Function parameter or member 'idx' not described in 'il_hcmd_queue_reclaim'
 drivers/net/wireless/intel/iwlegacy/common.c:3245: warning: Function parameter or member 'cmd_idx' not described in 'il_hcmd_queue_reclaim'
 drivers/net/wireless/intel/iwlegacy/common.c:3279: warning: Function parameter or member 'il' not described in 'il_tx_cmd_complete'
 drivers/net/wireless/intel/iwlegacy/common.c:3425: warning: Function parameter or member 'il' not described in 'il_init_geos'
 drivers/net/wireless/intel/iwlegacy/common.c:3949: warning: bad line:
 drivers/net/wireless/intel/iwlegacy/common.c:3955: warning: Function parameter or member 'il' not described in 'il_set_rxon_channel'
 drivers/net/wireless/intel/iwlegacy/common.c:4154: warning: Function parameter or member 'il' not described in 'il_irq_handle_error'
 drivers/net/wireless/intel/iwlegacy/common.c:5019: warning: Function parameter or member 'hw' not described in 'il_mac_config'
 drivers/net/wireless/intel/iwlegacy/common.c:5019: warning: Function parameter or member 'changed' not described in 'il_mac_config'

Cc: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/intel/iwlegacy/common.c | 68 ++++++++++----------
 1 file changed, 33 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index ff00c50db7c46..67296e0cd82f3 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -685,7 +685,7 @@ il_eeprom_query16(const struct il_priv *il, size_t offset)
 }
 EXPORT_SYMBOL(il_eeprom_query16);
 
-/**
+/*
  * il_eeprom_init - read EEPROM contents
  *
  * Load the EEPROM contents from adapter into il->eeprom
@@ -836,7 +836,7 @@ il_init_band_reference(const struct il_priv *il, int eep_band,
 
 #define CHECK_AND_PRINT(x) ((eeprom_ch->flags & EEPROM_CHANNEL_##x) \
 			    ? # x " " : "")
-/**
+/*
  * il_mod_ht40_chan_info - Copy ht40 channel info into driver's il.
  *
  * Does not set up a command, or touch hardware.
@@ -877,7 +877,7 @@ il_mod_ht40_chan_info(struct il_priv *il, enum nl80211_band band, u16 channel,
 #define CHECK_AND_PRINT_I(x) ((eeprom_ch_info[ch].flags & EEPROM_CHANNEL_##x) \
 			    ? # x " " : "")
 
-/**
+/*
  * il_init_channel_map - Set up driver's info for all possible channels
  */
 int
@@ -1024,7 +1024,7 @@ il_free_channel_map(struct il_priv *il)
 }
 EXPORT_SYMBOL(il_free_channel_map);
 
-/**
+/*
  * il_get_channel_info - Find driver's ilate channel info
  *
  * Based on band and channel number.
@@ -1343,7 +1343,7 @@ il_do_scan_abort(struct il_priv *il)
 		D_SCAN("Successfully send scan abort\n");
 }
 
-/**
+/*
  * il_scan_cancel - Cancel any currently executing HW scan
  */
 int
@@ -1355,7 +1355,7 @@ il_scan_cancel(struct il_priv *il)
 }
 EXPORT_SYMBOL(il_scan_cancel);
 
-/**
+/*
  * il_scan_cancel_timeout - Cancel any currently executing HW scan
  * @ms: amount of time to wait (in milliseconds) for scan to abort
  *
@@ -1607,10 +1607,9 @@ il_bg_scan_check(struct work_struct *data)
 	mutex_unlock(&il->mutex);
 }
 
-/**
+/*
  * il_fill_probe_req - fill in all required fields and IE for probe request
  */
-
 u16
 il_fill_probe_req(struct il_priv *il, struct ieee80211_mgmt *frame,
 		  const u8 *ta, const u8 *ies, int ie_len, int left)
@@ -1913,7 +1912,7 @@ il_set_ht_add_station(struct il_priv *il, u8 idx, struct ieee80211_sta *sta)
 	return;
 }
 
-/**
+/*
  * il_prep_station - Prepare station information for addition
  *
  * should be called with sta_lock held
@@ -2000,7 +1999,7 @@ EXPORT_SYMBOL_GPL(il_prep_station);
 
 #define STA_WAIT_TIMEOUT (HZ/2)
 
-/**
+/*
  * il_add_station_common -
  */
 int
@@ -2060,7 +2059,7 @@ il_add_station_common(struct il_priv *il, const u8 *addr, bool is_ap,
 }
 EXPORT_SYMBOL(il_add_station_common);
 
-/**
+/*
  * il_sta_ucode_deactivate - deactivate ucode status for a station
  *
  * il->sta_lock must be held
@@ -2136,7 +2135,7 @@ il_send_remove_station(struct il_priv *il, const u8 * addr, int sta_id,
 	return ret;
 }
 
-/**
+/*
  * il_remove_station - Remove driver's knowledge of station.
  */
 int
@@ -2192,7 +2191,7 @@ il_remove_station(struct il_priv *il, const u8 sta_id, const u8 * addr)
 }
 EXPORT_SYMBOL_GPL(il_remove_station);
 
-/**
+/*
  * il_clear_ucode_stations - clear ucode station table bits
  *
  * This function clears all the bits in the driver indicating
@@ -2224,7 +2223,7 @@ il_clear_ucode_stations(struct il_priv *il)
 }
 EXPORT_SYMBOL(il_clear_ucode_stations);
 
-/**
+/*
  * il_restore_stations() - Restore driver known stations to device
  *
  * All stations considered active by driver, but not present in ucode, is
@@ -2356,7 +2355,7 @@ il_dump_lq_cmd(struct il_priv *il, struct il_link_quality_cmd *lq)
 }
 #endif
 
-/**
+/*
  * il_is_lq_table_valid() - Test one aspect of LQ cmd for validity
  *
  * It sometimes happens when a HT rate has been in use and we
@@ -2385,7 +2384,7 @@ il_is_lq_table_valid(struct il_priv *il, struct il_link_quality_cmd *lq)
 	return true;
 }
 
-/**
+/*
  * il_send_lq_cmd() - Send link quality command
  * @init: This command is sent as part of station initialization right
  *        after station has been added.
@@ -2531,7 +2530,7 @@ EXPORT_SYMBOL(il_mac_sta_remove);
  *
  */
 
-/**
+/*
  * il_rx_queue_space - Return number of free slots available in queue.
  */
 int
@@ -2548,7 +2547,7 @@ il_rx_queue_space(const struct il_rx_queue *q)
 }
 EXPORT_SYMBOL(il_rx_queue_space);
 
-/**
+/*
  * il_rx_queue_update_write_ptr - Update the write pointer for the RX queue
  */
 void
@@ -2703,7 +2702,7 @@ il_set_decrypted_flag(struct il_priv *il, struct ieee80211_hdr *hdr,
 }
 EXPORT_SYMBOL(il_set_decrypted_flag);
 
-/**
+/*
  * il_txq_update_write_ptr - Send new write idx to hardware
  */
 void
@@ -2743,7 +2742,7 @@ il_txq_update_write_ptr(struct il_priv *il, struct il_tx_queue *txq)
 }
 EXPORT_SYMBOL(il_txq_update_write_ptr);
 
-/**
+/*
  * il_tx_queue_unmap -  Unmap any remaining DMA mappings and free skb's
  */
 void
@@ -2762,7 +2761,7 @@ il_tx_queue_unmap(struct il_priv *il, int txq_id)
 }
 EXPORT_SYMBOL(il_tx_queue_unmap);
 
-/**
+/*
  * il_tx_queue_free - Deallocate DMA queue.
  * @txq: Transmit queue to deallocate.
  *
@@ -2805,7 +2804,7 @@ il_tx_queue_free(struct il_priv *il, int txq_id)
 }
 EXPORT_SYMBOL(il_tx_queue_free);
 
-/**
+/*
  * il_cmd_queue_unmap - Unmap any remaining DMA mappings from command queue
  */
 void
@@ -2843,9 +2842,8 @@ il_cmd_queue_unmap(struct il_priv *il)
 }
 EXPORT_SYMBOL(il_cmd_queue_unmap);
 
-/**
+/*
  * il_cmd_queue_free - Deallocate DMA queue.
- * @txq: Transmit queue to deallocate.
  *
  * Empty queue by removing and destroying all BD's.
  * Free all buffers.
@@ -2924,7 +2922,7 @@ il_queue_space(const struct il_queue *q)
 EXPORT_SYMBOL(il_queue_space);
 
 
-/**
+/*
  * il_queue_init - Initialize queue's high/low-water and read/write idxes
  */
 static int
@@ -2958,7 +2956,7 @@ il_queue_init(struct il_priv *il, struct il_queue *q, int slots, u32 id)
 	return 0;
 }
 
-/**
+/*
  * il_tx_queue_alloc - Alloc driver data and TFD CB for one Tx/cmd queue
  */
 static int
@@ -2998,7 +2996,7 @@ il_tx_queue_alloc(struct il_priv *il, struct il_tx_queue *txq, u32 id)
 	return -ENOMEM;
 }
 
-/**
+/*
  * il_tx_queue_init - Allocate and initialize one tx/cmd queue
  */
 int
@@ -3105,7 +3103,7 @@ EXPORT_SYMBOL(il_tx_queue_reset);
 
 /*************** HOST COMMAND QUEUE FUNCTIONS   *****/
 
-/**
+/*
  * il_enqueue_hcmd - enqueue a uCode command
  * @il: device ilate data point
  * @cmd: a point to the ucode command structure
@@ -3229,7 +3227,7 @@ il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd)
 	return idx;
 }
 
-/**
+/*
  * il_hcmd_queue_reclaim - Reclaim TX command queue entries already Tx'd
  *
  * When FW advances 'R' idx, all entries between old and new 'R' idx
@@ -3262,7 +3260,7 @@ il_hcmd_queue_reclaim(struct il_priv *il, int txq_id, int idx, int cmd_idx)
 	}
 }
 
-/**
+/*
  * il_tx_cmd_complete - Pull unused buffers off the queue and reclaim them
  * @rxb: Rx buffer to reclaim
  *
@@ -3413,7 +3411,7 @@ il_init_ht_hw_capab(const struct il_priv *il,
 	}
 }
 
-/**
+/*
  * il_init_geos - Initialize mac80211's geo/channel info based from eeprom
  */
 int
@@ -3759,7 +3757,7 @@ il_check_rxon_cmd(struct il_priv *il)
 }
 EXPORT_SYMBOL(il_check_rxon_cmd);
 
-/**
+/*
  * il_full_rxon_required - check if full RXON (vs RXON_ASSOC) cmd is needed
  * @il: staging_rxon is compared to active_rxon
  *
@@ -3939,7 +3937,7 @@ il_get_single_channel_number(struct il_priv *il, enum nl80211_band band)
 }
 EXPORT_SYMBOL(il_get_single_channel_number);
 
-/**
+/*
  * il_set_rxon_channel - Set the band and channel values in staging RXON
  * @ch: requested channel as a pointer to struct ieee80211_channel
 
@@ -4142,7 +4140,7 @@ il_print_rx_config_cmd(struct il_priv *il)
 }
 EXPORT_SYMBOL(il_print_rx_config_cmd);
 #endif
-/**
+/*
  * il_irq_handle_error - called for HW or SW error interrupt from card
  */
 void
@@ -5007,7 +5005,7 @@ il_update_qos(struct il_priv *il)
 			      &il->qos_data.def_qos_parm, NULL);
 }
 
-/**
+/*
  * il_mac_config - mac80211 config callback
  */
 int
-- 
2.25.1

