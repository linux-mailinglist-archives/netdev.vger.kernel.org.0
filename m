Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1CC398F16
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 17:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbhFBPpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 11:45:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232386AbhFBPpH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 11:45:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C46961407;
        Wed,  2 Jun 2021 15:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622648602;
        bh=iKcQzKGavAO+tUsWRrSi6qHjzKizU8evibF1SxOb9H0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HIGV6dB5zx3Y3Usn3rjx0KUu9SXcqy/JHAti2KG+DZ4laEu2N2zvLhDUuNbM/xZCA
         ZhGStGkbjQK4EOUUj0wRk0PlxqSlNvg2sJ2LxhL7fbzQlQu1Yuj/gr1/VIhEIelbA7
         WqWsfVSfbb6MsUtgN2o7NH8BuoJofiDLfNthwtKYi/Ki2si6pYHHWEN+6AvYWckFub
         QwSIOgc/wuP8DsFt/2riB4dVKX5SPMTPMJ5GDTXnXc60IU6LTHvxTNNLy+goayAHFx
         zIuL4IRu6tl4XSA6I+SNNSA/zx24QvYTJiUG7O/GhKSDNAIZ5xObx2HuY7Uws7XbDK
         kdgH9/IFk5gwQ==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1loT1b-006Xbj-Bj; Wed, 02 Jun 2021 17:43:19 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Nishanth Menon <nm@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Roger Quadros <rogerq@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Tero Kristo <kristo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        devicetree@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 03/12] dt-bindings: soc: ti: update sci-pm-domain.yaml references
Date:   Wed,  2 Jun 2021 17:43:09 +0200
Message-Id: <c03020ff281054c3bd2527c510659e05fec6f181.1622648507.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1622648507.git.mchehab+huawei@kernel.org>
References: <cover.1622648507.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changeset fda55c7256fe ("dt-bindings: soc: ti: Convert ti,sci-pm-domain to json schema")
renamed: Documentation/devicetree/bindings/soc/ti/sci-pm-domain.txt
to: Documentation/devicetree/bindings/soc/ti/sci-pm-domain.yaml.

Update the cross-references accordingly.

Fixes: fda55c7256fe ("dt-bindings: soc: ti: Convert ti,sci-pm-domain to json schema")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/devicetree/bindings/dma/ti-edma.txt             | 4 ++--
 Documentation/devicetree/bindings/i2c/i2c-davinci.txt         | 2 +-
 Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt       | 2 +-
 Documentation/devicetree/bindings/net/can/c_can.txt           | 2 +-
 .../devicetree/bindings/remoteproc/ti,keystone-rproc.txt      | 2 +-
 Documentation/devicetree/bindings/usb/ti,j721e-usb.yaml       | 2 +-
 Documentation/devicetree/bindings/usb/ti,keystone-dwc3.yaml   | 2 +-
 MAINTAINERS                                                   | 2 +-
 8 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/dma/ti-edma.txt b/Documentation/devicetree/bindings/dma/ti-edma.txt
index 29fcd37082e8..f719e1612b0a 100644
--- a/Documentation/devicetree/bindings/dma/ti-edma.txt
+++ b/Documentation/devicetree/bindings/dma/ti-edma.txt
@@ -33,7 +33,7 @@ The following are mandatory properties for 66AK2G SoCs only:
 - power-domains:Should contain a phandle to a PM domain provider node
 		and an args specifier containing the device id
 		value. This property is as per the binding,
-		Documentation/devicetree/bindings/soc/ti/sci-pm-domain.txt
+		Documentation/devicetree/bindings/soc/ti/sci-pm-domain.yaml
 
 Optional properties:
 -------------------
@@ -70,7 +70,7 @@ The following are mandatory properties for 66AK2G SoCs only:
 - power-domains:Should contain a phandle to a PM domain provider node
 		and an args specifier containing the device id
 		value. This property is as per the binding,
-		Documentation/devicetree/bindings/soc/ti/sci-pm-domain.txt
+		Documentation/devicetree/bindings/soc/ti/sci-pm-domain.yaml
 
 Optional properties:
 -------------------
diff --git a/Documentation/devicetree/bindings/i2c/i2c-davinci.txt b/Documentation/devicetree/bindings/i2c/i2c-davinci.txt
index b745f3706120..b35ad748ed68 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-davinci.txt
+++ b/Documentation/devicetree/bindings/i2c/i2c-davinci.txt
@@ -17,7 +17,7 @@ The following are mandatory properties for Keystone 2 66AK2G SoCs only:
 - power-domains:	Should contain a phandle to a PM domain provider node
 			and an args specifier containing the I2C device id
 			value. This property is as per the binding,
-			Documentation/devicetree/bindings/soc/ti/sci-pm-domain.txt
+			Documentation/devicetree/bindings/soc/ti/sci-pm-domain.yaml
 
 Recommended properties :
 - interrupts : standard interrupt property.
diff --git a/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt b/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
index 4a9145ef15d6..0663e7648ef9 100644
--- a/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
+++ b/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
@@ -25,7 +25,7 @@ The following are mandatory properties for 66AK2G SoCs only:
 - power-domains:Should contain a phandle to a PM domain provider node
 		and an args specifier containing the MMC device id
 		value. This property is as per the binding,
-		Documentation/devicetree/bindings/soc/ti/sci-pm-domain.txt
+		Documentation/devicetree/bindings/soc/ti/sci-pm-domain.yaml
 - clocks:	Must contain an entry for each entry in clock-names. Should
 		be defined as per the he appropriate clock bindings consumer
 		usage in Documentation/devicetree/bindings/clock/ti,sci-clk.txt
diff --git a/Documentation/devicetree/bindings/net/can/c_can.txt b/Documentation/devicetree/bindings/net/can/c_can.txt
index 2d504256b0d8..febd2cc1ca14 100644
--- a/Documentation/devicetree/bindings/net/can/c_can.txt
+++ b/Documentation/devicetree/bindings/net/can/c_can.txt
@@ -19,7 +19,7 @@ The following are mandatory properties for Keystone 2 66AK2G SoCs only:
 - power-domains		: Should contain a phandle to a PM domain provider node
 			  and an args specifier containing the DCAN device id
 			  value. This property is as per the binding,
-			  Documentation/devicetree/bindings/soc/ti/sci-pm-domain.txt
+			  Documentation/devicetree/bindings/soc/ti/sci-pm-domain.yaml
 - clocks		: CAN functional clock phandle. This property is as per the
 			  binding,
 			  Documentation/devicetree/bindings/clock/ti,sci-clk.txt
diff --git a/Documentation/devicetree/bindings/remoteproc/ti,keystone-rproc.txt b/Documentation/devicetree/bindings/remoteproc/ti,keystone-rproc.txt
index 461dc1d8d570..e99123c1445e 100644
--- a/Documentation/devicetree/bindings/remoteproc/ti,keystone-rproc.txt
+++ b/Documentation/devicetree/bindings/remoteproc/ti,keystone-rproc.txt
@@ -82,7 +82,7 @@ The following are mandatory properties for Keystone 2 66AK2G SoCs only:
 - power-domains:	Should contain a phandle to a PM domain provider node
 			and an args specifier containing the DSP device id
 			value. This property is as per the binding,
-			Documentation/devicetree/bindings/soc/ti/sci-pm-domain.txt
+			Documentation/devicetree/bindings/soc/ti/sci-pm-domain.yaml
 
 Optional properties:
 --------------------
diff --git a/Documentation/devicetree/bindings/usb/ti,j721e-usb.yaml b/Documentation/devicetree/bindings/usb/ti,j721e-usb.yaml
index 7ec87a783c5c..a634774c537c 100644
--- a/Documentation/devicetree/bindings/usb/ti,j721e-usb.yaml
+++ b/Documentation/devicetree/bindings/usb/ti,j721e-usb.yaml
@@ -27,7 +27,7 @@ properties:
     description:
       PM domain provider node and an args specifier containing
       the USB device id value. See,
-      Documentation/devicetree/bindings/soc/ti/sci-pm-domain.txt
+      Documentation/devicetree/bindings/soc/ti/sci-pm-domain.yaml
     maxItems: 1
 
   clocks:
diff --git a/Documentation/devicetree/bindings/usb/ti,keystone-dwc3.yaml b/Documentation/devicetree/bindings/usb/ti,keystone-dwc3.yaml
index 9a068d3bc73b..f6e91a5fd8fe 100644
--- a/Documentation/devicetree/bindings/usb/ti,keystone-dwc3.yaml
+++ b/Documentation/devicetree/bindings/usb/ti,keystone-dwc3.yaml
@@ -47,7 +47,7 @@ properties:
     description: Should contain a phandle to a PM domain provider node
       and an args specifier containing the USB device id
       value. This property is as per the binding,
-      Documentation/devicetree/bindings/soc/ti/sci-pm-domain.txt
+      Documentation/devicetree/bindings/soc/ti/sci-pm-domain.yaml
 
   phys:
     maxItems: 1
diff --git a/MAINTAINERS b/MAINTAINERS
index a2517768404a..0f0a01b54c1b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18197,7 +18197,7 @@ F:	Documentation/devicetree/bindings/clock/ti,sci-clk.txt
 F:	Documentation/devicetree/bindings/interrupt-controller/ti,sci-inta.yaml
 F:	Documentation/devicetree/bindings/interrupt-controller/ti,sci-intr.yaml
 F:	Documentation/devicetree/bindings/reset/ti,sci-reset.txt
-F:	Documentation/devicetree/bindings/soc/ti/sci-pm-domain.txt
+F:	Documentation/devicetree/bindings/soc/ti/sci-pm-domain.yaml
 F:	drivers/clk/keystone/sci-clk.c
 F:	drivers/firmware/ti_sci*
 F:	drivers/irqchip/irq-ti-sci-inta.c
-- 
2.31.1

