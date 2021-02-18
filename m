Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B6931ED85
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 18:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234590AbhBRRns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 12:43:48 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:22530 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233460AbhBRQSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 11:18:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613665129; x=1645201129;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zfGVEDQiiHC3/VPTUtcWx0x1XAWj0O1UB0Hg/LuXxFw=;
  b=oHG1PNmX+mN71SkKwYmtaJNu8X96WS+6Pq2mroxgtAQ43xdAY9MxJItw
   m1enYvbCtkbaTfNHPJiXMnJTK1FtMMd8eswRO93ZEb15iQU6Fg5cmdA7P
   VU6kebQCFxd0LFC/VoQzYqS93n8DqkM9p1mTQTyeICz3USuFEd2hnI2zC
   JMGREisSib+sAEEEJUrAg+UuwJrTAAlAkvO4WUwZ0jD8oM2+QT3YiKa+G
   s3X2nnIvLCxNKUTFPN8bwqN9dLmmVoI+a/8QhP5ig06JrWUxKKnKxYrJb
   pm4DpAghyxZuHPNUEsdzhtcIxkCPuYiNJOMcc98PKGGyAizD7fXj9UH1a
   A==;
IronPort-SDR: AHr6HVDs1mlH8u+2I8GDh3J6NTUHS/HjQ5xn69hsSP95nf43oiOb3Rh5khWaSu3PmebyOCNBGf
 k8Hf3HWy8foRrhiBvm6+eCaRi7GLfWit8tEuKTO3x3S0bsJlJVrgXJIcxdsfWHkWLj/0N7kKZJ
 O3TlSYWUQSZ7qclOIF2G1Ll5gzGcDXi2TsJEFFeHGj3fvKKFOxwY4p3PGGNYwG8tNiKu2gfnQN
 C8x9UD9WwO7WSzN5miv3lntpjRZ8ulKtHbaz+XlaO35ifYHK9dLXnT4RtG29rTbjp3qXieUVfd
 GR0=
X-IronPort-AV: E=Sophos;i="5.81,187,1610434800"; 
   d="scan'208";a="110260125"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Feb 2021 09:15:14 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 18 Feb 2021 09:15:09 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 18 Feb 2021 09:15:07 -0700
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
Subject: [PATCH v15 4/4] arm64: dts: sparx5: Add Sparx5 serdes driver node
Date:   Thu, 18 Feb 2021 17:14:51 +0100
Message-ID: <20210218161451.3489955-5-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210218161451.3489955-1-steen.hegelund@microchip.com>
References: <20210218161451.3489955-1-steen.hegelund@microchip.com>
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

