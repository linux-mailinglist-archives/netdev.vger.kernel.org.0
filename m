Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45DE3565415
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 13:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbiGDLqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 07:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233817AbiGDLqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 07:46:15 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264A211460;
        Mon,  4 Jul 2022 04:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656935173; x=1688471173;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JSc+EOCWP1Za2eDD5QEpO7crjBu7/hikVujXUumMRXs=;
  b=1BQOHNR33uZcAH/sOb+PY6cnESY0C4/SRsLLYdbg2j/443dMX1aC1Tki
   JNjgUvhBzEZFciuEjRUqG9VL5vnX7MGZ2i/GaX+etVcciRozufABNiueX
   f0t11bthllxda+QJy0nJEZTbjb+aA3yKL/xVeEn05iO2/AJ++ft2yI54o
   WacFe0ZqPME+RUllrqfMsf8nSE/frXeIt/ud8gi666AEiJGapctUdHE7s
   803N3YD6kKAmH0kB48KjI6mcvdn6G5iP40T1CDGOoGtLwmqF0KdZ5FHsY
   mMuHX3dj9918ILC2MBN0ddvHE8MJ3b7xohN/hnd9hS26FsjtdyCvEgxVc
   g==;
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="170950905"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Jul 2022 04:46:13 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 4 Jul 2022 04:46:12 -0700
Received: from wendy.microchip.com (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Mon, 4 Jul 2022 04:46:10 -0700
From:   Conor Dooley <conor.dooley@microchip.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Conor Dooley" <conor.dooley@microchip.com>
Subject: [net-next PATCH v2 3/5] net: macb: unify macb_config alignment style
Date:   Mon, 4 Jul 2022 12:45:10 +0100
Message-ID: <20220704114511.1892332-4-conor.dooley@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220704114511.1892332-1-conor.dooley@microchip.com>
References: <20220704114511.1892332-1-conor.dooley@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The various macb_config structs have taken different appraches to
alignment when broken over newlines. Pick one style and make them
match.

Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index d43bcf256b02..85a2e1ea7826 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4626,8 +4626,8 @@ static const struct macb_config at91sam9260_config = {
 };
 
 static const struct macb_config sama5d3macb_config = {
-	.caps = MACB_CAPS_SG_DISABLED
-	      | MACB_CAPS_USRIO_HAS_CLKEN | MACB_CAPS_USRIO_DEFAULT_IS_MII_GMII,
+	.caps = MACB_CAPS_SG_DISABLED |
+		MACB_CAPS_USRIO_HAS_CLKEN | MACB_CAPS_USRIO_DEFAULT_IS_MII_GMII,
 	.clk_init = macb_clk_init,
 	.init = macb_init,
 	.usrio = &macb_default_usrio,
@@ -4658,8 +4658,8 @@ static const struct macb_config sama5d29_config = {
 };
 
 static const struct macb_config sama5d3_config = {
-	.caps = MACB_CAPS_SG_DISABLED | MACB_CAPS_GIGABIT_MODE_AVAILABLE
-	      | MACB_CAPS_USRIO_DEFAULT_IS_MII_GMII | MACB_CAPS_JUMBO,
+	.caps = MACB_CAPS_SG_DISABLED | MACB_CAPS_GIGABIT_MODE_AVAILABLE |
+		MACB_CAPS_USRIO_DEFAULT_IS_MII_GMII | MACB_CAPS_JUMBO,
 	.dma_burst_length = 16,
 	.clk_init = macb_clk_init,
 	.init = macb_init,
@@ -4731,8 +4731,8 @@ static int init_reset_optional(struct platform_device *pdev)
 
 static const struct macb_config zynqmp_config = {
 	.caps = MACB_CAPS_GIGABIT_MODE_AVAILABLE |
-			MACB_CAPS_JUMBO |
-			MACB_CAPS_GEM_HAS_PTP | MACB_CAPS_BD_RD_PREFETCH,
+		MACB_CAPS_JUMBO |
+		MACB_CAPS_GEM_HAS_PTP | MACB_CAPS_BD_RD_PREFETCH,
 	.dma_burst_length = 16,
 	.clk_init = macb_clk_init,
 	.init = init_reset_optional,
@@ -4806,8 +4806,8 @@ MODULE_DEVICE_TABLE(of, macb_dt_ids);
 
 static const struct macb_config default_gem_config = {
 	.caps = MACB_CAPS_GIGABIT_MODE_AVAILABLE |
-			MACB_CAPS_JUMBO |
-			MACB_CAPS_GEM_HAS_PTP,
+		MACB_CAPS_JUMBO |
+		MACB_CAPS_GEM_HAS_PTP,
 	.dma_burst_length = 16,
 	.clk_init = macb_clk_init,
 	.init = macb_init,
-- 
2.36.1

