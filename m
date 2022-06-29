Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CABA55FB29
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 10:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbiF2I6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 04:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbiF2I61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 04:58:27 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708B2A441;
        Wed, 29 Jun 2022 01:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656493106; x=1688029106;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=z38me1hxJbpP621/D8hR4lHQm+9F9xpLz5jNvZ8BQjM=;
  b=AfwhNY+mQthMQzN1YVYLnoWmMmt5kHtSGEOiBl8Uyu6qy7V8C3c8ptvR
   xLb+elbXIiqNORbHNMzLG8ctjKGcSbsENksASr55B+ldEch8z7FA6fjWe
   SbVUbI3uOp4tRoV+8zGzrpQSmk1MMnVeOPinwQFT/v6F+2UQ7q2F/S5cw
   F8uwXOcrNsd52VyHEfaO2FaD92hEn0I3/nF2sDNr7DxOLNCy6nnF0fqsu
   1n1zszn9s26cFAeVBVIivS5mkkH/C6WmePmxSNniY3XfBonY/SejkqD7J
   gvHXGAa9B1dLQlHGxrU1bSRO3EcI50XPoUo6fypfqKQOKjiw0RGOLd2YW
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="102242125"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Jun 2022 01:58:10 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 29 Jun 2022 01:58:09 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 29 Jun 2022 01:58:04 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <devicetree@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <Madhuri.Sripada@microchip.com>
Subject: [PATCH v2 net-next 0/2] LED feature for LAN8814 PHY
Date:   Wed, 29 Jun 2022 14:27:58 +0530
Message-ID: <20220629085800.11600-1-Divya.Koppera@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable LED mode configuration for LAN8814 PHY

v1 -> v2:
- Updated dt-bindings for micrel,led-mode in LAN8814 PHY

Divya Koppera (2):
  dt-bindings: net: Updated micrel,led-mode for LAN8814 PHY
  net: phy: micrel: Adding LED feature for LAN8814 PHY

 .../devicetree/bindings/net/micrel.txt        |  1 +
 drivers/net/phy/micrel.c                      | 71 +++++++++++++++----
 2 files changed, 57 insertions(+), 15 deletions(-)

-- 
2.17.1

