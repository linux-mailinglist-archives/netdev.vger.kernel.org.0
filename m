Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF052B17EC
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 10:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgKMJLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 04:11:35 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:6674 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbgKMJL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 04:11:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1605258686; x=1636794686;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=erS1OQ3Z61CN7IwmlfAARj2JX5P7XW8lk1gRwq3g3/Y=;
  b=zeDl9mAPW0pJtAuovkxuOZsOGcv/VvWiORwiwz9sUUp6o7YYQC8uihM2
   Y21B48Pcf9as+wmz8hBwdM9LDL0xhLjJ0q4npjRRC38/VH1qfbL+1BI0o
   rlpcryl7IJvnIEZALCCpMtKO+/SzEUCnMOndXyQVKn/0ScPo111BRLH3r
   oBeqp8mkKKrEaE3QDMfCC4fFRm+eU5CvPuDep/LDt8UqdeiEfb1OJlAOD
   yS9/OH287nKlwyUQfEwTc8C/lNJwL3REivDhVwEytelGFLKy60a3xDDgw
   1u69ydPcBqmQ8QbIANOKa4y1X9h7nEe+3YaXdeA0gGhHnp0btJfxS5bMO
   Q==;
IronPort-SDR: PEaQC0WhcI9uYU/LxT4GzclO4RKEoTUj3n0Vcbe25aE5YsRzx7/CZ1B2Dx1ouw3YyGjF/Za+HT
 hOSbQQsp6nPVKx/e3VJZC/x9AjeTDd6L7n+G6VbnBjTnA3wjoAKOE8B6XBIgC4hzscwazwY8gO
 yDSxkgcQw8WkpNRYWnPolyKlFyHhtEI4ZKnFWld2AUBWQNO3qUwCnQuNFZMoQ6cdVj1MpsT5O9
 aI/7pWIAZwSJxvhzAP/WzGYKwkcrRgJmTEyiHVZ7U1yy6AlJPsg0hwh9xyzVXiPh/knHEz8Afi
 wv0=
X-IronPort-AV: E=Sophos;i="5.77,475,1596524400"; 
   d="scan'208";a="96196469"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Nov 2020 02:11:25 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 13 Nov 2020 02:11:25 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 13 Nov 2020 02:11:23 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Bryan Whitehead <Bryan.Whitehead@microchip.com>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        John Haechten <John.Haechten@microchip.com>,
        Netdev List <netdev@vger.kernel.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: [PATCH net v2] net: phy: mscc: remove non-MACSec compatible phy
Date:   Fri, 13 Nov 2020 10:11:16 +0100
Message-ID: <20201113091116.1102450-1-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Selecting VSC8575 as a MACSec PHY was not correct

The relevant datasheet can be found here:
  - VSC8575: https://www.microchip.com/wwwproducts/en/VSC8575

History:
v1 -> v2:
   - Corrected the sha in the "Fixes:" tag

Fixes: 1bbe0ecc2a1a ("net: phy: mscc: macsec initialization")
Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 drivers/net/phy/mscc/mscc_macsec.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/phy/mscc/mscc_macsec.c b/drivers/net/phy/mscc/mscc_macsec.c
index 1d4c012194e9..72292bf6c51c 100644
--- a/drivers/net/phy/mscc/mscc_macsec.c
+++ b/drivers/net/phy/mscc/mscc_macsec.c
@@ -981,7 +981,6 @@ int vsc8584_macsec_init(struct phy_device *phydev)

 	switch (phydev->phy_id & phydev->drv->phy_id_mask) {
 	case PHY_ID_VSC856X:
-	case PHY_ID_VSC8575:
 	case PHY_ID_VSC8582:
 	case PHY_ID_VSC8584:
 		INIT_LIST_HEAD(&vsc8531->macsec_flows);
--
2.29.2

