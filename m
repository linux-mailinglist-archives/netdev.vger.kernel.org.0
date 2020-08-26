Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A249252A82
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 11:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728211AbgHZJkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 05:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728233AbgHZJeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 05:34:23 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B199CC06179E
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:09 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f7so1109462wrw.1
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v7pVwOhCe9Ig2UDjISm2nmmLj5krAF+eOIO1rewFf+g=;
        b=ZNXRsZBaDCK0ZGjlwQ3/PKGrGin7lml08qakgCCmU3ghxS0TAyUSGf7bHhNMbvss6a
         04cMzKGvqwACd1eu6LtK4yJXxM2cZqhEl+weIPkKneohREJt+O3rUodkDcXA06IvwnEV
         QedgFepoucQodHv0Gy8X08+8FjRQYP5fN9+AjkoJLCoEUypHfAwuWhzDL7iBHQMScE/M
         qHfDIuA0KcTbxc2DkSswBCbRI82TRNn58UCdgd+sjqyhyJBPrYBLJ0eXX75AG5rKC9X5
         4j/FXgyhAfdI7GbqJp6KIxIh3dVxL4OqoJpmXOGYZObKef1URzb+n0Q8ekrkWzkUU4zJ
         S1Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v7pVwOhCe9Ig2UDjISm2nmmLj5krAF+eOIO1rewFf+g=;
        b=M/gUni+b7p6BBjeUNKiu4qkBgcvxAISYijpKCsNUECwii4h9PWiwOImm8CjsmcsLk7
         mF/9H7iKYSTITTL2zG7M3Roi+oDtgJws1O9AI8wd3ugVPoKpK5CuIoeG0e+f9iihiFFD
         kywbIQN1EvJumJfNNoAOLw9YvjMpdsDLstyZb+pASJwGeKOkm+LI/88bOlPwB7opx3kp
         yPtVHpx8iwUvGB5bXChlm6Ubvhb6gveLb74a/TD7I0sniox9dV/paRrgVAGvGR5d6kSw
         5naZzhgW3QfpQ+rtTmCZw9PnwJgG2j8/SSdDI/K8L2zlf4CIEXRuSGLKyXJnManvqKBb
         zhdQ==
X-Gm-Message-State: AOAM530YCzQ9+Exc7W/7pPb9jotFsND36H/22C4ORl6ljZc52guwS7O4
        GFIyHhUDN/4cWdEhtvrXVvhQCw==
X-Google-Smtp-Source: ABdhPJyIbIRpqvP+7xXrtcRfk3zKm0N1qPj1jPRSiyJMDbehUK8NJchs4Gc7fXuINtEK779DgyOoSg==
X-Received: by 2002:adf:ef8c:: with SMTP id d12mr9875191wro.282.1598434448303;
        Wed, 26 Aug 2020 02:34:08 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id u3sm3978759wml.44.2020.08.26.02.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 02:34:07 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Linux Wireless <ilw@linux.intel.com>
Subject: [PATCH 03/30] wireless: intel: iwlegacy: 3945-mac: Remove all non-conformant kernel-doc headers
Date:   Wed, 26 Aug 2020 10:33:34 +0100
Message-Id: <20200826093401.1458456-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200826093401.1458456-1-lee.jones@linaro.org>
References: <20200826093401.1458456-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/intel/iwlegacy/3945-mac.c:821: warning: Function parameter or member 'il' not described in 'il3945_setup_handlers'
 drivers/net/wireless/intel/iwlegacy/3945-mac.c:915: warning: Function parameter or member 'il' not described in 'il3945_dma_addr2rbd_ptr'
 drivers/net/wireless/intel/iwlegacy/3945-mac.c:915: warning: Function parameter or member 'dma_addr' not described in 'il3945_dma_addr2rbd_ptr'
 drivers/net/wireless/intel/iwlegacy/3945-mac.c:932: warning: Function parameter or member 'il' not described in 'il3945_rx_queue_restock'
 drivers/net/wireless/intel/iwlegacy/3945-mac.c:979: warning: Function parameter or member 'il' not described in 'il3945_rx_allocate'
 drivers/net/wireless/intel/iwlegacy/3945-mac.c:979: warning: Function parameter or member 'priority' not described in 'il3945_rx_allocate'
 drivers/net/wireless/intel/iwlegacy/3945-mac.c:1179: warning: Function parameter or member 'il' not described in 'il3945_rx_handle'
 drivers/net/wireless/intel/iwlegacy/3945-mac.c:1663: warning: Function parameter or member 'il' not described in 'il3945_verify_inst_full'
 drivers/net/wireless/intel/iwlegacy/3945-mac.c:1663: warning: Function parameter or member 'image' not described in 'il3945_verify_inst_full'
 drivers/net/wireless/intel/iwlegacy/3945-mac.c:1663: warning: Function parameter or member 'len' not described in 'il3945_verify_inst_full'
 drivers/net/wireless/intel/iwlegacy/3945-mac.c:1703: warning: Function parameter or member 'il' not described in 'il3945_verify_inst_sparse'
 drivers/net/wireless/intel/iwlegacy/3945-mac.c:1703: warning: Function parameter or member 'image' not described in 'il3945_verify_inst_sparse'
 drivers/net/wireless/intel/iwlegacy/3945-mac.c:1703: warning: Function parameter or member 'len' not described in 'il3945_verify_inst_sparse'
 drivers/net/wireless/intel/iwlegacy/3945-mac.c:1739: warning: Function parameter or member 'il' not described in 'il3945_verify_ucode'
 drivers/net/wireless/intel/iwlegacy/3945-mac.c:1821: warning: Function parameter or member 'il' not described in 'il3945_read_ucode'
 drivers/net/wireless/intel/iwlegacy/3945-mac.c:2061: warning: Function parameter or member 'il' not described in 'il3945_set_ucode_ptrs'
 drivers/net/wireless/intel/iwlegacy/3945-mac.c:2093: warning: Function parameter or member 'il' not described in 'il3945_init_alive_start'
 drivers/net/wireless/intel/iwlegacy/3945-mac.c:2135: warning: Function parameter or member 'il' not described in 'il3945_alive_start'

Cc: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../net/wireless/intel/iwlegacy/3945-mac.c    | 24 +++++++++----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
index 9167c3d2711dd..3a3439492dc16 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -807,7 +807,7 @@ il3945_hdl_card_state(struct il_priv *il, struct il_rx_buf *rxb)
 		wake_up(&il->wait_command_queue);
 }
 
-/**
+/*
  * il3945_setup_handlers - Initialize Rx handler callbacks
  *
  * Setup the RX handlers for each of the reply types sent from the uCode
@@ -907,7 +907,7 @@ il3945_setup_handlers(struct il_priv *il)
  *
  */
 
-/**
+/*
  * il3945_dma_addr2rbd_ptr - convert a DMA address to a uCode read buffer ptr
  */
 static inline __le32
@@ -916,7 +916,7 @@ il3945_dma_addr2rbd_ptr(struct il_priv *il, dma_addr_t dma_addr)
 	return cpu_to_le32((u32) dma_addr);
 }
 
-/**
+/*
  * il3945_rx_queue_restock - refill RX queue from pre-allocated pool
  *
  * If there are slots in the RX queue that need to be restocked,
@@ -966,7 +966,7 @@ il3945_rx_queue_restock(struct il_priv *il)
 	}
 }
 
-/**
+/*
  * il3945_rx_replenish - Move all used packet from rx_used to rx_free
  *
  * When moving to rx_free an SKB is allocated for the slot.
@@ -1167,7 +1167,7 @@ il3945_calc_db_from_ratio(int sig_ratio)
 	return (int)ratio2dB[sig_ratio];
 }
 
-/**
+/*
  * il3945_rx_handle - Main entry function for receiving responses from uCode
  *
  * Uses the il->handlers callback function array to invoke
@@ -1654,7 +1654,7 @@ il3945_dealloc_ucode_pci(struct il_priv *il)
 	il_free_fw_desc(il->pci_dev, &il->ucode_boot);
 }
 
-/**
+/*
  * il3945_verify_inst_full - verify runtime uCode image in card vs. host,
  *     looking at all data.
  */
@@ -1693,7 +1693,7 @@ il3945_verify_inst_full(struct il_priv *il, __le32 * image, u32 len)
 	return rc;
 }
 
-/**
+/*
  * il3945_verify_inst_sparse - verify runtime uCode image in card vs. host,
  *   using sample data 100 bytes apart.  If these sample points are good,
  *   it's a pretty good bet that everything between them is good, too.
@@ -1730,7 +1730,7 @@ il3945_verify_inst_sparse(struct il_priv *il, __le32 * image, u32 len)
 	return rc;
 }
 
-/**
+/*
  * il3945_verify_ucode - determine which instruction image is in SRAM,
  *    and verify its contents
  */
@@ -1811,7 +1811,7 @@ IL3945_UCODE_GET(init_size);
 IL3945_UCODE_GET(init_data_size);
 IL3945_UCODE_GET(boot_size);
 
-/**
+/*
  * il3945_read_ucode - Read uCode images from disk file.
  *
  * Copy into buffers for card to fetch via bus-mastering
@@ -2047,7 +2047,7 @@ il3945_read_ucode(struct il_priv *il)
 	return ret;
 }
 
-/**
+/*
  * il3945_set_ucode_ptrs - Set uCode address location
  *
  * Tell initialization uCode where to find runtime uCode.
@@ -2081,7 +2081,7 @@ il3945_set_ucode_ptrs(struct il_priv *il)
 	return 0;
 }
 
-/**
+/*
  * il3945_init_alive_start - Called after N_ALIVE notification received
  *
  * Called after N_ALIVE notification received from "initialize" uCode.
@@ -2125,7 +2125,7 @@ il3945_init_alive_start(struct il_priv *il)
 	queue_work(il->workqueue, &il->restart);
 }
 
-/**
+/*
  * il3945_alive_start - called after N_ALIVE notification received
  *                   from protocol/runtime uCode (initialization uCode's
  *                   Alive gets handled by il3945_init_alive_start()).
-- 
2.25.1

