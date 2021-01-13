Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97AF02F4ACF
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 13:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727353AbhAML6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 06:58:09 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:25424 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbhAML6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 06:58:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610539088; x=1642075088;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=PMwf4wWAVbFQj0z2nAVv/zjNVBwenzJxINuBK+GzT/M=;
  b=dbO9iEe5Gb2yg3XhTkykWRIeUYWFywG+gVjbhII0l7sMDq30b1C6x6Bj
   BZBfvgCIcn6zDW66gYd6Q/szNB3C4VkOYa2QSe9OrOdbT2w16nmt9PFlX
   MdouClN4BjVZfxE0IfLOBgRLhNTGdMOGbC1Ku8KFigAtrqzNoR5yBJ8KR
   UC1fpsSDTNH0JCgpvviA/Mc09sohjZQTjYDisTihKTMGsjMQ7Oj1MEPzl
   N0muT4iF2QaZc87Gbv9MITkoF2gIxCHQtFNvbYbBEVRSnlAm37KN274aN
   sk3PGzaScUQqGlEmVvYc0zebl7yBsttFq3zlc3UVBxYIZ/1rmaSaf4ylN
   Q==;
IronPort-SDR: IIew6hSuKRkq0W7DKyYOeOirx2FUZzefoIIrVL9F8GecSTwaF+/V1HesdOQW2W8enpf22j1DZ5
 grlckGqiB5y9qAZ0YMzaEF/vm3bAP32s36t/rlRjNSIfP9qUVI5SJt2d9azPuv8FHe79GjgTew
 pOBhrQTSDPVApiHJvMa/SAMoaq1ZhwCGJXdcOl6DxIcJFQeKYMN4Zt5ZTNJsYqNGPDP37eoTwj
 /TkhfCor5mf60X3pI1el/GDCExHexMC4OtN5UsPhyg81xRor6MPMriPExXHsbUX433X187Ctla
 /U0=
X-IronPort-AV: E=Sophos;i="5.79,344,1602572400"; 
   d="scan'208";a="99930655"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jan 2021 04:56:52 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 13 Jan 2021 04:56:52 -0700
Received: from soft-dev2.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 13 Jan 2021 04:56:50 -0700
From:   Bjarni Jonasson <bjarni.jonasson@microchip.com>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next v2 0/2] Add 100 base-x mode
Date:   Wed, 13 Jan 2021 12:56:24 +0100
Message-ID: <20210113115626.17381-1-bjarni.jonasson@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support for 100 base-x in phylink.
The Sparx5 switch supports 100 base-x pcs (IEEE 802.3 Clause 24) 4b5b encoded.
These patches adds phylink support for that mode.

Tested in Sparx5, using sfp modules:
Axcen 100fx AXFE-1314-0521 (base-fx) 
Axcen 100lx AXFE-1314-0551 (base-lx) 
HP SFP 100FX J9054C (bx-10) 
Excom SFP-SX-M1002 (base-lx)

v1 -> v2:
  Added description to Documentation/networking/phy.rst
  Moved PHY_INTERFACE_MODE_100BASEX to above 1000BASEX
  Patching against net-next

Bjarni Jonasson (2):
  net: phy: Add 100 base-x mode
  sfp: add support for 100 base-x SFPs

 Documentation/networking/phy.rst | 5 +++++
 drivers/net/phy/sfp-bus.c        | 9 +++++++++
 include/linux/phy.h              | 4 ++++
 3 files changed, 18 insertions(+)

-- 
2.17.1

