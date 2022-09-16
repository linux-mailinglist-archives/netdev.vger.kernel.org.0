Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 260A45BA81B
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 10:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbiIPIXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 04:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiIPIXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 04:23:42 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1E9A4B2E;
        Fri, 16 Sep 2022 01:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663316619; x=1694852619;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=eAuJ6AUb+efqmaesy69my2y8iGjUfbGvTpufN8/32lc=;
  b=y/I5uWXwBOyIelRUU34w2OExIbku2/Tn8293NSUzR852pcAHDDWxcALa
   Ozsta3f4tyx88Ixij3Enz+u7e4bUORgEOPm2RO1OSGbn2TvTRHH9kojw5
   O0d4memcpB1kuLMIFfo1Tq/XPyMu4s3zU1kxn5feRm0jfaNISeDO/Ik08
   B4WLA3ZpdHH/6c0eLgFGrsBVq8W9aXR5lpk1u6KPTis84mHz8z5uklEIF
   yA3EmcAEdVhe/QEqE+YZfihJ7evGG5OTR9Wed3CwQeJXqD5ACmC/3jAsJ
   u6mSi90+bxTuiEYFpeWMTibX0NE10rl4chf9RUen7aAag0hCd/UHwa8fg
   w==;
X-IronPort-AV: E=Sophos;i="5.93,320,1654585200"; 
   d="scan'208";a="174167157"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Sep 2022 01:23:37 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 16 Sep 2022 01:23:34 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 16 Sep 2022 01:23:31 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <lxu@maxlinear.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next 0/2] net: lan743x: PCI11010 / PCI11414 devices Enhancements 
Date:   Fri, 16 Sep 2022 13:53:25 +0530
Message-ID: <20220916082327.370579-1-Raju.Lakkaraju@microchip.com>
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

Raju Lakkaraju (2):
  net: lan743x: Remove PTP_PF_EXTTS support for non-PCI11x1x devices
  net: lan743x: Add support to SGMII register dump for PCI11010/PCI11414
    chips

 .../net/ethernet/microchip/lan743x_ethtool.c  | 136 +++++++++++++++++-
 .../net/ethernet/microchip/lan743x_ethtool.h  |  70 +++++++++
 drivers/net/ethernet/microchip/lan743x_main.c |  16 +++
 drivers/net/ethernet/microchip/lan743x_main.h |   9 +-
 drivers/net/ethernet/microchip/lan743x_ptp.c  |   7 +
 5 files changed, 235 insertions(+), 3 deletions(-)

-- 
2.25.1

