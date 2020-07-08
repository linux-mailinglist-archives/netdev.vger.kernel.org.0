Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF94218120
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 09:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730436AbgGHHZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 03:25:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:60669 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730009AbgGHHZK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 03:25:10 -0400
IronPort-SDR: g674s7xNsq7iIi5nNgdgMS+f21u8RY9Nj2enR21uTXAez+kXJHGDbuNnrzfJCYEuwb+FxOIbuJ
 FK5bjaZRtyzA==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="149264568"
X-IronPort-AV: E=Sophos;i="5.75,327,1589266800"; 
   d="scan'208";a="149264568"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 00:25:10 -0700
IronPort-SDR: IHLstHTu5jVziUO1pU/soYmb40/w43VTxZjztC2FZFX2WCyseitXo4j9Fk3uh5jaGZAAU2ZrzR
 16h/h2Rovyuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,327,1589266800"; 
   d="scan'208";a="358025085"
Received: from pg-nxl3.altera.com ([10.142.129.93])
  by orsmga001.jf.intel.com with ESMTP; 08 Jul 2020 00:25:03 -0700
From:   "Ooi, Joyce" <joyce.ooi@intel.com>
To:     Thor Thayer <thor.thayer@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dalon Westergreen <dalon.westergreen@linux.intel.com>,
        Joyce Ooi <joyce.ooi@intel.com>,
        Tan Ley Foon <ley.foon.tan@intel.com>,
        See Chin Liang <chin.liang.see@intel.com>,
        Dinh Nguyen <dinh.nguyen@intel.com>,
        Dalon Westergreen <dalon.westergreen@intel.com>
Subject: [PATCH v4 03/10] net: eth: altera: fix altera_dmaops declaration
Date:   Wed,  8 Jul 2020 15:23:54 +0800
Message-Id: <20200708072401.169150-4-joyce.ooi@intel.com>
X-Mailer: git-send-email 2.13.0
In-Reply-To: <20200708072401.169150-1-joyce.ooi@intel.com>
References: <20200708072401.169150-1-joyce.ooi@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dalon Westergreen <dalon.westergreen@intel.com>

The declaration of struct altera_dmaops does not have
identifier names.  Add identifier names to confrom with
required coding styles.

Signed-off-by: Dalon Westergreen <dalon.westergreen@intel.com>
Signed-off-by: Joyce Ooi <joyce.ooi@intel.com>
---
v2: no change
v3: no change
v4: no change
---
 drivers/net/ethernet/altera/altera_tse.h | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/altera/altera_tse.h b/drivers/net/ethernet/altera/altera_tse.h
index f17acfb579a0..7d0c98fc103e 100644
--- a/drivers/net/ethernet/altera/altera_tse.h
+++ b/drivers/net/ethernet/altera/altera_tse.h
@@ -385,20 +385,22 @@ struct altera_tse_private;
 struct altera_dmaops {
 	int altera_dtype;
 	int dmamask;
-	void (*reset_dma)(struct altera_tse_private *);
-	void (*enable_txirq)(struct altera_tse_private *);
-	void (*enable_rxirq)(struct altera_tse_private *);
-	void (*disable_txirq)(struct altera_tse_private *);
-	void (*disable_rxirq)(struct altera_tse_private *);
-	void (*clear_txirq)(struct altera_tse_private *);
-	void (*clear_rxirq)(struct altera_tse_private *);
-	int (*tx_buffer)(struct altera_tse_private *, struct tse_buffer *);
-	u32 (*tx_completions)(struct altera_tse_private *);
-	void (*add_rx_desc)(struct altera_tse_private *, struct tse_buffer *);
-	u32 (*get_rx_status)(struct altera_tse_private *);
-	int (*init_dma)(struct altera_tse_private *);
-	void (*uninit_dma)(struct altera_tse_private *);
-	void (*start_rxdma)(struct altera_tse_private *);
+	void (*reset_dma)(struct altera_tse_private *priv);
+	void (*enable_txirq)(struct altera_tse_private *priv);
+	void (*enable_rxirq)(struct altera_tse_private *priv);
+	void (*disable_txirq)(struct altera_tse_private *priv);
+	void (*disable_rxirq)(struct altera_tse_private *priv);
+	void (*clear_txirq)(struct altera_tse_private *priv);
+	void (*clear_rxirq)(struct altera_tse_private *priv);
+	int (*tx_buffer)(struct altera_tse_private *priv,
+			 struct tse_buffer *buffer);
+	u32 (*tx_completions)(struct altera_tse_private *priv);
+	void (*add_rx_desc)(struct altera_tse_private *priv,
+			    struct tse_buffer *buffer);
+	u32 (*get_rx_status)(struct altera_tse_private *priv);
+	int (*init_dma)(struct altera_tse_private *priv);
+	void (*uninit_dma)(struct altera_tse_private *priv);
+	void (*start_rxdma)(struct altera_tse_private *priv);
 };
 
 /* This structure is private to each device.
-- 
2.13.0

