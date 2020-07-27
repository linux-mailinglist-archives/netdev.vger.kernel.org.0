Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2685F22E8D2
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbgG0JXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 05:23:55 -0400
Received: from mga04.intel.com ([192.55.52.120]:61549 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726315AbgG0JXz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 05:23:55 -0400
IronPort-SDR: rZbIDD6voblG7o8JvDtE7GUGQr/pysa14J+X9acICLhQlunQJggj2TCMyUa1lOh4xodXWnP3S0
 HRDLZHnUMv+A==
X-IronPort-AV: E=McAfee;i="6000,8403,9694"; a="148454931"
X-IronPort-AV: E=Sophos;i="5.75,402,1589266800"; 
   d="scan'208";a="148454931"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 02:23:55 -0700
IronPort-SDR: r5OdIxDpmb0lPUEmTgiF/kI2TG2cBA5/g1Zs4l30xQfG71HKjZEkS2K5jE3OhupmCUptW/3msn
 8lW6r9y+EfZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,402,1589266800"; 
   d="scan'208";a="303393947"
Received: from pg-nxl3.altera.com ([10.142.129.93])
  by orsmga002.jf.intel.com with ESMTP; 27 Jul 2020 02:23:51 -0700
From:   "Ooi, Joyce" <joyce.ooi@intel.com>
To:     Thor Thayer <thor.thayer@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dalon Westergreen <dalon.westergreen@linux.intel.com>,
        Joyce Ooi <joyce.ooi@intel.com>,
        Tan Ley Foon <ley.foon.tan@intel.com>,
        See Chin Liang <chin.liang.see@intel.com>,
        Dinh Nguyen <dinh.nguyen@intel.com>
Subject: [PATCH v5 06/10] net: eth: altera: Add missing identifier names to function declarations
Date:   Mon, 27 Jul 2020 17:21:53 +0800
Message-Id: <20200727092157.115937-7-joyce.ooi@intel.com>
X-Mailer: git-send-email 2.13.0
In-Reply-To: <20200727092157.115937-1-joyce.ooi@intel.com>
References: <20200727092157.115937-1-joyce.ooi@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dalon Westergreen <dalon.westergreen@linux.intel.com>

The sgdma and msgdma header files included function declarations
without identifier names for pointers.  Add appropriate identifier
names.

Signed-off-by: Dalon Westergreen <dalon.westergreen@linux.intel.com>
Signed-off-by: Joyce Ooi <joyce.ooi@intel.com>
Reviewed-by: Thor Thayer <thor.thayer@linux.intel.com>
---
v2: this patch is added in patch version 2
v3: no change
v4: no change
v5: no change
---
 drivers/net/ethernet/altera/altera_msgdma.h | 30 ++++++++++++++-------------
 drivers/net/ethernet/altera/altera_sgdma.h  | 32 +++++++++++++++--------------
 2 files changed, 33 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/altera/altera_msgdma.h b/drivers/net/ethernet/altera/altera_msgdma.h
index 9813fbfff4d3..23f5b2a13898 100644
--- a/drivers/net/ethernet/altera/altera_msgdma.h
+++ b/drivers/net/ethernet/altera/altera_msgdma.h
@@ -6,19 +6,21 @@
 #ifndef __ALTERA_MSGDMA_H__
 #define __ALTERA_MSGDMA_H__
 
-void msgdma_reset(struct altera_tse_private *);
-void msgdma_enable_txirq(struct altera_tse_private *);
-void msgdma_enable_rxirq(struct altera_tse_private *);
-void msgdma_disable_rxirq(struct altera_tse_private *);
-void msgdma_disable_txirq(struct altera_tse_private *);
-void msgdma_clear_rxirq(struct altera_tse_private *);
-void msgdma_clear_txirq(struct altera_tse_private *);
-u32 msgdma_tx_completions(struct altera_tse_private *);
-void msgdma_add_rx_desc(struct altera_tse_private *, struct tse_buffer *);
-int msgdma_tx_buffer(struct altera_tse_private *, struct tse_buffer *);
-u32 msgdma_rx_status(struct altera_tse_private *);
-int msgdma_initialize(struct altera_tse_private *);
-void msgdma_uninitialize(struct altera_tse_private *);
-void msgdma_start_rxdma(struct altera_tse_private *);
+void msgdma_reset(struct altera_tse_private *priv);
+void msgdma_enable_txirq(struct altera_tse_private *priv);
+void msgdma_enable_rxirq(struct altera_tse_private *priv);
+void msgdma_disable_rxirq(struct altera_tse_private *priv);
+void msgdma_disable_txirq(struct altera_tse_private *priv);
+void msgdma_clear_rxirq(struct altera_tse_private *priv);
+void msgdma_clear_txirq(struct altera_tse_private *priv);
+u32 msgdma_tx_completions(struct altera_tse_private *priv);
+void msgdma_add_rx_desc(struct altera_tse_private *priv,
+			struct tse_buffer *buffer);
+int msgdma_tx_buffer(struct altera_tse_private *priv,
+		     struct tse_buffer *buffer);
+u32 msgdma_rx_status(struct altera_tse_private *priv);
+int msgdma_initialize(struct altera_tse_private *priv);
+void msgdma_uninitialize(struct altera_tse_private *priv);
+void msgdma_start_rxdma(struct altera_tse_private *priv);
 
 #endif /*  __ALTERA_MSGDMA_H__ */
diff --git a/drivers/net/ethernet/altera/altera_sgdma.h b/drivers/net/ethernet/altera/altera_sgdma.h
index 08afe1c9994f..3fb201417820 100644
--- a/drivers/net/ethernet/altera/altera_sgdma.h
+++ b/drivers/net/ethernet/altera/altera_sgdma.h
@@ -6,20 +6,22 @@
 #ifndef __ALTERA_SGDMA_H__
 #define __ALTERA_SGDMA_H__
 
-void sgdma_reset(struct altera_tse_private *);
-void sgdma_enable_txirq(struct altera_tse_private *);
-void sgdma_enable_rxirq(struct altera_tse_private *);
-void sgdma_disable_rxirq(struct altera_tse_private *);
-void sgdma_disable_txirq(struct altera_tse_private *);
-void sgdma_clear_rxirq(struct altera_tse_private *);
-void sgdma_clear_txirq(struct altera_tse_private *);
-int sgdma_tx_buffer(struct altera_tse_private *priv, struct tse_buffer *);
-u32 sgdma_tx_completions(struct altera_tse_private *);
-void sgdma_add_rx_desc(struct altera_tse_private *priv, struct tse_buffer *);
-void sgdma_status(struct altera_tse_private *);
-u32 sgdma_rx_status(struct altera_tse_private *);
-int sgdma_initialize(struct altera_tse_private *);
-void sgdma_uninitialize(struct altera_tse_private *);
-void sgdma_start_rxdma(struct altera_tse_private *);
+void sgdma_reset(struct altera_tse_private *priv);
+void sgdma_enable_txirq(struct altera_tse_private *priv);
+void sgdma_enable_rxirq(struct altera_tse_private *priv);
+void sgdma_disable_rxirq(struct altera_tse_private *priv);
+void sgdma_disable_txirq(struct altera_tse_private *priv);
+void sgdma_clear_rxirq(struct altera_tse_private *priv);
+void sgdma_clear_txirq(struct altera_tse_private *priv);
+int sgdma_tx_buffer(struct altera_tse_private *priv,
+		    struct tse_buffer *buffer);
+u32 sgdma_tx_completions(struct altera_tse_private *priv);
+void sgdma_add_rx_desc(struct altera_tse_private *priv,
+		       struct tse_buffer *buffer);
+void sgdma_status(struct altera_tse_private *priv);
+u32 sgdma_rx_status(struct altera_tse_private *priv);
+int sgdma_initialize(struct altera_tse_private *priv);
+void sgdma_uninitialize(struct altera_tse_private *priv);
+void sgdma_start_rxdma(struct altera_tse_private *priv);
 
 #endif /*  __ALTERA_SGDMA_H__ */
-- 
2.13.0

