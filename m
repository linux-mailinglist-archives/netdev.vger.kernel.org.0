Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEB751E8C1
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 19:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239481AbiEGRJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 13:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446666AbiEGRIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 13:08:45 -0400
Received: from mxout4.routing.net (mxout4.routing.net [IPv6:2a03:2900:1:a::9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810F31B781;
        Sat,  7 May 2022 10:04:58 -0700 (PDT)
Received: from mxbox4.masterlogin.de (unknown [192.168.10.79])
        by mxout4.routing.net (Postfix) with ESMTP id 588691004CD;
        Sat,  7 May 2022 17:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
        s=20200217; t=1651943096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ztXbd80xozaI47bUw9fR7hUTHlVlOWP8CEepv0mY5ag=;
        b=hjvBnIMgtNv5Y0TtmliGNJFJJyvdDsncrvJxS5hh75rBbCmxjMTKkmF5kSJ/IZJIhIVBxu
        KAcTaTa1v55y4ouhZLrtwSouLWL7hwn4+7s6xDyx6APX46UEv5ziI2TFDLH7xmHpa0A80f
        uyeMuJIlnOxrQ/cPrv/C1mg3oJMlAzE=
Received: from localhost.localdomain (fttx-pool-80.245.74.2.bambit.de [80.245.74.2])
        by mxbox4.masterlogin.de (Postfix) with ESMTPSA id 415B1800AB;
        Sat,  7 May 2022 17:04:55 +0000 (UTC)
From:   Frank Wunderlich <linux@fw-web.de>
To:     linux-rockchip@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Greg Ungerer <gerg@kernel.org>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>
Subject: [PATCH v3 6/6] arm64: dts: rockchip: Add mt7531 dsa node to BPI-R2-Pro board
Date:   Sat,  7 May 2022 19:04:40 +0200
Message-Id: <20220507170440.64005-7-linux@fw-web.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220507170440.64005-1-linux@fw-web.de>
References: <20220507170440.64005-1-linux@fw-web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mail-ID: 744a8d14-3188-4f88-af20-b041c28fd74e
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frank Wunderlich <frank-w@public-files.de>

Add Device Tree node for mt7531 switch connected to gmac0.

Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
---
v2:
- drop status=disabled
---
 .../boot/dts/rockchip/rk3568-bpi-r2-pro.dts   | 48 +++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts b/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts
index 235cb7405d9b..e517712f5d8d 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts
@@ -454,6 +454,54 @@ &i2c5 {
 	status = "disabled";
 };
 
+&mdio0 {
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	switch@0 {
+		compatible = "mediatek,mt7531";
+		reg = <0>;
+
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			port@1 {
+				reg = <1>;
+				label = "lan0";
+			};
+
+			port@2 {
+				reg = <2>;
+				label = "lan1";
+			};
+
+			port@3 {
+				reg = <3>;
+				label = "lan2";
+			};
+
+			port@4 {
+				reg = <4>;
+				label = "lan3";
+			};
+
+			port@5 {
+				reg = <5>;
+				label = "cpu";
+				ethernet = <&gmac0>;
+				phy-mode = "rgmii";
+
+				fixed-link {
+					speed = <1000>;
+					full-duplex;
+					pause;
+				};
+			};
+		};
+	};
+};
+
 &mdio1 {
 	rgmii_phy1: ethernet-phy@0 {
 		compatible = "ethernet-phy-ieee802.3-c22";
-- 
2.25.1

