Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1047508C02
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 17:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380191AbiDTPZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 11:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379997AbiDTPZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 11:25:25 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57AC745797;
        Wed, 20 Apr 2022 08:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1650468159; x=1682004159;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j+mvbu/M3dlkNs8jRAn3m6Ffvc707IPqJrGe+7x0aT4=;
  b=n+3Euad3BDJXQu/71vzpEtNo4yyAbkfbkwdIgsadXCo2u0hqCBda23vb
   DtZXDuYtjjJ2ofvcNL4c4xKsy0bpw7RnccCvRh8CLY6rP+YC7YuVa7EoK
   uakJOC/YB4vS1qpgQt/H5zSLhycpcYkN+J0zDMawvl3HtwO22mnyIaBDH
   l5v1shmWoNQ39yXm6jw/02Vlv4f3dUQEtSFr0xr7sivJaIvApvpTxazwf
   DLlXjdffFsfY4Hb8HgZSZj37c/6GIrxw9AnZhEIajkNtyXRemtRiS9X7V
   DinZtmd28kPRUQslFpkpMl643r1PfMUdXiA709uO/PbJFbmefVITIkzKH
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,276,1643698800"; 
   d="scan'208";a="92976880"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Apr 2022 08:21:05 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 20 Apr 2022 08:20:52 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 20 Apr 2022 08:20:47 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
Subject: [Patch net-next v3 2/2] MAINTAINERS: Add maintainers for Microchip T1 Phy driver
Date:   Wed, 20 Apr 2022 20:50:16 +0530
Message-ID: <20220420152016.9680-3-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220420152016.9680-1-arun.ramadoss@microchip.com>
References: <20220420152016.9680-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 25d2a5d417bc..1adf2cac1865 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12920,6 +12920,13 @@ F:	drivers/net/dsa/microchip/*
 F:	include/linux/platform_data/microchip-ksz.h
 F:	net/dsa/tag_ksz.c
 
+MICROCHIP LAN87xx/LAN937x T1 PHY DRIVER
+M:	Arun Ramadoss <arun.ramadoss@microchip.com>
+R:	UNGLinuxDriver@microchip.com
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/net/phy/microchip_t1.c
+
 MICROCHIP LAN743X ETHERNET DRIVER
 M:	Bryan Whitehead <bryan.whitehead@microchip.com>
 M:	UNGLinuxDriver@microchip.com
-- 
2.33.0

