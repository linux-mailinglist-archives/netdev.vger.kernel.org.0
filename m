Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF1B247A8E
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 00:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729777AbgHQWkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 18:40:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45531 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728989AbgHQWkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 18:40:51 -0400
Received: from [82.43.126.140] (helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1k7no2-00005w-Be; Mon, 17 Aug 2020 22:40:42 +0000
From:   Colin King <colin.king@canonical.com>
To:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: mscc: ocelot: remove duplicate "the the" phrase in Kconfig text
Date:   Mon, 17 Aug 2020 23:40:42 +0100
Message-Id: <20200817224042.5826-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The Kconfig help text contains the phrase "the the" in the help
text. Fix this.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/dsa/ocelot/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index f121619d81fe..2d23ccef7d0e 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -9,7 +9,7 @@ config NET_DSA_MSCC_FELIX
 	select NET_DSA_TAG_OCELOT
 	select FSL_ENETC_MDIO
 	help
-	  This driver supports network switches from the the Vitesse /
+	  This driver supports network switches from the Vitesse /
 	  Microsemi / Microchip Ocelot family of switching cores that are
 	  connected to their host CPU via Ethernet.
 	  The following switches are supported:
-- 
2.27.0

