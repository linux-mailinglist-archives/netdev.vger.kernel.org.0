Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6246C31619E
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 09:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbhBJI6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 03:58:15 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:54966 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbhBJIya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 03:54:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1612947269; x=1644483269;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zfGVEDQiiHC3/VPTUtcWx0x1XAWj0O1UB0Hg/LuXxFw=;
  b=u1DFV4kmfsaOdmGf8fAHwuC2vtW24w2QjM6Wh+G3nXSmP4GGlrxwcv3S
   Iir8CHcoS5/asmU4t1o8A6EZr/zFRM9aBrOViCFZpi7dwhUFL+gd7P+eT
   IpoKUme8WOyDtT1kXDYHH4J9QdY7AeJeLUv6JivVcitYYxXE+FGssKTze
   H/9p3xpRMIt2DQ9qKRhv/vrmueurlbKcUbMXQe2BW46nb34C6u3yjfrNU
   jcGf4YvplezgsoC7EcpIdV5rqvENjhpV089D9kESgaHwv5XCgs8epUIr6
   qwoGaNFLxeogmL+lLeylU+a/1OSiTIsGPNpdA8scJEZSUZNAP+U+tCP15
   w==;
IronPort-SDR: v2wB1KMnDSf4pRNFseM/pbZSQG2p1sIR71tX0F9GhfjYh+ldJ4Ev71FlADZW+zwM0/7KkkulI0
 9YxDqERLN6FHAXAkFIOzDoJ3eBnqpkdLSL0na/OnyhAJBeIswzETprmYUA5RBXlfQOt/Io2Teg
 4yYgvUyYfWLysmCeG+CcpjBihmQ5x3o/tR/tbEAswk2p+KSWdQCd3F9Cu4sCJMHMMwUpcfJfcO
 NrQbJy2HuhmdW3Q1mIRDYj64mt09RUh0/0A9izbAuDkBtCcOSO3lEMEfYaSWzR0hWK6eAlYG4e
 oBM=
X-IronPort-AV: E=Sophos;i="5.81,167,1610434800"; 
   d="scan'208";a="103270930"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Feb 2021 01:53:13 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 10 Feb 2021 01:53:13 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 10 Feb 2021 01:53:11 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v14 4/4] arm64: dts: sparx5: Add Sparx5 serdes driver node
Date:   Wed, 10 Feb 2021 09:52:55 +0100
Message-ID: <20210210085255.2006824-5-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210210085255.2006824-1-steen.hegelund@microchip.com>
References: <20210210085255.2006824-1-steen.hegelund@microchip.com>
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
---
 arch/arm64/boot/dts/microchip/sparx5.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/boot/dts/microchip/sparx5.dtsi b/arch/arm64/boot/dts/microchip/sparx5.dtsi
index 380281f312d8..29c606194bc7 100644
--- a/arch/arm64/boot/dts/microchip/sparx5.dtsi
+++ b/arch/arm64/boot/dts/microchip/sparx5.dtsi
@@ -383,5 +383,13 @@ tmon0: tmon@610508110 {
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
2.30.0

