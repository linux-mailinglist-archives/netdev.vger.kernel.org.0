Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA243D397A
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 13:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234422AbhGWKsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 06:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231703AbhGWKsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 06:48:21 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A508C061575;
        Fri, 23 Jul 2021 04:28:55 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id a14so2909246plh.5;
        Fri, 23 Jul 2021 04:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q15Uy0/mb1YlRCrH+e/XqE5QNFNkxOvnubki+n6iu+E=;
        b=RnqFa0767hWlEZszBAiUJaUqeZwiK7eFd25wH2OoyXg1AU1j9Y5aH/LhNJ4AgQ+/nb
         nt0evg1n3olIYPaR9JCYP+zNhmW2sOIOEfRw9nlvkCxaStC6j2cUhzB7v2wKuO1j/J8q
         DL9XN6e+auAgW7clpW6ZhcaezeMWALQ0hklhKmAYHbXwiSR/En6cLZDv1sISi2bJmMeB
         l16E6nfygV7pK6/g/MogY0CWvy8vEx8dy0R5Hi2nBP2m79xtc5IGjrZMk17orFRgImLE
         njZUVxA/t0Re2hUPe2XjBJ414O2YVnh+Je0R+nLqa/fQSIHwKJv2xb7b+ZYWBF6oWFAF
         aqpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q15Uy0/mb1YlRCrH+e/XqE5QNFNkxOvnubki+n6iu+E=;
        b=cKxc2NzRmXWUa3FS2gQxh9pbB93q8kvmMwmZDR5iiuOIyzBV+WvwUkKFnXP04D97+3
         JKH2F355WabA0UB7/UQ18euxTe9hLo5hkqefqVXJ0N9QbPzbB1epvOGR2xoMgUtf56ES
         a22HIlepTFCoLY12/KBv2hGb9dUDEntfZfeZBUJn7s3ucJlA9cBPfq40ZGf47Y+63J4J
         MUqrZAbTfyPguV/13Ds3eqbOqz/qCYfHrm8FSGxETwGcL3e/LI2PWm3NSEplAOBut0P2
         9QlWSlXJEc7ShVqrHwg9+Yt55zZdRru8AUaBusdZzTZzduGV34KyeTPRRvfaDD/uBOxx
         TgiQ==
X-Gm-Message-State: AOAM531bfI9XxjiU4qQN1tkp0lubTbpjnef5Dhb+7CQ4CYFScMMOoruf
        3B3vhQTxUSGAigV1PsRwFas=
X-Google-Smtp-Source: ABdhPJxNfP3fWOf2uAaWb8HhDLAgMVnpJNmVDSstKTmd+aoqqeMKAsBM2j83+Gva9R0WAImDeNWDIg==
X-Received: by 2002:aa7:800b:0:b029:330:455f:57a8 with SMTP id j11-20020aa7800b0000b0290330455f57a8mr3988625pfi.7.1627039735030;
        Fri, 23 Jul 2021 04:28:55 -0700 (PDT)
Received: from localhost.localdomain ([2804:14c:485:504a:d157:8bd3:ec42:18c3])
        by smtp.gmail.com with ESMTPSA id o9sm35733184pfh.217.2021.07.23.04.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 04:28:54 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     davem@davemloft.net
Cc:     shawnguo@kernel.org, linux-arm-kernel@lists.infradead.org,
        qiangqing.zhang@nxp.com, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH net-next] ARM: dts: imx6qdl: Remove unnecessary mdio #address-cells/#size-cells
Date:   Fri, 23 Jul 2021 08:28:35 -0300
Message-Id: <20210723112835.31743-1-festevam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit dabb5db17c06 ("ARM: dts: imx6qdl: move phy properties into
phy device node") the following W=1 dtc warnings are seen:

arch/arm/boot/dts/imx6qdl-aristainetos2.dtsi:323.7-334.4: Warning (avoid_unnecessary_addr_size): /soc/bus@2100000/ethernet@2188000/mdio: unnecessary #address-cells/#size-cells without "ranges" or child "reg" property

Remove the unnecessary mdio #address-cells/#size-cells to fix it.

Fixes: dabb5db17c06 ("ARM: dts: imx6qdl: move phy properties into phy device node")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
Hi,

I am targetting net-next because this is where the offending patch was
applied.

 arch/arm/boot/dts/imx6q-novena.dts           | 3 ---
 arch/arm/boot/dts/imx6qdl-aristainetos2.dtsi | 3 ---
 arch/arm/boot/dts/imx6qdl-nit6xlite.dtsi     | 3 ---
 arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi | 3 ---
 arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi    | 3 ---
 arch/arm/boot/dts/imx6qdl-sabrelite.dtsi     | 3 ---
 6 files changed, 18 deletions(-)

diff --git a/arch/arm/boot/dts/imx6q-novena.dts b/arch/arm/boot/dts/imx6q-novena.dts
index 225cf6b7a7a4..909adaf4e544 100644
--- a/arch/arm/boot/dts/imx6q-novena.dts
+++ b/arch/arm/boot/dts/imx6q-novena.dts
@@ -227,9 +227,6 @@ &fec {
 	status = "okay";
 
 	mdio {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
 		ethphy: ethernet-phy {
 			compatible = "ethernet-phy-ieee802.3-c22";
 			rxc-skew-ps = <3000>;
diff --git a/arch/arm/boot/dts/imx6qdl-aristainetos2.dtsi b/arch/arm/boot/dts/imx6qdl-aristainetos2.dtsi
index 563bf9d44fe0..3e13be35b526 100644
--- a/arch/arm/boot/dts/imx6qdl-aristainetos2.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-aristainetos2.dtsi
@@ -321,9 +321,6 @@ &fec {
 	status = "okay";
 
 	mdio {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
 		ethphy: ethernet-phy {
 			compatible = "ethernet-phy-ieee802.3-c22";
 			txd0-skew-ps = <0>;
diff --git a/arch/arm/boot/dts/imx6qdl-nit6xlite.dtsi b/arch/arm/boot/dts/imx6qdl-nit6xlite.dtsi
index ac34709e9741..492eaa4094ff 100644
--- a/arch/arm/boot/dts/imx6qdl-nit6xlite.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-nit6xlite.dtsi
@@ -198,9 +198,6 @@ &fec {
 	status = "okay";
 
 	mdio {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
 		ethphy: ethernet-phy {
 			compatible = "ethernet-phy-ieee802.3-c22";
 			txen-skew-ps = <0>;
diff --git a/arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi b/arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi
index c96f4d7e1e0d..4e5682211f42 100644
--- a/arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi
@@ -340,9 +340,6 @@ &fec {
 	status = "okay";
 
 	mdio {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
 		ethphy: ethernet-phy {
 			compatible = "ethernet-phy-ieee802.3-c22";
 			txen-skew-ps = <0>;
diff --git a/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi b/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi
index 49da30d7510c..c29fbfd87172 100644
--- a/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi
@@ -273,9 +273,6 @@ &fec {
 	status = "okay";
 
 	mdio {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
 		ethphy: ethernet-phy {
 			compatible = "ethernet-phy-ieee802.3-c22";
 			txen-skew-ps = <0>;
diff --git a/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi b/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
index eb9a0b104f1c..a6f2d6db521f 100644
--- a/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
@@ -329,9 +329,6 @@ &fec {
 	status = "okay";
 
 	mdio {
-		#address-cells = <1>;
-		#size-cells = <0>;
-
 		ethphy: ethernet-phy {
 			compatible = "ethernet-phy-ieee802.3-c22";
 			txen-skew-ps = <0>;
-- 
2.25.1

