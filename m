Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6485C2E91B4
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 09:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbhADIY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 03:24:29 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:54806 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbhADIY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 03:24:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1609748668; x=1641284668;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J5rFT38u51E8wge0MWRYiUNwuAT8ed/TsqmvLNI7Yzc=;
  b=pNYUDfOXpsbYyoR23Keb0nVs4tU+i9Wcw67v6LT08JI7dkucFUa40b7q
   qAKJYXu1+HiEFWEIFiGiQW7iVMHcIrdNVNP6VdKb6sNX2vHd4kSSXM6he
   pMB+FwTSSSXmDCYFQttQrDfMaD4WHRiLsVMwRo7A7pcqDgldJu+nbiUz1
   v7CcYfV81o3noWytJKTBD1vO78vnb2qClMRmZLzguOkUQPQN6atLxxkaD
   uulE484tARoM3NYHGNVlL2svo7FRrWcVfyxC0+cpbtmDkMpt6UbPacwH5
   SOcy3Fz1AvzN81T6YilKB4Lr0UIuvOuuMLrAKZ3090C+ei5GIpRw/3gjn
   Q==;
IronPort-SDR: VVi7bmygNGYLMVzVOzZQiiuUbUWrFwZ7nJwb4yDCH7TF8pw+rLy6onF0aRsTiHF3oMU2RRIOiI
 8ubNazd1yheIlnsR4Ge75tTALt5BlZDgj2cAsHhzJSIpmdKuHhB4AClddsAv9rCUIl9/Bw2dBA
 XjnRQNxqSzib2wcuFPAnTwPj7wGOPhwTrFljOGsU9vgz+NEVKQv+j4jYJCOybASCLh+94QxCVA
 wlVXCa9hCqwYh9gdLL7JaGP+7MG2A4b9k411SWdzjRcR+/W4NylGGdpLkdY9PWIwmBLKEwbi+8
 IIg=
X-IronPort-AV: E=Sophos;i="5.78,473,1599548400"; 
   d="scan'208";a="109665954"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Jan 2021 01:23:19 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 4 Jan 2021 01:22:38 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 4 Jan 2021 01:22:36 -0700
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
Subject: [PATCH v11 4/4] arm64: dts: sparx5: Add Sparx5 serdes driver node
Date:   Mon, 4 Jan 2021 09:22:18 +0100
Message-ID: <20210104082218.1389450-5-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210104082218.1389450-1-steen.hegelund@microchip.com>
References: <20210104082218.1389450-1-steen.hegelund@microchip.com>
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
2.29.2

