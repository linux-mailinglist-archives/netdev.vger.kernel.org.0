Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4F85230DD
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 12:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239410AbiEKKmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 06:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233219AbiEKKk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 06:40:27 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC659C2F4;
        Wed, 11 May 2022 03:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1652265556; x=1683801556;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w2nhb5NZ8lL/nz/rsbaV2GMM0nKmRzv+ajQgmrnfFVk=;
  b=PdFhLqrYkTj3DwyUVpL7FGo+KGcjXtNKxeXLoNyt4bX73PQisViXvpcd
   yBOHaVWRtoTdpu2cYlEBwoPJ8aMQTK/ljMW4XJSJPo3WRu51EOGlJqYsR
   nNvLW+Kll/mWIaeumzOSlcHe5X6g40SUzgo1pz1NO0nUqFSwUkJg7K0G5
   vkVe4bRVUCHOCtT/EC/Yk/e6SSeIMwtLO4Tkw3OgBEDPneyxPqXO907d9
   8TQcPcDGBB3qRBcvCAPYhUy/16GaAN32IC1DEp0vdkl9vwh/rD6r8cIRq
   hZnUR8nEU+635B4N9KBavvAvUege9JvbeFwImO5sFfAo5OD4xzjdLpSwx
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,216,1647327600"; 
   d="scan'208";a="158596767"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 May 2022 03:39:15 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 11 May 2022 03:39:15 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 11 May 2022 03:39:10 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Russell King <linux@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Marek Vasut <marex@denx.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [RFC Patch net-next 8/9] net: dsa: microchip: remove unused members in ksz_device
Date:   Wed, 11 May 2022 16:07:54 +0530
Message-ID: <20220511103755.12553-9-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220511103755.12553-1-arun.ramadoss@microchip.com>
References: <20220511103755.12553-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The name, regs_size and overrides members in struct ksz_device are
unused. Hence remove it.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 0c1dc87c8176..8b51dd49d6dc 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -67,7 +67,6 @@ struct ksz_port {
 struct ksz_device {
 	struct dsa_switch *ds;
 	struct ksz_platform_data *pdata;
-	const char *name;
 	const struct ksz_chip_data *info;
 
 	struct mutex dev_mutex;		/* device access */
@@ -88,7 +87,6 @@ struct ksz_device {
 	int cpu_port;			/* port connected to CPU */
 	int phy_port_cnt;
 	phy_interface_t compat_interface;
-	u32 regs_size;
 	bool synclko_125;
 	bool synclko_disable;
 
@@ -100,7 +98,6 @@ struct ksz_device {
 	u16 mirror_rx;
 	u16 mirror_tx;
 	u32 features;			/* chip specific features */
-	u32 overrides;			/* chip functions set by user */
 	u16 host_mask;
 	u16 port_mask;
 };
-- 
2.33.0

