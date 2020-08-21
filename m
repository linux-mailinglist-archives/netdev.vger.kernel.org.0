Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1ED24CF12
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 09:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbgHUHVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 03:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728124AbgHUHRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 03:17:35 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223BCC061360
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:17:08 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id g75so818906wme.4
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nUeR3h5fpkkkgtzuHZU6uLu4l8vXnBzF6MzU8rQsmVo=;
        b=kzs9Iqnhk7K0pKVjWTMQ8amIGDjG6psa1dj9EXg+wK/XP7MioULapiYQsHC/f4nH2A
         o/QGgB/X4tn79qMn+UcC19cRdQ6eT882muCibeVxu1t7bsEMF+KTu6+85XJ4Ls6wElMF
         EXOMnuZz8+va2wzm3ZrG4HrrJsSTC6S1LXApb7vgjEDFFF/k5CJAqTXIe5Kh4fv/qyUp
         M2ydEtXLP7rhNUEDc8DzY+OOiJLeaohdSgG9VILvpsyRpiD5tfpaEo3cKWatxhF080/I
         GTbWHz1TIqx1GBEB4QJ6DtJX8F/ShW5oEMlgRMPybVG3GrR7zJ9bnJXSuoYDzgy79GpK
         tjfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nUeR3h5fpkkkgtzuHZU6uLu4l8vXnBzF6MzU8rQsmVo=;
        b=RpncWYFNYQTiYwlt+XeKo3t+cZT71oTHiyJslh0AMxbZujDMedvnnZi7c/fMNHOvlA
         /pZxPaozvd/WEHbgUCXXwbGKvtDJ2KzYUdKm01hWS+YDqnZIEH2SRAIPBA4bwhyurgBn
         2OgK6+Y+/hWBYlp0GlXTRL/pKVMFyGwKHAYQmYYXsKn52oCZ+NskuIy4j8lto+Z4lIaI
         g+ZNwOjtlBjJaHq78yWzW5gM5Lb7eLMsDiW44Y8cd4hyMzyGYFHqebgFKDLhrUhEr4zn
         wGEcZPDFDYseecHAUgNvQpX/ms7p0LJUOr9EmEtJ1zNXwHk0MU255FCXtIMm6mh1qbPT
         42/Q==
X-Gm-Message-State: AOAM532kXjAHRtPoQSjqrlTacmy5C+axRwqPp7B1pk/2LiI/SwM6XmsK
        s0H8hzYXnWjVjpT7xGGNmYs/FA==
X-Google-Smtp-Source: ABdhPJyuA8hOE8z3NNpDMkOxrsTwtO1T93WHRkDkLAP4dFVb1frwHZzzoQyYto8Ty6j6MA2kfrecEw==
X-Received: by 2002:a1c:f70a:: with SMTP id v10mr1650726wmh.39.1597994227176;
        Fri, 21 Aug 2020 00:17:07 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id y24sm2667957wmi.17.2020.08.21.00.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 00:17:06 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Linux Wireless <ilw@linux.intel.com>
Subject: [PATCH 15/32] wireless: intel: iwlegacy: 4965-mac: Convert function headers to standard comment blocks
Date:   Fri, 21 Aug 2020 08:16:27 +0100
Message-Id: <20200821071644.109970-16-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821071644.109970-1-lee.jones@linaro.org>
References: <20200821071644.109970-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are clearly not suitable for kernel-doc.

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/intel/iwlegacy/4965-mac.c:234: warning: Function parameter or member 'il' not described in 'il4965_dma_addr2rbd_ptr'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:234: warning: Function parameter or member 'dma_addr' not described in 'il4965_dma_addr2rbd_ptr'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:251: warning: Function parameter or member 'il' not described in 'il4965_rx_queue_restock'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:301: warning: Function parameter or member 'il' not described in 'il4965_rx_allocate'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:301: warning: Function parameter or member 'priority' not described in 'il4965_rx_allocate'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:1138: warning: Function parameter or member 'il' not described in 'il4965_set_rxon_chain'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:1943: warning: Function parameter or member 'il' not described in 'il4965_hw_txq_ctx_free'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:1971: warning: Function parameter or member 'il' not described in 'il4965_txq_ctx_alloc'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:2068: warning: Function parameter or member 'il' not described in 'il4965_txq_ctx_stop'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:2109: warning: Function parameter or member 'il' not described in 'il4965_tx_queue_stop_scheduler'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:2109: warning: Function parameter or member 'txq_id' not described in 'il4965_tx_queue_stop_scheduler'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:2122: warning: Function parameter or member 'il' not described in 'il4965_tx_queue_set_q2ratid'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:2122: warning: Function parameter or member 'ra_tid' not described in 'il4965_tx_queue_set_q2ratid'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:2122: warning: Function parameter or member 'txq_id' not described in 'il4965_tx_queue_set_q2ratid'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:2153: warning: Function parameter or member 'il' not described in 'il4965_txq_agg_enable'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:2153: warning: Function parameter or member 'txq_id' not described in 'il4965_txq_agg_enable'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:2153: warning: Function parameter or member 'tx_fifo' not described in 'il4965_txq_agg_enable'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:2153: warning: Function parameter or member 'sta_id' not described in 'il4965_txq_agg_enable'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:2153: warning: Function parameter or member 'tid' not described in 'il4965_txq_agg_enable'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:2153: warning: Function parameter or member 'ssn_idx' not described in 'il4965_txq_agg_enable'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:2285: warning: Function parameter or member 'il' not described in 'il4965_txq_agg_disable'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:2285: warning: Function parameter or member 'txq_id' not described in 'il4965_txq_agg_disable'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:2285: warning: Function parameter or member 'ssn_idx' not described in 'il4965_txq_agg_disable'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:2285: warning: Function parameter or member 'tx_fifo' not described in 'il4965_txq_agg_disable'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:2500: warning: Function parameter or member 'il' not described in 'il4965_tx_status_reply_compressed_ba'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:2500: warning: Function parameter or member 'agg' not described in 'il4965_tx_status_reply_compressed_ba'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:2500: warning: Function parameter or member 'ba_resp' not described in 'il4965_tx_status_reply_compressed_ba'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:2651: warning: Function parameter or member 'il' not described in 'il4965_tx_status_reply_tx'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:2651: warning: Function parameter or member 'agg' not described in 'il4965_tx_status_reply_tx'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:2651: warning: Function parameter or member 'tx_resp' not described in 'il4965_tx_status_reply_tx'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:2651: warning: Function parameter or member 'txq_id' not described in 'il4965_tx_status_reply_tx'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:2651: warning: Function parameter or member 'start_idx' not described in 'il4965_tx_status_reply_tx'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:2761: warning: Function parameter or member 'il' not described in 'il4965_hdl_tx'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:2761: warning: Function parameter or member 'rxb' not described in 'il4965_hdl_tx'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:2882: warning: Function parameter or member 'il' not described in 'il4965_hwrate_to_tx_control'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:2882: warning: Function parameter or member 'rate_n_flags' not described in 'il4965_hwrate_to_tx_control'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:2882: warning: Function parameter or member 'info' not described in 'il4965_hwrate_to_tx_control'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:2908: warning: Function parameter or member 'il' not described in 'il4965_hdl_compressed_ba'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:2908: warning: Function parameter or member 'rxb' not described in 'il4965_hdl_compressed_ba'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:3514: warning: Function parameter or member 'il' not described in 'il4965_alloc_bcast_station'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:3554: warning: Function parameter or member 'il' not described in 'il4965_update_bcast_station'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:3587: warning: Function parameter or member 'il' not described in 'il4965_sta_tx_modify_enable_tid'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:3587: warning: Function parameter or member 'sta_id' not described in 'il4965_sta_tx_modify_enable_tid'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:3587: warning: Function parameter or member 'tid' not described in 'il4965_sta_tx_modify_enable_tid'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:3916: warning: Function parameter or member 'il' not described in 'il4965_hw_txq_free_tfd'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:3916: warning: Function parameter or member 'txq' not described in 'il4965_hw_txq_free_tfd'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:4059: warning: Function parameter or member 't' not described in 'il4965_bg_stats_periodic'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:4169: warning: Function parameter or member 'il' not described in 'il4965_setup_handlers'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:4211: warning: Function parameter or member 'il' not described in 'il4965_rx_handle'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:4767: warning: Function parameter or member 'ucode_raw' not described in 'il4965_ucode_callback'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:4767: warning: Function parameter or member 'context' not described in 'il4965_ucode_callback'
 drivers/net/wireless/intel/iwlegacy/4965-mac.c:5269: warning: Function parameter or member 'il' not described in 'il4965_alive_start'

Cc: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../net/wireless/intel/iwlegacy/4965-mac.c    | 55 +++++++++----------
 1 file changed, 25 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index e73c223a7d288..8df2ea82b97d8 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -226,7 +226,7 @@ il4965_hw_nic_init(struct il_priv *il)
 	return 0;
 }
 
-/**
+/*
  * il4965_dma_addr2rbd_ptr - convert a DMA address to a uCode read buffer ptr
  */
 static inline __le32
@@ -235,7 +235,7 @@ il4965_dma_addr2rbd_ptr(struct il_priv *il, dma_addr_t dma_addr)
 	return cpu_to_le32((u32) (dma_addr >> 8));
 }
 
-/**
+/*
  * il4965_rx_queue_restock - refill RX queue from pre-allocated pool
  *
  * If there are slots in the RX queue that need to be restocked,
@@ -288,7 +288,7 @@ il4965_rx_queue_restock(struct il_priv *il)
 	}
 }
 
-/**
+/*
  * il4965_rx_replenish - Move all used packet from rx_used to rx_free
  *
  * When moving to rx_free an SKB is allocated for the slot.
@@ -1127,7 +1127,7 @@ il4965_count_chain_bitmap(u32 chain_bitmap)
 	return res;
 }
 
-/**
+/*
  * il4965_set_rxon_chain - Set up Rx chain usage in "staging" RXON image
  *
  * Selects how many and which Rx receivers/antennas/chains to use.
@@ -1933,7 +1933,7 @@ il4965_free_dma_ptr(struct il_priv *il, struct il_dma_ptr *ptr)
 	memset(ptr, 0, sizeof(*ptr));
 }
 
-/**
+/*
  * il4965_hw_txq_ctx_free - Free TXQ Context
  *
  * Destroy all TX DMA queues and structures
@@ -1959,12 +1959,9 @@ il4965_hw_txq_ctx_free(struct il_priv *il)
 	il_free_txq_mem(il);
 }
 
-/**
+/*
  * il4965_txq_ctx_alloc - allocate TX queue context
  * Allocate all Tx DMA structures and initialize them
- *
- * @param il
- * @return error code
  */
 int
 il4965_txq_ctx_alloc(struct il_priv *il)
@@ -2060,7 +2057,7 @@ il4965_txq_ctx_unmap(struct il_priv *il)
 			il_tx_queue_unmap(il, txq_id);
 }
 
-/**
+/*
  * il4965_txq_ctx_stop - Stop all Tx DMA channels
  */
 void
@@ -2101,7 +2098,7 @@ il4965_txq_ctx_activate_free(struct il_priv *il)
 	return -1;
 }
 
-/**
+/*
  * il4965_tx_queue_stop_scheduler - Stop queue, but keep configuration
  */
 static void
@@ -2114,7 +2111,7 @@ il4965_tx_queue_stop_scheduler(struct il_priv *il, u16 txq_id)
 		   (1 << IL49_SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
 }
 
-/**
+/*
  * il4965_tx_queue_set_q2ratid - Map unique receiver/tid combination to a queue
  */
 static int
@@ -2141,7 +2138,7 @@ il4965_tx_queue_set_q2ratid(struct il_priv *il, u16 ra_tid, u16 txq_id)
 	return 0;
 }
 
-/**
+/*
  * il4965_tx_queue_agg_enable - Set up & enable aggregation for selected queue
  *
  * NOTE:  txq_id must be greater than IL49_FIRST_AMPDU_QUEUE,
@@ -2276,7 +2273,7 @@ il4965_tx_agg_start(struct il_priv *il, struct ieee80211_vif *vif,
 	return ret;
 }
 
-/**
+/*
  * txq_id must be greater than IL49_FIRST_AMPDU_QUEUE
  * il->lock must be held by the caller
  */
@@ -2488,7 +2485,7 @@ il4965_tx_queue_reclaim(struct il_priv *il, int txq_id, int idx)
 	return nfreed;
 }
 
-/**
+/*
  * il4965_tx_status_reply_compressed_ba - Update tx status from block-ack
  *
  * Go through block-ack's bitmap of ACK'd frames, update driver's record of
@@ -2641,7 +2638,7 @@ il4965_tx_status_to_mac80211(u32 status)
 	}
 }
 
-/**
+/*
  * il4965_tx_status_reply_tx - Handle Tx response for frames in aggregation queue
  */
 static int
@@ -2753,7 +2750,7 @@ il4965_tx_status_reply_tx(struct il_priv *il, struct il_ht_agg *agg,
 	return 0;
 }
 
-/**
+/*
  * il4965_hdl_tx - Handle standard (non-aggregation) Tx response
  */
 static void
@@ -2873,7 +2870,7 @@ il4965_hdl_tx(struct il_priv *il, struct il_rx_buf *rxb)
 	spin_unlock_irqrestore(&il->sta_lock, flags);
 }
 
-/**
+/*
  * translate ucode response to mac80211 tx status control values
  */
 void
@@ -2897,7 +2894,7 @@ il4965_hwrate_to_tx_control(struct il_priv *il, u32 rate_n_flags,
 	r->idx = il4965_hwrate_to_mac80211_idx(rate_n_flags, info->band);
 }
 
-/**
+/*
  * il4965_hdl_compressed_ba - Handler for N_COMPRESSED_BA
  *
  * Handles block-acknowledge notification from device, which reports success
@@ -3502,7 +3499,7 @@ il4965_set_dynamic_key(struct il_priv *il, struct ieee80211_key_conf *keyconf,
 	return ret;
 }
 
-/**
+/*
  * il4965_alloc_bcast_station - add broadcast station into driver's station table.
  *
  * This adds the broadcast station into the driver's station table
@@ -3543,7 +3540,7 @@ il4965_alloc_bcast_station(struct il_priv *il)
 	return 0;
 }
 
-/**
+/*
  * il4965_update_bcast_station - update broadcast station's LQ command
  *
  * Only used by iwl4965. Placed here to have all bcast station management
@@ -3579,7 +3576,7 @@ il4965_update_bcast_stations(struct il_priv *il)
 	return il4965_update_bcast_station(il);
 }
 
-/**
+/*
  * il4965_sta_tx_modify_enable_tid - Enable Tx for this TID in station table
  */
 int
@@ -3903,10 +3900,8 @@ il4965_tfd_get_num_tbs(struct il_tfd *tfd)
 	return tfd->num_tbs & 0x1f;
 }
 
-/**
+/*
  * il4965_hw_txq_free_tfd - Free all chunks referenced by TFD [txq->q.read_ptr]
- * @il - driver ilate data
- * @txq - tx queue
  *
  * Does NOT advance any TFD circular buffer read/write idxes
  * Does NOT free the TFD itself (which is within circular buffer)
@@ -4044,7 +4039,7 @@ il4965_hdl_alive(struct il_priv *il, struct il_rx_buf *rxb)
 		IL_WARN("uCode did not respond OK.\n");
 }
 
-/**
+/*
  * il4965_bg_stats_periodic - Timer callback to queue stats
  *
  * This callback is provided in order to send a stats request.
@@ -4155,7 +4150,7 @@ il4965_hdl_card_state(struct il_priv *il, struct il_rx_buf *rxb)
 		wake_up(&il->wait_command_queue);
 }
 
-/**
+/*
  * il4965_setup_handlers - Initialize Rx handler callbacks
  *
  * Setup the RX handlers for each of the reply types sent from the uCode
@@ -4199,7 +4194,7 @@ il4965_setup_handlers(struct il_priv *il)
 	il->handlers[C_TX] = il4965_hdl_tx;
 }
 
-/**
+/*
  * il4965_rx_handle - Main entry function for receiving responses from uCode
  *
  * Uses the il->handlers callback function array to invoke
@@ -4756,7 +4751,7 @@ il4965_load_firmware(struct il_priv *il, const struct firmware *ucode_raw,
 	return 0;
 }
 
-/**
+/*
  * il4965_ucode_callback - callback when firmware was loaded
  *
  * If loaded successfully, copies the firmware into buffers
@@ -5259,7 +5254,7 @@ il4965_alive_notify(struct il_priv *il)
 	return 0;
 }
 
-/**
+/*
  * il4965_alive_start - called after N_ALIVE notification received
  *                   from protocol/runtime uCode (initialization uCode's
  *                   Alive gets handled by il_init_alive_start()).
-- 
2.25.1

