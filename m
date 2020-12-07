Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56EC72D104B
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 13:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbgLGMQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 07:16:50 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:18900 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726938AbgLGMQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 07:16:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607343409; x=1638879409;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HYvqfDOJAQzsbDFrol1vkz2s/fsDFmkTjeSVK52uWyE=;
  b=sQQ/6V5UmCxWUs8xerHZBYe2cdqdH+kizcZj4QFvaWd22NNC90OJ/rWg
   /nNQ2SDxqVmYq7oyheQYdoemhl4qz3/vxo15qazh/iSxCgacIOBd2GB2O
   Hs3hWa3Rv/7Z/G6hOJpSVujIML7ss7j7vRpMTngnRTIKYAbvcYRei7wgb
   ROIKS/DH6M5dikiUxY2f1+7ODIVmDwr8elQL+KC276HLFqs1VwI1+pAzu
   sFmLYb3gzdJxWQmO+krbjW4Uu0qNUji/VTTfTb8el8UAci9VNAIrmL4oo
   CnnAEuQz98sOX/e5luGkILS1OjFDXCw9IwzomN4/Siq4TSsEGQB3i+4yC
   w==;
IronPort-SDR: GX22Jk/W9ls+/PSe3BN1lZltJwhuV/QObRXxDAmgW9hGTFN+/ehsB1iBDtzsZw6Py/uamd0u8i
 5sZdSWGjaqMm4zSRv9uL0TZsN3hX+wT/S/YzdArcmdcfGCRqsyNYQI62cs9fbhxgRq8Bnxkmph
 WL5oC0rdf7w3+Umj+pFI6pGjy1bkQqq4yRvRSZYFMJ4gygIU06DrXLO5S09KdcFxuKVI3ZnD7E
 Su4zcQtjjA/yZW7BquVyR4Y3FQYKKBiew6UNdxPQB6vYjIpBMMIYLNK+0LqnwqzCmN1u6pc6xe
 wFY=
X-IronPort-AV: E=Sophos;i="5.78,399,1599548400"; 
   d="scan'208";a="98863077"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Dec 2020 05:14:06 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 7 Dec 2020 05:14:05 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 7 Dec 2020 05:14:04 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v9 4/4] arm64: dts: sparx5: Add Sparx5 serdes driver node
Date:   Mon, 7 Dec 2020 13:13:45 +0100
Message-ID: <20201207121345.3818234-5-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201207121345.3818234-1-steen.hegelund@microchip.com>
References: <20201207121345.3818234-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Sparx5 serdes driver node, and enable it generally for all
reference boards.

Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 arch/arm64/boot/dts/microchip/sparx5.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/boot/dts/microchip/sparx5.dtsi b/arch/arm64/boot/dts/microchip/sparx5.dtsi
index 8e7724d413fb..797601a9d542 100644
--- a/arch/arm64/boot/dts/microchip/sparx5.dtsi
+++ b/arch/arm64/boot/dts/microchip/sparx5.dtsi
@@ -287,5 +287,13 @@ tmon0: tmon@610508110 {
 			#thermal-sensor-cells = <0>;
 			clocks = <&ahb_clk>;
 		};
+
+		serdes: serdes@10808000 {
+			compatible = "microchip,sparx5-serdes";
+			#phy-cells = <1>;
+			clocks = <&sys_clk>;
+			reg = <0x6 0x10808000 0x5d0000>;
+		};
+
 	};
 };
-- 
2.29.2

