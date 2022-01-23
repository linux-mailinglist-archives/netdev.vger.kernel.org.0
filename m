Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A464249717E
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 13:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236322AbiAWMfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 07:35:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbiAWMff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 07:35:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA6DC06173B;
        Sun, 23 Jan 2022 04:35:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BDD260C03;
        Sun, 23 Jan 2022 12:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19892C340E2;
        Sun, 23 Jan 2022 12:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642941334;
        bh=S7js9MyhutpXKmExYcJoR4zt9vRfN4FPoO8fosVNf8o=;
        h=From:To:Cc:Subject:Date:From;
        b=lMhV36RUtivGR2ajyZ4IVzQdcYtCJWjwS95KCwl4XFCV4p9oePljYqgy8SyABn0MQ
         B94uTywz1BX/96guAzyapy72PshjyqR07AIn8RSi6QNDsTLzM7W+yNYxODPm24BFTN
         9w+h9/ugmHo6q3x0++ji6hGie0YouDnfGwZ6Z3Gl3IAaxiKBiQMwy+KdtkZlhivo/x
         iJ2BygJPf40eKwxuICcKKX2ugytVlZKpViwbAFJhX64vRqVW5myo3bhk0OwlGx4UAQ
         VfCXuWUnHoTyRkVcUzFugC5zHcUJf5C9SSZEAy4DsDeSAdNDFOPySEO2p1Mb3DVB8J
         69kjbOQEBnRoA==
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: stmmac: remove unused members in struct stmmac_priv
Date:   Sun, 23 Jan 2022 20:27:58 +0800
Message-Id: <20220123122758.2876-1-jszhang@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tx_coalesce and mii_irq are not used at all now, so remove them.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 40b5ed94cb54..5b195d5051d6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -194,7 +194,6 @@ struct stmmac_priv {
 	u32 tx_coal_timer[MTL_MAX_TX_QUEUES];
 	u32 rx_coal_frames[MTL_MAX_TX_QUEUES];
 
-	int tx_coalesce;
 	int hwts_tx_en;
 	bool tx_path_in_lpi_mode;
 	bool tso;
@@ -229,7 +228,6 @@ struct stmmac_priv {
 	unsigned int flow_ctrl;
 	unsigned int pause;
 	struct mii_bus *mii;
-	int mii_irq[PHY_MAX_ADDR];
 
 	struct phylink_config phylink_config;
 	struct phylink *phylink;
-- 
2.34.1

