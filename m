Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A24B2642BCE
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 16:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbiLEPba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 10:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbiLEPa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 10:30:56 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E352DAE58;
        Mon,  5 Dec 2022 07:29:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670254192; x=1701790192;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xfrwrFSQ+RmaFVQRRwteEGengbJgDPmn2vp62lZIf/s=;
  b=CuqRRaOcq/WxNkWzzWzBO8Se5KHakAjfe2x+FldhxiIgCk+iSiHTr7mE
   0Ce6Y71FeJOYl0Fhmq5LB8H1Z3425lk5t3nGe2fb+I/bypiVc34yKKmEC
   LXwv9de1RV5EQ/6DQXAcdcUYLjXA30LR0s/i+AMFUXNNKTIwLZUzQzqZa
   DBE/JibAq5DGMshxLH3oLRdnBakPTG86RORXllwoGM42+NzbvxE430syR
   Fblkzwzz9b31C/q0ruCZY0lZLrc/4BJULoN0pSGj5XNsyICDEBSdYB3TI
   kzgJGtFXMmQPQmU5VLhmry8hqiMwj/V4cPUuEvfqLFuSjtymYkRuCU6Iv
   A==;
X-IronPort-AV: E=Sophos;i="5.96,219,1665471600"; 
   d="scan'208";a="126541652"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Dec 2022 08:29:36 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 5 Dec 2022 08:29:33 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 5 Dec 2022 08:29:29 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <andrew@lunn.ch>, <hkallweit1@gmail.com>
CC:     <sergiu.moga@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH 0/2] net: macb: fix connectivity after resume
Date:   Mon, 5 Dec 2022 17:33:26 +0200
Message-ID: <20221205153328.503576-1-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.33.0
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

Hi,

This series fixes connectivity on SAMA7G5 with KSZ9131 ethernet PHY.
Driver fix is in patch 2/2. Patch 1/2 is a prerequisite.

Thank you,
Claudiu Beznea

Claudiu Beznea (2):
  net: phylink: add helper to initialize phylink's phydev
  net: macb: fix connectivity after resume

 drivers/net/ethernet/cadence/macb_main.c |  1 +
 drivers/net/phy/phylink.c                | 10 ++++++++++
 include/linux/phylink.h                  |  1 +
 3 files changed, 12 insertions(+)

-- 
2.34.1

