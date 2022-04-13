Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5878D4FF042
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 08:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233221AbiDMG7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 02:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbiDMG7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 02:59:19 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5C63123C;
        Tue, 12 Apr 2022 23:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649833020; x=1681369020;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CGsGFVAO3PkKrHgaEIbaSVs6VoFj0oPvYPHnw+nPmPE=;
  b=rO0gTD9xjYBwan9dfKzYlb01M9O/e1kpSLdLP9aQJdldhG4mmFvzJ59b
   JDlhsaHbb6y57bb9LspAgOCGEkrAHsWfZNwZiIxErDq0KTKjlioMZOWUM
   9oztoYTQJqLjPn7z/YUVV8yAwQpTXwWa529EVNRc+0BYRqs9t5//jlUWA
   ISyP2Id7/kiFCD5j/qb+uqOcSXJ6Ma1/rcHtbQBNRr54EuWPFXPE/pL4H
   s4xDmlCDkhRHy9TBZWqHOfT7lFcsdvRe5zuol2/zbR16hbTV3d51UZjHd
   Is0tj0OAAgdQ0S3X1/aiLpdsHooDGJy6q9wE3L3eC435nZqAkD2p7Fzhw
   w==;
X-IronPort-AV: E=Sophos;i="5.90,256,1643698800"; 
   d="scan'208";a="152483820"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Apr 2022 23:56:59 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 12 Apr 2022 23:56:58 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 12 Apr 2022 23:56:54 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
Subject: [Patch net-next v2 2/2] MAINTAINERS: Add maintainers for Microchip T1 Phy driver
Date:   Wed, 13 Apr 2022 12:25:57 +0530
Message-ID: <20220413065557.12914-3-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220413065557.12914-1-arun.ramadoss@microchip.com>
References: <20220413065557.12914-1-arun.ramadoss@microchip.com>
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
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index fd768d43e048..0363c8e70432 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12903,6 +12903,13 @@ F:	drivers/net/dsa/microchip/*
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

