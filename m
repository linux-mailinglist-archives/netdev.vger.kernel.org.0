Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3377D2CD3A4
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 11:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388923AbgLCKcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 05:32:16 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:9744 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387620AbgLCKcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 05:32:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1606991535; x=1638527535;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HYvqfDOJAQzsbDFrol1vkz2s/fsDFmkTjeSVK52uWyE=;
  b=gYQB+TRi0ltbNTLaqiEthV7jWmqT+zdcGBH2WE4zjL4sl5VSgDNJxeCb
   tcS8mQkveQqNVR9O/HpiDJpgF4DOwjdZmzDn9YVKIkmip0YRmHHJgVHlw
   akV+d3f6bgeOvOu4oiEqT36SrwUlaU7RtfKWgmgQgJ7goomUQuglC9vWN
   gL622iguclTNWCs1pn7jGJh6GCXc2vRk6tn9+AfE1nkvsoGrI1Sb8pzvv
   uVChzzDZyTSXWW+XFlDF0u8AdddLpI85iG78++e67JsD9F5Q6JmzjnlhI
   mw4LtUhuAmlS4iAsNnpC6DOeUF7rkB+oB8jxhXTegvpg6FSkRhI9YW1MY
   w==;
IronPort-SDR: /muQGuZvVJ63hGcW/XN7V9Ns/4opOGqoyFWx44j8GQ5bjpDGYv0GBXIXbTA9MDga9gxnkEGKS7
 Pf0nu2KZnigbVYugdNaWCOZp2Q+Gnyz96F/Oo3ZrHMl7N/Q2/KlcBFt2AD4KViCQaR8s9Vkoea
 J0oER7TpzDjfFjnusVjGc+SZAK9NBsyQc9codokD8HwcFqqIQYPvxpZ01PD+t+//siCJ3FaBBU
 qe3QeM3ITclO5K9dbVXU8CkOfSZ6XDJ3XWamD4uYl1ovbJTA3SOkNRY8Hf59ZWdmKRu1oLcZhz
 7F4=
X-IronPort-AV: E=Sophos;i="5.78,389,1599548400"; 
   d="scan'208";a="105989344"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Dec 2020 03:30:41 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 3 Dec 2020 03:30:41 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 3 Dec 2020 03:30:39 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 4/4] arm64: dts: sparx5: Add Sparx5 serdes driver node
Date:   Thu, 3 Dec 2020 11:30:15 +0100
Message-ID: <20201203103015.3735373-5-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201203103015.3735373-1-steen.hegelund@microchip.com>
References: <20201203103015.3735373-1-steen.hegelund@microchip.com>
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

