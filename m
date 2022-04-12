Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 425D34FCFCD
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 08:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbiDLGi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 02:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiDLGgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 02:36:37 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119A435864;
        Mon, 11 Apr 2022 23:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649745234; x=1681281234;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1LpWZR+Z2lEZmibS9yfT78g4awIUuvEhpUMadNmEaRQ=;
  b=cHQY++OJ6gxE4oPtW32/3nH30BgUJkFIyuVhw5i3HYJVr5TF0VF8HKEh
   OzEsBhX/Itkz4vR+0uLaE4t/l/IrfpLmVDCm/X+ElbD3RL31BOwgTntSS
   KZ6H2GopIjV198qUlCfLV26iIhNCMgiLakIj7EBntJ87FJ4YzS8fUfo9O
   PN42VUXRFpZQJCKnJ5gLWRkW0khku7YWdmQ7SgWmwVBUBcC69N/OmhC5U
   67kZyQ1UcEVMEMOrIV3HFZa4klt6AQXFnRGnkMNHO9WfPzOoRci/aZzfv
   RZpI+Nz6OXepdm82k8s+PxSnbcddLK0pdV5LNFKdJVcRP7TvKEpihREfu
   A==;
X-IronPort-AV: E=Sophos;i="5.90,253,1643698800"; 
   d="scan'208";a="152337016"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Apr 2022 23:33:53 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 11 Apr 2022 23:33:52 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 11 Apr 2022 23:33:49 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>
Subject: [Patch net-next 3/3] MAINTAINERS: Add maintainers for Microchip T1 Phy driver
Date:   Tue, 12 Apr 2022 12:03:17 +0530
Message-ID: <20220412063317.4173-4-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220412063317.4173-1-arun.ramadoss@microchip.com>
References: <20220412063317.4173-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index fd768d43e048..cede8ccf19b2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12903,6 +12903,12 @@ F:	drivers/net/dsa/microchip/*
 F:	include/linux/platform_data/microchip-ksz.h
 F:	net/dsa/tag_ksz.c
 
+MICROCHIP LAN87xx/LAN937x T1 PHY DRIVER
+M:	UNGLinuxDriver@microchip.com
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/net/phy/microchip_t1.c
+
 MICROCHIP LAN743X ETHERNET DRIVER
 M:	Bryan Whitehead <bryan.whitehead@microchip.com>
 M:	UNGLinuxDriver@microchip.com
-- 
2.33.0

