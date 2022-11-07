Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE0961EB5F
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 08:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbiKGHPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 02:15:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbiKGHPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 02:15:08 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6370A12A82;
        Sun,  6 Nov 2022 23:15:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667805308; x=1699341308;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=M3CpiXaCIH2kSsPdd0r4xHlDyjK4mIsvIwHjStjTM70=;
  b=KdVuWYYMZVNfiqmTcGY4LqyPJ7yecrKCOlTQVEJbfaHLlXUZrOZHyO7p
   vVUlIORVWhOBEobC/lAQ+WZ3vvb0+xoW6zaP9ib5kYEQ9hTzF7jloyZmq
   +iwgXp/unIthXUQfuZJU+YeDzCal3a4sTjP3E5a2fWWluXQSFIbNma5ks
   H/E2HY1OzFvpKe+UPwajWkMppe/7Zu2vKODyJ1nrbzUvzey4r036jCkmb
   qdBD4cgOf8ePGFixoqJc3aTz56bJQdzwjVSXf4fUjE14z3bEpMPJM7xEL
   JXg7XdMAqxmSeaoYRzK002YkL+cdE5S36JsjOR61fqyAXsJhcPjxCU0QX
   g==;
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="187874906"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Nov 2022 00:15:06 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 7 Nov 2022 00:15:03 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 7 Nov 2022 00:14:59 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <pabeni@redhat.com>, <edumazet@google.com>, <olteanv@gmail.com>,
        <linux@armlinux.org.uk>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next V7 0/2] net: lan743x: PCI11010 / PCI11414 devices Enhancements 
Date:   Mon, 7 Nov 2022 12:44:48 +0530
Message-ID: <20221107071450.669700-1-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

 .../net/ethernet/microchip/lan743x_ethtool.c  | 111 +++++++++++++++++-
 .../net/ethernet/microchip/lan743x_ethtool.h  |  71 ++++++++++-
 drivers/net/ethernet/microchip/lan743x_main.c |   2 +-
 drivers/net/ethernet/microchip/lan743x_main.h |   1 +
 4 files changed, 178 insertions(+), 7 deletions(-)

-- 
2.25.1

