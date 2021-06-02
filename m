Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C23398F11
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 17:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbhFBPpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 11:45:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232363AbhFBPpG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 11:45:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 749A96140A;
        Wed,  2 Jun 2021 15:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622648602;
        bh=j4vbbGMmkpw6vv8LF4aIg9gX2V7O+Y4hZhiS1MaxEmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AB7FT6nD0+rEQCgHBe5Cc5z4DRLD3icjFOBiw6oUwpll2X2vUmNqYYA86Mis0nQok
         GUVdVQnl5wZ5UdKS1IFtwJmMOJbRm/TuUiIAkVHY4l1NYVVQAn1lpXU4WDZAJjZiIt
         Zj3vPyUaPqYduitPsdm0HQRG0b4aNL/BErsSx7TEcKpEaV42FMxSH3GWTMWGTilfOy
         EIHbJD4Wjmd3Kx44o49Q3rESdin3UZo0Het2NItM/PG8dKGKjyvqsS87KI7Dshih5t
         LrRX46kAZV/zWvGzK5YQGEZTeNLdZD56yEF4sDICfrD6yFi4PlcnBGdp103t4oyP/V
         easJ3WNVtDkDA==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1loT1b-006Xbn-D0; Wed, 02 Jun 2021 17:43:19 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Jakub Kicinski <kuba@kernel.org>, Keerthy <j-keerthy@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Mark Brown <broonie@kernel.org>, Nishanth Menon <nm@ti.com>,
        Rob Herring <robh+dt@kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Tero Kristo <kristo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-can@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-spi@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 04/12] dt-bindings: clock: update ti,sci-clk.yaml references
Date:   Wed,  2 Jun 2021 17:43:10 +0200
Message-Id: <0fae687366c09dfb510425b3c88316a727b27d6d.1622648507.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1622648507.git.mchehab+huawei@kernel.org>
References: <cover.1622648507.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changeset a7dbfa6f3877 ("dt-bindings: clock: Convert ti,sci-clk to json schema")
renamed: Documentation/devicetree/bindings/clock/ti,sci-clk.txt
to: Documentation/devicetree/bindings/clock/ti,sci-clk.yaml.

Update the cross-references accordingly.

Fixes: a7dbfa6f3877 ("dt-bindings: clock: Convert ti,sci-clk to json schema")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/devicetree/bindings/gpio/gpio-davinci.txt | 2 +-
 Documentation/devicetree/bindings/i2c/i2c-davinci.txt   | 2 +-
 Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt | 2 +-
 Documentation/devicetree/bindings/net/can/c_can.txt     | 2 +-
 Documentation/devicetree/bindings/spi/spi-davinci.txt   | 2 +-
 MAINTAINERS                                             | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/gpio/gpio-davinci.txt b/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
index 696ea46227d1..8ad4fd9aaffd 100644
--- a/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
@@ -32,7 +32,7 @@ Required Properties:
           Documentation/devicetree/bindings/clock/keystone-gate.txt
                             for 66AK2HK/66AK2L/66AK2E SoCs or,
 
-          Documentation/devicetree/bindings/clock/ti,sci-clk.txt
+          Documentation/devicetree/bindings/clock/ti,sci-clk.yaml
                             for 66AK2G SoCs
 
 - clock-names: Name should be "gpio";
diff --git a/Documentation/devicetree/bindings/i2c/i2c-davinci.txt b/Documentation/devicetree/bindings/i2c/i2c-davinci.txt
index b35ad748ed68..6590501c53d4 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-davinci.txt
+++ b/Documentation/devicetree/bindings/i2c/i2c-davinci.txt
@@ -8,7 +8,7 @@ Required properties:
 - reg : Offset and length of the register set for the device
 - clocks: I2C functional clock phandle.
 	  For 66AK2G this property should be set per binding,
-	  Documentation/devicetree/bindings/clock/ti,sci-clk.txt
+	  Documentation/devicetree/bindings/clock/ti,sci-clk.yaml
 
 SoC-specific Required Properties:
 
diff --git a/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt b/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
index 0663e7648ef9..57d077c0b7c1 100644
--- a/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
+++ b/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
@@ -28,7 +28,7 @@ The following are mandatory properties for 66AK2G SoCs only:
 		Documentation/devicetree/bindings/soc/ti/sci-pm-domain.yaml
 - clocks:	Must contain an entry for each entry in clock-names. Should
 		be defined as per the he appropriate clock bindings consumer
-		usage in Documentation/devicetree/bindings/clock/ti,sci-clk.txt
+		usage in Documentation/devicetree/bindings/clock/ti,sci-clk.yaml
 - clock-names:	Shall be "fck" for the functional clock,
 		and "mmchsdb_fck" for the debounce clock.
 
diff --git a/Documentation/devicetree/bindings/net/can/c_can.txt b/Documentation/devicetree/bindings/net/can/c_can.txt
index febd2cc1ca14..366479806acb 100644
--- a/Documentation/devicetree/bindings/net/can/c_can.txt
+++ b/Documentation/devicetree/bindings/net/can/c_can.txt
@@ -22,7 +22,7 @@ The following are mandatory properties for Keystone 2 66AK2G SoCs only:
 			  Documentation/devicetree/bindings/soc/ti/sci-pm-domain.yaml
 - clocks		: CAN functional clock phandle. This property is as per the
 			  binding,
-			  Documentation/devicetree/bindings/clock/ti,sci-clk.txt
+			  Documentation/devicetree/bindings/clock/ti,sci-clk.yaml
 
 Optional properties:
 - syscon-raminit	: Handle to system control region that contains the
diff --git a/Documentation/devicetree/bindings/spi/spi-davinci.txt b/Documentation/devicetree/bindings/spi/spi-davinci.txt
index e2198a389484..200c7fc7b089 100644
--- a/Documentation/devicetree/bindings/spi/spi-davinci.txt
+++ b/Documentation/devicetree/bindings/spi/spi-davinci.txt
@@ -25,7 +25,7 @@ Required properties:
 - interrupts: interrupt number mapped to CPU.
 - clocks: spi clk phandle
           For 66AK2G this property should be set per binding,
-          Documentation/devicetree/bindings/clock/ti,sci-clk.txt
+          Documentation/devicetree/bindings/clock/ti,sci-clk.yaml
 
 SoC-specific Required Properties:
 
diff --git a/MAINTAINERS b/MAINTAINERS
index 0f0a01b54c1b..790eff88b53e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18193,7 +18193,7 @@ L:	linux-arm-kernel@lists.infradead.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/arm/keystone/ti,k3-sci-common.yaml
 F:	Documentation/devicetree/bindings/arm/keystone/ti,sci.txt
-F:	Documentation/devicetree/bindings/clock/ti,sci-clk.txt
+F:	Documentation/devicetree/bindings/clock/ti,sci-clk.yaml
 F:	Documentation/devicetree/bindings/interrupt-controller/ti,sci-inta.yaml
 F:	Documentation/devicetree/bindings/interrupt-controller/ti,sci-intr.yaml
 F:	Documentation/devicetree/bindings/reset/ti,sci-reset.txt
-- 
2.31.1

