Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A19E5BACD8
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 13:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbiIPL6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 07:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbiIPL6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 07:58:07 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39FAFAF483;
        Fri, 16 Sep 2022 04:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663329488; x=1694865488;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dlqFZHQeRZZCTsB1QJSDhfJsBS070b0o4YliA5CB28I=;
  b=qFvMXMXG6S1cvXqbz3Mm0Ug45kgCzh0qP6i2ukUXiVLAMmOPjVCo/IsZ
   xM5ZKsubywExq5cuYOVKzRrmVKJxkgqw0ZAJ3hsovFtgMhxHsqTUCFrF6
   2xG+tlJmwbcqFuwMWuUrs0jL3IYrEPvWA6zgcM7Svgyos662d8RHhr8ao
   1O6Ywu11PTqumGd3797wH2PzB6s8evPfI1zNBV957hQGwPQYB6fEIJoRB
   2UE1CJr3KBwUatrQ6cPbr5xFcF+E3lG1KgW/P/yq13phDzAwrJlceJ99A
   K3KSaC6koCY/UtTGzV6Kh3llX4okjOA4SFG3REaZXtTgkMACjc31UwbPY
   w==;
X-IronPort-AV: E=Sophos;i="5.93,320,1654585200"; 
   d="scan'208";a="180676469"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Sep 2022 04:58:05 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 16 Sep 2022 04:58:04 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 16 Sep 2022 04:58:01 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <richardcochran@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <Ian.Saturley@microchip.com>
Subject: [PATCH net-next V1 0/2] net: lan743x: PCI11010 / PCI11414 devices Enhancements 
Date:   Fri, 16 Sep 2022 17:27:56 +0530
Message-ID: <20220916115758.73560-1-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series address the Remove PTP_PF_EXTTS support for                   
 non-PCI11x1x devices and Add support to SGMII register dump

Changes:
========
V0 -> V1:
 - Removed unwanted code

Raju Lakkaraju (2):
  net: lan743x: Remove PTP_PF_EXTTS support for non-PCI11x1x devices
  net: lan743x: Add support to SGMII register dump for PCI11010/PCI11414
    chips

 .../net/ethernet/microchip/lan743x_ethtool.c  | 100 +++++++++++++++++-
 .../net/ethernet/microchip/lan743x_ethtool.h  |  70 ++++++++++++
 drivers/net/ethernet/microchip/lan743x_main.c |  14 +++
 drivers/net/ethernet/microchip/lan743x_main.h |   6 +-
 drivers/net/ethernet/microchip/lan743x_ptp.c  |   7 ++
 5 files changed, 194 insertions(+), 3 deletions(-)

-- 
2.25.1

