Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B54FC3405AD
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 13:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbhCRMj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 08:39:29 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:34956 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhCRMjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 08:39:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1616071141; x=1647607141;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=J5jlrc2VeKgOvy0jyClyf+2Dnd+isCTTtMSWuxSOtYU=;
  b=k2DFq+eXr5mWsdV1Qxg6yvjY6UhOc0itunVPdfdM/QD5+j8L9YsmI/iV
   12hpJem3GUk1us2/r9TfBeUmXhQctTHVAJK0PfDBN7yezHIdNSRPmQTG5
   NRfCI5t4QrV6sznucSPk8IJd6n2DMKkYXiH31sNMLKkNF5fVYcVJfd4SS
   DhYh1uovs1WYbTi9XBDj7XiKy3bGFN0vc1CI4jdqX+7Y1U28S1Yk7VJ7Y
   VrWTvZJgvbUOvShBuvqxqOqBxt2n0tnUz5LG18dBgrg2nHjEo7t0mqeLi
   9b+s6qwWgoyesNrcdutwlx+yg8uQmDZZ7V88gwVptqcpEMq737pg615jY
   Q==;
IronPort-SDR: uJDsn/Zyo0AStb3SnWv445AisFm6vYo0Ocxjo1dVleEcmu0ZEVXTsrVCTP+0NKfy6aXoTtPBaX
 sthSf2i/c6YyS7nGCEl3iZDcoirqHC/V7pIoWS8Mb3SfplRZjfgtdvZ/+3973cYI956wp0U3e9
 s6oaLift8M6XqReAXWphx2KI2sJzmqIgXUg2etlf2gxv7DIoaB/HXf4nwJSegzY3a6c/DUZ+i9
 ag/0gLagDJbiwv2cOUdyN2ftm409HujtVOHPwFBHn7lWpg7rs0F3/qcc5marKbXRJhyiDdoiW1
 j5M=
X-IronPort-AV: E=Sophos;i="5.81,258,1610434800"; 
   d="scan'208";a="110478482"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Mar 2021 05:39:01 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 18 Mar 2021 05:39:00 -0700
Received: from soft-dev2.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Thu, 18 Mar 2021 05:38:57 -0700
From:   Bjarni Jonasson <bjarni.jonasson@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Vladimir Oltean" <vladimir.oltean@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        Michael Walle <michael@walle.cc>
CC:     Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next v1 0/3] Fixes applied to VCS8584 family
Date:   Thu, 18 Mar 2021 13:38:48 +0100
Message-ID: <20210318123851.10324-1-bjarni.jonasson@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Three different fixes applied to VSC8584 family:
1. LCPLL reset
2. Serdes calibration
3. Coma mode disabled

The same fixes has already been applied to VSC8514
and most of the functionality can be reused for the VSC8584.

Bjarni Jonasson (3):
  net: phy: mscc: Applying LCPLL reset to VSC8584
  net: phy: mscc: improved serdes calibration applied to VSC8584
  net: phy: mscc: coma mode disabled for VSC8584

 drivers/net/phy/mscc/mscc_main.c | 219 +++++++++++++++++++++++--------
 1 file changed, 162 insertions(+), 57 deletions(-)

-- 
2.17.1

