Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49066102F18
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 23:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbfKSWUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 17:20:02 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:34662 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727709AbfKSWUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 17:20:00 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id xAJMJrFY027255;
        Tue, 19 Nov 2019 16:19:53 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1574201993;
        bh=s4J4IgRw4lvHy5fWciYrXJnDBwlJ+T+Si7BcGvg/okc=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=dKXEsl2eATknER54kqlwIELZFHlBmMdvPQZPkZQzxbuKcA891hKiRVWOw1hmXBanI
         0CSn+gznh0KeFxoKl2lRWMfSlZGVsCXhaAF+z+gsCpos+HiC7+6YLAQm135tyK0LaF
         q4PVOBqGAAcumtqnqjihIiZMKw/vvqE77Vl++jV0=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xAJMJrW6044066
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 Nov 2019 16:19:53 -0600
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 19
 Nov 2019 16:19:53 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 19 Nov 2019 16:19:53 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id xAJMJqlo007700;
        Tue, 19 Nov 2019 16:19:52 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v7 net-next 12/13] ARM: dts: am571x-idk: enable for new cpsw switch dev driver
Date:   Wed, 20 Nov 2019 00:19:24 +0200
Message-ID: <20191119221925.28426-13-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191119221925.28426-1-grygorii.strashko@ti.com>
References: <20191119221925.28426-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add DT nodes for new cpsw switchdev driver for am571x-idk board for now to
enable testing of the new solution.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 arch/arm/boot/dts/am571x-idk.dts         | 27 ++++++++++++++++++++++++
 arch/arm/boot/dts/am572x-idk.dts         |  5 +++++
 arch/arm/boot/dts/am574x-idk.dts         |  5 +++++
 arch/arm/boot/dts/am57xx-idk-common.dtsi |  5 -----
 4 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/am571x-idk.dts b/arch/arm/boot/dts/am571x-idk.dts
index 0aaacea1d887..820ce3b60bb6 100644
--- a/arch/arm/boot/dts/am571x-idk.dts
+++ b/arch/arm/boot/dts/am571x-idk.dts
@@ -186,3 +186,30 @@
 	pinctrl-1 = <&mmc2_pins_hs>;
 	pinctrl-2 = <&mmc2_pins_ddr_rev20 &mmc2_iodelay_ddr_conf>;
 };
+
+&mac_sw {
+	pinctrl-names = "default", "sleep";
+	status = "okay";
+};
+
+&cpsw_port1 {
+	phy-handle = <&ethphy0_sw>;
+	phy-mode = "rgmii";
+	ti,dual-emac-pvid = <1>;
+};
+
+&cpsw_port2 {
+	phy-handle = <&ethphy1_sw>;
+	phy-mode = "rgmii";
+	ti,dual-emac-pvid = <2>;
+};
+
+&davinci_mdio_sw {
+	ethphy0_sw: ethernet-phy@0 {
+		reg = <0>;
+	};
+
+	ethphy1_sw: ethernet-phy@1 {
+		reg = <1>;
+	};
+};
diff --git a/arch/arm/boot/dts/am572x-idk.dts b/arch/arm/boot/dts/am572x-idk.dts
index ea1c119feaa5..c3d966904d64 100644
--- a/arch/arm/boot/dts/am572x-idk.dts
+++ b/arch/arm/boot/dts/am572x-idk.dts
@@ -27,3 +27,8 @@
 	pinctrl-1 = <&mmc2_pins_hs>;
 	pinctrl-2 = <&mmc2_pins_ddr_rev20>;
 };
+
+&mac {
+	status = "okay";
+	dual_emac;
+};
diff --git a/arch/arm/boot/dts/am574x-idk.dts b/arch/arm/boot/dts/am574x-idk.dts
index 7935d70874ce..fa0088025b2c 100644
--- a/arch/arm/boot/dts/am574x-idk.dts
+++ b/arch/arm/boot/dts/am574x-idk.dts
@@ -35,3 +35,8 @@
 	pinctrl-1 = <&mmc2_pins_default>;
 	pinctrl-2 = <&mmc2_pins_default>;
 };
+
+&mac {
+	status = "okay";
+	dual_emac;
+};
diff --git a/arch/arm/boot/dts/am57xx-idk-common.dtsi b/arch/arm/boot/dts/am57xx-idk-common.dtsi
index 423855a2a2d6..398721c7201c 100644
--- a/arch/arm/boot/dts/am57xx-idk-common.dtsi
+++ b/arch/arm/boot/dts/am57xx-idk-common.dtsi
@@ -363,11 +363,6 @@
 	ext-clk-src;
 };
 
-&mac {
-	status = "okay";
-	dual_emac;
-};
-
 &cpsw_emac0 {
 	phy-handle = <&ethphy0>;
 	phy-mode = "rgmii";
-- 
2.17.1

