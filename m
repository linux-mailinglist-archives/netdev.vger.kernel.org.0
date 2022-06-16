Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29FDC54D924
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 06:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358634AbiFPEMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 00:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240761AbiFPEMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 00:12:42 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB3A6571;
        Wed, 15 Jun 2022 21:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655352759; x=1686888759;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GcfUXG/FlEauPLRxyyqrtpSCMoY7Lx2968tA2aSM+4I=;
  b=ZUnom+SHyh5EzHiX0CKFK2YKifqP7kYgJt0CVGhaIJ1MevCKHwlhdymR
   +p+mKqQCma/3FWJUS1XKKGugGlBVbpLndd+4thyNgSaW96s6VH6w/zZtv
   HtPnAiG/jmSoRtOcH/9R7x/8hvv0yygCPZtaX/GiimkllW9cLrvg62s4C
   JxHCu7FWz8deEd8iVYHiVpqmlCzhQfB/f6XuRStVN/Zjvuo6afU5+TtHQ
   NEUBgxLUYZXx2z4P5J8N2BPdw55/CshF8JC4GW8RbKZcvw5oZElGGRrQd
   Bdaj1fnnq7FcfEnATlsrOi3idFOW/20ebwGutiPbEGLa5Bc9am+p+u0sz
   A==;
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="160559990"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jun 2022 21:12:38 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 15 Jun 2022 21:12:36 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 15 Jun 2022 21:12:32 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <lxu@maxlinear.com>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <bryan.whitehead@microchip.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next V2 0/4] net: lan743x: PCI11010 / PCI11414 devices Enhancements 
Date:   Thu, 16 Jun 2022 09:42:22 +0530
Message-ID: <20220616041226.26996-1-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series continues with the addition of supported features             
for the Ethernet function of the PCI11010 / PCI11414 devices to                 
the LAN743x driver. 

Raju Lakkaraju (4):
  net: lan743x: Add support to LAN743x register dump
  net: lan743x: Add support to Secure-ON WOL
  net: lan743x: Add support to SGMII 1G and 2.5G
  net: phy: add support to get Master-Slave configuration

 .../net/ethernet/microchip/lan743x_ethtool.c  |  63 ++-
 .../net/ethernet/microchip/lan743x_ethtool.h  |  26 ++
 drivers/net/ethernet/microchip/lan743x_main.c | 378 +++++++++++++++++-
 drivers/net/ethernet/microchip/lan743x_main.h | 106 +++++
 drivers/net/phy/mxl-gpy.c                     |   3 +
 5 files changed, 567 insertions(+), 9 deletions(-)

-- 
2.25.1

