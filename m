Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5D22B0180
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 10:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbgKLJEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 04:04:46 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:35012 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgKLJEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 04:04:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1605171883; x=1636707883;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Pf01YMY57E0HtdaEMX585jOJYFUOzOV1guCrIO2NDAk=;
  b=eJASvRsdjWr6FGo4iECSEoPNNeqPm2sKKaw1EGn5RiMH+CrxJhN8WFX3
   AgRrj0P/ilVYUuNYc67XPPPQxsuptIJyrpDHTb/S6hRKBBKuIovqRXHY6
   08vlV3F3Vvs35FesW52RJpdQOaGpAA3i17q4oj+av0MyhHJVnqTtzmOr9
   wTXM5A5TuzzcZhCYtb62l+jViJA5rk3ToZ4W4WbFfopiSr5QJgz8pq7uF
   hyMJIsYUJMLpUhibQd4G3mG+FX7QHFVwtL8GgfJojr4VtR3NsZ6kAe4jR
   ZCPbFxHd5KTfLR0BWSYVJiOIFmcJu0kwMvM7TUjUmegMhal183du7i8Mb
   g==;
IronPort-SDR: izD/ACmva2j5Pu0wMut+cYkDZUeqwcamwC0T+t51iXSQagJry6Drqo50t5uIOTw3T5Z8PrB3Ux
 7wg59shq1IWQcZe//d2s/1AdnqyjHm3rdDDIXQLJO2PpMROLfVo6celHo87xOLDPh/1Ue8k3YG
 9lBM0rPodF+wIvZlYVlkCSCjS0c8+9OD8ALnMLIluTI+d9U9aYmZrZLZomeoRNQNmFb8FQZj8r
 SjGt9/7Moh++ssUBgIkopDS1MpxImnZJR2bZSn1Cx96u5cXjohxoeFJ3tkcR3PD16U5qrIAyZB
 Cug=
X-IronPort-AV: E=Sophos;i="5.77,471,1596524400"; 
   d="scan'208";a="33343202"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Nov 2020 02:04:42 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 12 Nov 2020 02:04:42 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 12 Nov 2020 02:04:40 -0700
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
Subject: [PATCH net] net: phy: mscc: remove non-MACSec compatible phy
Date:   Thu, 12 Nov 2020 10:04:29 +0100
Message-ID: <20201112090429.906000-1-steen.hegelund@microchip.com>
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

Fixes: 0a504e9e97886 ("net: phy: mscc: macsec initialization")
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

