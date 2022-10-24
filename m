Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F924609C72
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 10:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbiJXI0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 04:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbiJXI0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 04:26:33 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E162A13DF7;
        Mon, 24 Oct 2022 01:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666599928; x=1698135928;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zxfmL7WI4PJELDNo6RfAIkpBA7tQO751UfPqTdA+1Ww=;
  b=ZQPUawR91gwUlsrOLoa1jShXQG+ihwVeYpVjQPYvO6MG/K73tRGoOoAG
   6QXz2XLN9BldWfPIIVX8o4xiAmY++bC/ZByYP7rX3HGMNOBjPjGBrVguD
   zDKdAXK+P0HujAmBEl1SpGFlHKo1Gve7cdkl9y7sUy6WMn25EY/uvt4pG
   lfuG9IQk3D7zwGsCdM9CFoXJkWSabji8ggx/7qW8QiWBsaFzS7OKOqnzc
   SfB4ElokzXvPTiybFSAKdNCn/nAG89kmk5rXRQwY7Zb3guGbWJO2yADWa
   k2Sfbwp8YxK2iQp/PzDXghsRAtE6uSe804WiV3zd5rFD2A3swfOcRZIEv
   A==;
X-IronPort-AV: E=Sophos;i="5.95,207,1661842800"; 
   d="scan'208";a="180199093"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Oct 2022 01:25:27 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 24 Oct 2022 01:25:24 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 24 Oct 2022 01:25:20 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <hkallweit1@gmail.com>, <pabeni@redhat.com>, <edumazet@google.com>,
        <linux@armlinux.org.uk>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next V1 0/2] net: lan743x: PCI11010 / PCI11414 devices Enhancements
Date:   Mon, 24 Oct 2022 13:55:14 +0530
Message-ID: <20221024082516.661199-1-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
  net: lan743x: Add support for get_pauseparam and set_pauseparam
  net: phy: micrel: Add PHY Auto/MDI/MDI-X set driver for KSZ9131

 .../net/ethernet/microchip/lan743x_ethtool.c  | 46 +++++++++++
 drivers/net/ethernet/microchip/lan743x_main.c |  4 +-
 drivers/net/ethernet/microchip/lan743x_main.h |  2 +
 drivers/net/phy/micrel.c                      | 77 +++++++++++++++++++
 4 files changed, 127 insertions(+), 2 deletions(-)

-- 
2.25.1

