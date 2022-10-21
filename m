Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03F2F606FB5
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 07:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbiJUF5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 01:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiJUF47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 01:56:59 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221E821552B;
        Thu, 20 Oct 2022 22:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666331817; x=1697867817;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LsRkCaZVpKL8z3Mn8l1oDAB4lBFp2a6v0EitFAqw37U=;
  b=WDU4grRc9qsammi2yJbXwnyZ4vgwKPeveoGVyhfRZQACuZ72ApFB8kLj
   GSFS5gP5jnLi+/E4gt6gB9ANSGAQwZPZ/GmSxuHVrh7uehkyZOz0MJyBF
   3UxHi8PlIr+jj/QJYlgKy9TG4prqVwq/q4OU0hla+V3pyM4x9+g6K6O9b
   yo511EPxug+sHFl8cF26gd6fChcSh9ikG20zcvzrK72Qn/qkiqK6VMTjs
   u6yyCsmDmElYkQ1IxrUjUutK7b1wQd48Lj8Dml3xFhImp/LVWLj6fUpZz
   9rNXFLbaWiod/eFiol5Kwz1gyySueo0EQSFDllPCpNG/CppGExWMe3SlP
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="185801004"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Oct 2022 22:56:55 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 20 Oct 2022 22:56:55 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 20 Oct 2022 22:56:51 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <hkallweit1@gmail.com>, <pabeni@redhat.com>, <edumazet@google.com>,
        <linux@armlinux.org.uk>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next 0/2] net: lan743x: PCI11010 / PCI11414 devices Enhancements 
Date:   Fri, 21 Oct 2022 11:26:40 +0530
Message-ID: <20221021055642.255413-1-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
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

