Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 203285B38F8
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 15:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbiIIN0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 09:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbiIIN0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 09:26:31 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F4018138E61;
        Fri,  9 Sep 2022 06:26:29 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.93,303,1654527600"; 
   d="scan'208";a="132266893"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 09 Sep 2022 22:26:28 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 1002743BD5A1;
        Fri,  9 Sep 2022 22:26:28 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, geert+renesas@glider.be
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH 5/5] arm64: dts: renesas: r8a779f0: spider: Enable Ethernet Switch
Date:   Fri,  9 Sep 2022 22:26:14 +0900
Message-Id: <20220909132614.1967276-6-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220909132614.1967276-1-yoshihiro.shimoda.uh@renesas.com>
References: <20220909132614.1967276-1-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable Ethernet Switch for R-Car S4-8 (r8a779f0).

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 .../dts/renesas/r8a779f0-spider-ethernet.dtsi | 44 +++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r8a779f0-spider-ethernet.dtsi b/arch/arm64/boot/dts/renesas/r8a779f0-spider-ethernet.dtsi
index 15e8d1ebf575..db3b6e51e2b6 100644
--- a/arch/arm64/boot/dts/renesas/r8a779f0-spider-ethernet.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a779f0-spider-ethernet.dtsi
@@ -13,3 +13,47 @@ eeprom@52 {
 		pagesize = <8>;
 	};
 };
+
+&rswitch {
+	status = "okay";
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	ports {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		port@0 {
+			reg = <0>;
+			phy-handle = <&etha0>;
+			phy-mode = "sgmii";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			etha0: ethernet-phy@0 {
+				reg = <1>;
+				compatible = "ethernet-phy-ieee802.3-c45";
+			};
+		};
+		port@1 {
+			reg = <1>;
+			phy-handle = <&etha1>;
+			phy-mode = "sgmii";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			etha1: ethernet-phy@1 {
+				reg = <2>;
+				compatible = "ethernet-phy-ieee802.3-c45";
+			};
+		};
+		port@2 {
+			reg = <2>;
+			phy-handle = <&etha2>;
+			phy-mode = "sgmii";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			etha2: ethernet-phy@2 {
+				reg = <3>;
+				compatible = "ethernet-phy-ieee802.3-c45";
+			};
+		};
+	};
+};
-- 
2.25.1

