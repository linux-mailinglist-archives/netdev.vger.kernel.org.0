Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB504E2CF3
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 16:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348482AbiCUPzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 11:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244429AbiCUPzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 11:55:22 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 993B43E5D3;
        Mon, 21 Mar 2022 08:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647878035; x=1679414035;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=I9RX3C0tTmX7DGBFBhnhQZzb22Lth00ZXRJB+AVXio0=;
  b=uz+16ItnVO7YKdWjH4gMa1azmPczozIFc7yxxRtorFx4j1mwk4zsh31d
   DnJd090W793SHEYOCJu8wVYNV6K9EX8VSnpbkbc/9hM38UM+Lp6fciqb0
   OVjpJOMzX01Z9OK9lQ3G/QN2OITzOCMGZ/ChdJsIrMby+ufGC1wWoCmti
   9moJCxCA60rZtoXmMg9taOJY9TxCOLfkP+XBGIXRplNpFTXFmvOG42wSF
   CKS2NdMFoOaVvFXCtLYzcgoNK21eOx/GCqjDqf8aSl2jz7N9TtpUJwy8R
   /GmXdulbFbJSesO0No/eVVkPEUPL8f5Yx3RwaksqTdL8TJs5+w3fTZZur
   g==;
X-IronPort-AV: E=Sophos;i="5.90,199,1643698800"; 
   d="scan'208";a="166536552"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Mar 2022 08:53:54 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 21 Mar 2022 08:53:54 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 21 Mar 2022 08:53:49 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>
Subject: [RFC Patch net-next 0/3] add ethtool SQI support for LAN87xx T1 Phy
Date:   Mon, 21 Mar 2022 21:23:34 +0530
Message-ID: <20220321155337.16260-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series add the Signal Quality Index measurement for the LAN87xx and
LAN937x T1 phy.

Arun Ramadoss (3):
  net: phy: lan87xx: added lan87xx_update_link routine
  net: phy: lan937x: added PHY_POLL_CABLE_TEST flag
  net: phy: lan87xx: added ethtool SQI support

 drivers/net/phy/microchip_t1.c | 146 ++++++++++++++++++++++++++++++++-
 1 file changed, 145 insertions(+), 1 deletion(-)


base-commit: 092d992b76ed9d06389af0bc5efd5279d7b1ed9f
-- 
2.33.0

