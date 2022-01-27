Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F08049E906
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 18:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238033AbiA0RbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 12:31:02 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:63388 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiA0RbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 12:31:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643304662; x=1674840662;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wBiqg6KpSTpTD+ZP/LZO4M6APIynzwTNdifOyl3E9Xw=;
  b=On3c6pEPgQ/puSpgosMNWV8H49mVHSLcHz9p2ngxqwSpmBybKuAWFzJw
   TH4KrgKfIdBDLEWFY76j3T9EmO1U6CNzUli62Iw+NxdTVzdmoTitkHnYa
   MCl0gC8jHawF6Lfg7zr8FlGHTAR21Ygp6GPO62gpKkjI1SjpeA0kd0OvI
   /VC3Hb7F7e1ajR8C/G0tGO/U7ixg6IM59LNAdd+i81oSCn7dIJSrOKomR
   i/Oy0HMPWLazzDJ+UME/7LlcJMfkBdlMUy35ZIxMNBuWMeP6SmMgIUMv2
   z6kQDgteCrrP6XkDwBmVrWXOwyk9voW0lK17iupNNHN96CxCs5gRlBYZY
   g==;
IronPort-SDR: kROeT/vzgGI6ZCroohJnaEmAF5O3bGEHx12+XckdqmTRjcIcs+DfDFq81rtGsKTazlA400d90E
 6iC05zs8ImDCatnn0Q4PIOgC2l7Qy34mKVndqR+hMe7i4GAohJazRQ5AXmKN9F94xvD2adb7CM
 kLCfGTZGPZP1HyclCsNUbj7Qs1PHWZjVBiSgAeeN6OR8a3HgZ+i1b2EtuXGyN/Tps1qmnHP9+7
 RzQ3VVTBjBd5BD0QJHWf0p5JBANmJeu3G5AaC32EtlKYQLoEjaNEopAosfTE0moB4g5jT0n1mk
 zOMr3s7OR8nQ5ROoChfNXahR
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="146829645"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2022 10:31:02 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 27 Jan 2022 10:31:01 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 27 Jan 2022 10:30:59 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next 0/5] net: lan743x: PCI1A011/PCI1A014 Enhancment 
Date:   Thu, 27 Jan 2022 23:00:50 +0530
Message-ID: <20220127173055.308918-1-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series extends PCI1A011/PCI1A014 chip new features as part of LAN743x chip driver.
PCI1A010/PCI1A014 chip provides a high performance and cost effective PCI-E/Ethernet
bridging solution alone with following enhancments.

  1. PCI-E pipe interface supports 1 Lane at 5GT/s
  2. Supports Multiple - 4 TX and 4 RX channels
  3. Add MSI-X interrupts increased from 8 to 16 and
     Interrupt De-assertion timers increased from 8 to 16
  4. Add support of selection between SGMII and GMII Interface
  5. Add Clause-45 MDIO access


Raju Lakkaraju (5):
  net: lan743x: Add PCI1A011/A041 chip driver
  net: lan743x: Add Tx 4 Queue enhancements
  net: lan743x: Add MSI-X interrupts increased from 8 to 16 and
    Interrupt De-assertion timers increased from 8 to 16
  net: lan743x: Add support of selection between SGMII and GMII
    Interface
  net: lan743x: Add Clause-45 MDIO access

 drivers/net/ethernet/microchip/lan743x_main.c | 277 ++++++++++++++++--
 drivers/net/ethernet/microchip/lan743x_main.h |  57 +++-
 drivers/net/ethernet/microchip/lan743x_ptp.c  |   8 +-
 3 files changed, 305 insertions(+), 37 deletions(-)

-- 
2.25.1

