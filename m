Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE73F183667
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 17:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgCLQnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 12:43:41 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:48701 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgCLQnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 12:43:40 -0400
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 4348722FED;
        Thu, 12 Mar 2020 17:43:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1584031417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nNP3lSoIAR4J+LcL2f11lgwwteJGEBXUJ4n5s/d7hVE=;
        b=M4ny3w7vchdM0zTN195z96B/vOrPFj5VXMrcbztrAIjQ12Jr4qybqRQWEnDD92psB6HDfC
        S+jEGaJReS69pVfOE4plsp8V1kJ6XNbWVg128Jtw5uQA9YjLw/rlbrbZzZnLyvY525uQ/J
        xudDKssEhFFg0x9tTG4PlWnrSEpI8H4=
From:   Michael Walle <michael@walle.cc>
To:     linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Rob Herring <robh+dt@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH 2/2] arm64: dts: ls1028a: disable the felix switch by default
Date:   Thu, 12 Mar 2020 17:43:20 +0100
Message-Id: <20200312164320.22349-2-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200312164320.22349-1-michael@walle.cc>
References: <20200312164320.22349-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
X-Spam-Level: ******
X-Rspamd-Server: web
X-Spam-Status: Yes, score=6.40
X-Spam-Score: 6.40
X-Rspamd-Queue-Id: 4348722FED
X-Spamd-Result: default: False [6.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[dt];
         MIME_GOOD(-0.10)[text/plain];
         BROKEN_CONTENT_TYPE(1.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         DKIM_SIGNED(0.00)[];
         DBL_PROHIBIT(0.00)[0.0.0.0:email];
         RCPT_COUNT_TWELVE(0.00)[14];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:31334, ipnet:2a02:810c:8000::/33, country:DE];
         FREEMAIL_CC(0.00)[davemloft.net,gmail.com,lunn.ch,nxp.com,kernel.org,walle.cc];
         SUSPICIOUS_RECIPS(1.50)[]
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Disable the felix switch by default and enable it per board which are
actually using it.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 .../boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts  | 4 ++++
 .../boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts      | 4 ++++
 arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts             | 4 ++++
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi                | 3 ++-
 4 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts
index a83a176cf18a..d4ca12b140b4 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts
@@ -63,6 +63,10 @@
 	};
 };
 
+&mscc_felix {
+	status = "okay";
+};
+
 &mscc_felix_port0 {
 	label = "swp0";
 	managed = "in-band-status";
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts
index 0a34ff682027..901b5b161def 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts
@@ -48,6 +48,10 @@
 	status = "okay";
 };
 
+&mscc_felix {
+	status = "okay";
+};
+
 &mscc_felix_port0 {
 	label = "gbe0";
 	phy-handle = <&phy0>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
index 0d27b5667b8c..8294d364112e 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
@@ -228,6 +228,10 @@
 	status = "okay";
 };
 
+&mscc_felix {
+	status = "okay";
+};
+
 &mscc_felix_port0 {
 	label = "swp0";
 	managed = "in-band-status";
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
index c09279379723..70a10268bb83 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
@@ -933,10 +933,11 @@
 				fsl,extts-fifo;
 			};
 
-			ethernet-switch@0,5 {
+			mscc_felix: ethernet-switch@0,5 {
 				reg = <0x000500 0 0 0 0>;
 				/* IEP INT_B */
 				interrupts = <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>;
+				status = "disabled";
 
 				ports {
 					#address-cells = <1>;
-- 
2.20.1

