Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 019AE616132
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 11:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbiKBKsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 06:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiKBKso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 06:48:44 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C5DC5C;
        Wed,  2 Nov 2022 03:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667386124; x=1698922124;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=edHOf5luIxoZPK1XmegEi2KJITjWBjkPA1+qnliepjE=;
  b=NF/ejZQSd/MwF9zAOyfTMo5EItVSvVd8YxHN6hgGYqQx58WkkfwMbsKU
   3l1VSyNlpPCijlEpS8rzLh1lVGliIZO6J9sMMrS4cnDyf0ZPvy8YsBdUk
   nLDu+q/BbrIV5uhWUZI5gUMNZuxHT2d+6jVEnOC0uoLNpEsiQXNMzYODw
   UJerfMYcaSAdvvdpRZCf2pc35PeJGhjDeLifwViFL9JzY07jcfvrxb8J8
   ZlLxGr0pSzc+/WukUEQhJz7vPK3FfriDcG3HD/N9DIRJPm/j1wTt1LYcG
   wL1ZadPRd3FSayuLFAqkd9L96n3YFIcLm6mdBKm3jarbpw0m1eeFsU+5N
   w==;
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="181574726"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Nov 2022 03:48:44 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 2 Nov 2022 03:48:41 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 2 Nov 2022 03:48:37 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <pabeni@redhat.com>, <edumazet@google.com>, <olteanv@gmail.com>,
        <linux@armlinux.org.uk>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next V6 0/2]net: lan743x: PCI11010 / PCI11414 devices Enhancements 
Date:   Wed, 2 Nov 2022 16:18:32 +0530
Message-ID: <20221102104834.5555-1-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series continues with the addition of supported features for the
Ethernet function of the PCI11010 / PCI11414 devices to the LAN743x driver.

Raju Lakkaraju (2):
  net: lan743x: Remove unused argument in lan743x_common_regs( )
  net: lan743x: Add support to SGMII register dump for PCI11010/PCI11414
    chips

 .../net/ethernet/microchip/lan743x_ethtool.c  | 113 ++++++++++++++++--
 .../net/ethernet/microchip/lan743x_ethtool.h  |  71 ++++++++++-
 drivers/net/ethernet/microchip/lan743x_main.c |   2 +-
 drivers/net/ethernet/microchip/lan743x_main.h |   1 +
 4 files changed, 178 insertions(+), 9 deletions(-)

-- 
2.25.1

