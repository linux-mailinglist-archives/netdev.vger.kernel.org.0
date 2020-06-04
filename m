Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0801EDE78
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 09:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbgFDHek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 03:34:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:54773 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726246AbgFDHek (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jun 2020 03:34:40 -0400
IronPort-SDR: yioJl2FqHoISPIU3vUn+K7IUay0VHQVY+qwFEPGl7pJr0UnXqqb6iEYKZ4GOzDoRdnma9eogdk
 mwTk5S2D36gA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2020 00:34:38 -0700
IronPort-SDR: RxY9F998L7LxdaV5tLYQ9VS8rwntKgLWJKUDMupTFuK7X3+7E1qvpjhrUR+DTpy9mfAEbpz3Cw
 GFerA06WeBfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,471,1583222400"; 
   d="scan'208";a="348021468"
Received: from pg-nxl3.altera.com ([10.142.129.93])
  by orsmga001.jf.intel.com with ESMTP; 04 Jun 2020 00:34:35 -0700
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
Subject: [PATCH v3 03/10] net: eth: altera: fix altera_dmaops declaration
Date:   Thu,  4 Jun 2020 15:32:49 +0800
Message-Id: <20200604073256.25702-4-joyce.ooi@intel.com>
X-Mailer: git-send-email 2.13.0
In-Reply-To: <20200604073256.25702-1-joyce.ooi@intel.com>
References: <20200604073256.25702-1-joyce.ooi@intel.com>
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

