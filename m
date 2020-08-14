Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28408244903
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 13:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728232AbgHNLlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 07:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728239AbgHNLkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 07:40:23 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6C8C061344
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:40:20 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id r2so8075656wrs.8
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BETUm1VsjAHaE9mSTvIErHbihrcPaijwVnn2xiQgls0=;
        b=K8YakLwQXGOsqfx28gwRQ+anspeFLdTWsKZ6Hb88B6w5tU+DE5CK/TOOil0CWNCXAu
         ffYdufP1kx1qwkJ9ouyEhwkIbzXcRkmsDWQzq8/XqtLXPy+y2Z/XVOEFa6gMxPEDeVkQ
         EQwSXEVmpKzK+GkwMptcX26ANSi3nFbr9aVTK5wZQCsCDzE2+QL9xl89zjqrAg4YsvIa
         sTUNe6XZMX14B4JRRT+6QRuodGaw/82z76iu5tYITweWAhbl/2R7Z3F2od1mKqeyRL1Z
         N+onSwvPoF7x4ZQ+YvnZKM+HsR5b5nGc24k7RD5a30ek24EIU4pOHZ1eag5gc52ATru8
         gvLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BETUm1VsjAHaE9mSTvIErHbihrcPaijwVnn2xiQgls0=;
        b=d0KHD0op1Lwm4biOK9eYfyKJ2eIEHFMml/nVsZZDY9zcgeEZJh7uHL+0px8zzDNt95
         3yJ3Dz+MmnvnRxOmfSNvyzITZu90mFDB8DpuXzDSakW2X8KfnMLFzeaDJHFJm0wREjZs
         87/Oqgpvpvlr4x6mGVEk4FtBuwZE/Z2XbcogKMfGs2/1vAlwNeVJj2XnKj8QRB4j8x64
         DybnnVM3Y5q86cVcV3e0pma+R51A+KZ6IC9+Iz0QZzb2i05Beq1vvZftyZEd1lvgMibX
         0o2Fhf03m+FIu8Fai7vnRn+BImyvbrQibm42WOZW8DNLshtlWoRe5Y+8XV7sz3LbJo+w
         KPIA==
X-Gm-Message-State: AOAM532mNl1vSb1W7IRam0HOJrU5sqgm+dpK0zAzBSyNVSquCHm+bdi1
        pv1yHxLN1a7e6X5Fx/mqIIrSjA==
X-Google-Smtp-Source: ABdhPJxIxjXAMbNxjAnHnCJBk/QJ0q8XoyiBfmFbg2rseOQ463H3p0d/reKBasOyl/LNP6JUO29kqQ==
X-Received: by 2002:a5d:4b11:: with SMTP id v17mr2343043wrq.224.1597405219704;
        Fri, 14 Aug 2020 04:40:19 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id 32sm16409129wrh.18.2020.08.14.04.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 04:40:18 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Gerald Combs <gerald@ethereal.com>,
        Linux Wireless <ilw@linux.intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 25/30] net: wireless: intel: ipw2x00: ipw2200: Demote lots of nonconformant kerneldoc comments
Date:   Fri, 14 Aug 2020 12:39:28 +0100
Message-Id: <20200814113933.1903438-26-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200814113933.1903438-1-lee.jones@linaro.org>
References: <20200814113933.1903438-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lots of these are either completely wrong or do not even attempt to
document any of the parameters.  Others use an incorrect/dated format
which is not recognised by the kernel (... and are also wrong and
suffering from docrot).

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/intel/ipw2x00/ipw2200.c:3011: warning: Function parameter or member 'priv' not described in 'ipw_alive'
 drivers/net/wireless/intel/ipw2x00/ipw2200.c:3693: warning: Incorrect use of kernel-doc format:  * Driver allocates buffers of this size for Rx
 drivers/net/wireless/intel/ipw2x00/ipw2200.c:3697: warning: Incorrect use of kernel-doc format:  * ipw_rx_queue_space - Return number of free slots available in queue.
 drivers/net/wireless/intel/ipw2x00/ipw2200.c:3700: warning: Function parameter or member 'q' not described in 'ipw_rx_queue_space'
 drivers/net/wireless/intel/ipw2x00/ipw2200.c:3743: warning: Function parameter or member 'priv' not described in 'ipw_queue_init'
 drivers/net/wireless/intel/ipw2x00/ipw2200.c:3743: warning: Function parameter or member 'q' not described in 'ipw_queue_init'
 drivers/net/wireless/intel/ipw2x00/ipw2200.c:3743: warning: Function parameter or member 'count' not described in 'ipw_queue_init'
 drivers/net/wireless/intel/ipw2x00/ipw2200.c:3743: warning: Function parameter or member 'read' not described in 'ipw_queue_init'
 drivers/net/wireless/intel/ipw2x00/ipw2200.c:3743: warning: Function parameter or member 'write' not described in 'ipw_queue_init'
 drivers/net/wireless/intel/ipw2x00/ipw2200.c:3743: warning: Function parameter or member 'base' not described in 'ipw_queue_init'
 drivers/net/wireless/intel/ipw2x00/ipw2200.c:3743: warning: Function parameter or member 'size' not described in 'ipw_queue_init'
 drivers/net/wireless/intel/ipw2x00/ipw2200.c:3800: warning: Function parameter or member 'priv' not described in 'ipw_queue_tx_free_tfd'
 drivers/net/wireless/intel/ipw2x00/ipw2200.c:3800: warning: Function parameter or member 'txq' not described in 'ipw_queue_tx_free_tfd'
 drivers/net/wireless/intel/ipw2x00/ipw2200.c:3841: warning: Function parameter or member 'priv' not described in 'ipw_queue_tx_free'
 drivers/net/wireless/intel/ipw2x00/ipw2200.c:3841: warning: Function parameter or member 'txq' not described in 'ipw_queue_tx_free'
 drivers/net/wireless/intel/ipw2x00/ipw2200.c:3869: warning: Function parameter or member 'priv' not described in 'ipw_tx_queue_free'
 drivers/net/wireless/intel/ipw2x00/ipw2200.c:4474: warning: Function parameter or member 'priv' not described in 'ipw_rx_notification'
 drivers/net/wireless/intel/ipw2x00/ipw2200.c:4474: warning: Function parameter or member 'notif' not described in 'ipw_rx_notification'
 drivers/net/wireless/intel/ipw2x00/ipw2200.c:4935: warning: Function parameter or member 'priv' not described in 'ipw_queue_reset'
 drivers/net/wireless/intel/ipw2x00/ipw2200.c:5008: warning: Function parameter or member 'priv' not described in 'ipw_queue_tx_reclaim'
 drivers/net/wireless/intel/ipw2x00/ipw2200.c:5008: warning: Function parameter or member 'txq' not described in 'ipw_queue_tx_reclaim'
 drivers/net/wireless/intel/ipw2x00/ipw2200.c:5008: warning: Function parameter or member 'qindex' not described in 'ipw_queue_tx_reclaim'
 drivers/net/wireless/intel/ipw2x00/ipw2200.c:8456: warning: Function parameter or member 'priv' not described in 'ipw_sw_reset'

Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Gerald Combs <gerald@ethereal.com>
Cc: Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 30 ++++++++++----------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index 5345f90837f5f..e7680702e1602 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -2998,7 +2998,7 @@ static void ipw_remove_current_network(struct ipw_priv *priv)
 	spin_unlock_irqrestore(&priv->ieee->lock, flags);
 }
 
-/**
+/*
  * Check that card is still alive.
  * Reads debug register from domain0.
  * If card is present, pre-defined value should
@@ -3113,7 +3113,7 @@ static int ipw_load_ucode(struct ipw_priv *priv, u8 * data, size_t len)
 	mdelay(1);
 
 	/* write ucode */
-	/**
+	/*
 	 * @bug
 	 * Do NOT set indirect address register once and then
 	 * store data to indirect data register in the loop.
@@ -3666,7 +3666,7 @@ static int ipw_load(struct ipw_priv *priv)
 	return rc;
 }
 
-/**
+/*
  * DMA services
  *
  * Theory of operation
@@ -3689,11 +3689,11 @@ static int ipw_load(struct ipw_priv *priv)
  * we only utilize the first data transmit queue (queue1).
  */
 
-/**
+/*
  * Driver allocates buffers of this size for Rx
  */
 
-/**
+/*
  * ipw_rx_queue_space - Return number of free slots available in queue.
  */
 static int ipw_rx_queue_space(const struct ipw_rx_queue *q)
@@ -3724,7 +3724,7 @@ static inline int ipw_queue_inc_wrap(int index, int n_bd)
 	return (++index == n_bd) ? 0 : index;
 }
 
-/**
+/*
  * Initialize common DMA queue structure
  *
  * @param q                queue to init
@@ -3788,7 +3788,7 @@ static int ipw_queue_tx_init(struct ipw_priv *priv,
 	return 0;
 }
 
-/**
+/*
  * Free one TFD, those at index [txq->q.last_used].
  * Do NOT advance any indexes
  *
@@ -3811,7 +3811,7 @@ static void ipw_queue_tx_free_tfd(struct ipw_priv *priv,
 	if (le32_to_cpu(bd->u.data.num_chunks) > NUM_TFD_CHUNKS) {
 		IPW_ERROR("Too many chunks: %i\n",
 			  le32_to_cpu(bd->u.data.num_chunks));
-		/** @todo issue fatal error, it is quite serious situation */
+		/* @todo issue fatal error, it is quite serious situation */
 		return;
 	}
 
@@ -3828,7 +3828,7 @@ static void ipw_queue_tx_free_tfd(struct ipw_priv *priv,
 	}
 }
 
-/**
+/*
  * Deallocate DMA queue.
  *
  * Empty queue by removing and destroying all BD's.
@@ -3860,7 +3860,7 @@ static void ipw_queue_tx_free(struct ipw_priv *priv, struct clx2_tx_queue *txq)
 	memset(txq, 0, sizeof(*txq));
 }
 
-/**
+/*
  * Destroy all DMA queues and structures
  *
  * @param priv
@@ -4465,7 +4465,7 @@ static void handle_scan_event(struct ipw_priv *priv)
 	}
 }
 
-/**
+/*
  * Handle host notification packet.
  * Called from interrupt routine
  */
@@ -4925,7 +4925,7 @@ static void ipw_rx_notification(struct ipw_priv *priv,
 	}
 }
 
-/**
+/*
  * Destroys all DMA structures and initialise them again
  *
  * @param priv
@@ -4934,7 +4934,7 @@ static void ipw_rx_notification(struct ipw_priv *priv,
 static int ipw_queue_reset(struct ipw_priv *priv)
 {
 	int rc = 0;
-	/** @todo customize queue sizes */
+	/* @todo customize queue sizes */
 	int nTx = 64, nTxCmd = 8;
 	ipw_tx_queue_free(priv);
 	/* Tx CMD queue */
@@ -4990,7 +4990,7 @@ static int ipw_queue_reset(struct ipw_priv *priv)
 	return rc;
 }
 
-/**
+/*
  * Reclaim Tx queue entries no more used by NIC.
  *
  * When FW advances 'R' index, all entries between old and
@@ -8445,7 +8445,7 @@ static void ipw_rx(struct ipw_priv *priv)
 #define	DEFAULT_SHORT_RETRY_LIMIT 7U
 #define	DEFAULT_LONG_RETRY_LIMIT  4U
 
-/**
+/*
  * ipw_sw_reset
  * @option: options to control different reset behaviour
  * 	    0 = reset everything except the 'disable' module_param
-- 
2.25.1

