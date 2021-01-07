Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECF52ECC9C
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 10:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbhAGJVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 04:21:00 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:7742 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbhAGJU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 04:20:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610011258; x=1641547258;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J5rFT38u51E8wge0MWRYiUNwuAT8ed/TsqmvLNI7Yzc=;
  b=HJ071Uaq/wiKKEhCz2cPoi3y5RqTtvzmMHU3ehvjNUCv5+OhZmnMi4jo
   bKjpVoPfbDVWff4NPiGTbPE3Bg0uj1vs9U9ZtG0BlI3XDQNG+QBuxRfII
   K23p1f51RlvTZ2O7fhJF/TmBMh9paogJU+LzIPnn0NzKITxdxgIImEkhn
   kp49TpPSquz/HmUO3zqdcnY5JuXSS8bGotRPXiO4h96lNl041R1RE90fR
   dYE1RmfspRK+WI2PKIzBaYjhy48ueXR2xrm7pFuLRwIEI1ZPsmAafP+zr
   NafidOqSnQmqdfoE6VVQDkTmI81GEsloXU+TglV4c1Al0qbz6dwDmw2WB
   g==;
IronPort-SDR: /+l1+ZXUw64BxIU+sOXnTHuiJAJ3rkV5HYwY4YyGCmQu4A+WUQp29rVe48DfZ+309UjoXDt+ly
 PnL0yXHSW+KVIC+buV20U95U+pnOFle5fVPrfSOGuEVwRqDbTFpX/HoHoiEa6m5rhSNd7L0dar
 eRzdqpE3RduTB/9DIFszGbt4FLcaAaHtmge6y/nHeS+Zghg1oVu8preJLYIOanLt4PmYtffQo9
 1ZgPUSiYgZzbNGH+BLf2v0YLe0i7nCv+QweTvm8XC8YGM1PkMGJ/bDD7EvBKoLVcmcE2S41u8l
 /ww=
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="105102765"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Jan 2021 02:19:41 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 7 Jan 2021 02:19:41 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 7 Jan 2021 02:19:39 -0700
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
Subject: [PATCH v12 4/4] arm64: dts: sparx5: Add Sparx5 serdes driver node
Date:   Thu, 7 Jan 2021 10:19:24 +0100
Message-ID: <20210107091924.1569575-5-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107091924.1569575-1-steen.hegelund@microchip.com>
References: <20210107091924.1569575-1-steen.hegelund@microchip.com>
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

