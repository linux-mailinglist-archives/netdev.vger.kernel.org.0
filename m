Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D802C2DC310
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 16:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgLPP0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 10:26:37 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:47316 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbgLPP0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 10:26:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1608132398; x=1639668398;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=jjmAvvsvgXwVOcNoqn+MyJ+R7DS7LF4RrbQk/wuM1LM=;
  b=01co3IvLj68nOUgq/Dt8TAAPqVVjIN1Uw3+CpfdW6S3VerQFaSHmYqoW
   E5rAN5m0R40P7lebbPO7FT4qLVQ6yHoykgNrNt1CLpIg5NAKxQlttP+7u
   796oT41fGkFFhQ2Pl+r9pSmHNIBZExAJBoKwIInlum0B0FYGPaSdKSSZS
   INjJNXYrLWK4qjgyZ3QdC9d3OVpERxPleKmBalE57+kuy5h5alohcUbbG
   VSA23Tb/E+HLLxLzCNe8RuYjCITVctUxB/wa0rboYuxG6KIzqCjlKH935
   KP/pFH3So0OWzCzC0c8lCQ538Qclx5V/wthVevv3lBrjvcREth73ji1eY
   A==;
IronPort-SDR: mGcyzO3m+F9USQkKWa1zZWX8/Q/lN0tp3uhMYP/qLKoG0O+Qb/2m/lkpnl9cyCeDMupzGlDcF+
 YEoVuHLtal4KC4KreIV2oZUebeg2BFLDVZP7iJuvwtHyhxn2ySToQwYIt9msAktvGhD+KVYs0I
 sE1Bzvx52Juiehks+qKyBDJ34XCGDanMSW4hSFKnJyeS7PaumHm1CZ3YYvvyJHOEqkiN2KgtwQ
 iLvUJjQ0Q/yg4WjFmm8FOBrU4nRzPkV4MZKPYmw6Bfis1Z1gS7xabEynxpIrkjSi9z7c3Hwlpw
 kng=
X-IronPort-AV: E=Sophos;i="5.78,424,1599548400"; 
   d="scan'208";a="102440223"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Dec 2020 08:25:21 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 16 Dec 2020 08:25:20 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 16 Dec 2020 08:25:17 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <marex@denx.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>
Subject: [PATCH v3 net-next 0/2] net: phy: mchp: Add support for 1588 driver and interrupt support 
Date:   Wed, 16 Dec 2020 20:55:13 +0530
Message-ID: <20201216152513.6402-1-Divya.Koppera@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add support for Linkup/Linkdown suport for LAN8814 phy
and 1588 Driver support for the same phy.

v2->v3
-Split the patch into 2 patches, one is linkup/linkdown interrupt
 and the other is 1588 driver support.

v1->v2
-Fixed warnings
 Reported-by: kernel test robot <lkp@intel.com>

Divya Koppera (2):
  net: phy: mchp: Add interrupt support for Link up and Link down to
    LAN8814 phy
  net: phy: mchp: Add 1588 support for LAN8814 Quad PHY

 drivers/net/phy/micrel.c | 1007 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 1006 insertions(+), 1 deletion(-)

-- 
2.17.1

