Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2AD33DE20
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 20:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240694AbhCPTtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 15:49:50 -0400
Received: from mail-io1-f50.google.com ([209.85.166.50]:36419 "EHLO
        mail-io1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232332AbhCPTtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 15:49:05 -0400
Received: by mail-io1-f50.google.com with SMTP id n14so38563717iog.3;
        Tue, 16 Mar 2021 12:49:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nYYbB/MvNICmbzKUBm6FshvqUohLol3/xqrqx7tCQX4=;
        b=PIZeoLq9pNsEsiu2hH1JGpEj+CdIKUdoHVvXuoA4LgX9d2Yb+hsAeCZ/xqGW9wbS3x
         uJEt+RwBOy7OWqPz4qVZZ95W+AXyFWwM3E5sdU4OqiWp5bYtTzpxElZGnmQNk1lKtW46
         tr00z08jqi4X1dSyBqVRc6U+SAtB9pUldvXVdI+0qur1G29BK45T4xlVK+KrqltrWOxz
         uQzgfr6HX+dmTyQ3RMvvRwRBIgk88/DvkQl7Iau2+lLS1oIze2WP6WGP9AypUic+isxE
         H9lNNuF3kN0mpmEZ2HH5crJO0oNJm0CZu4+zF+ayTjntBRmAE30y1MwS+S9/QliY42pj
         Z/uQ==
X-Gm-Message-State: AOAM533l62vzMggja1ox2tIdfPhv3NWlPjQ+8fEfqNESoZhDYi3B/AKC
        OnbS0NEKFAtBUTnkZbRpBV9ABvQ3Wg==
X-Google-Smtp-Source: ABdhPJyfKHN75oX9DqIWGa8mzjKjBfLAAbD9JS24/mUfiYq5VYpbqhkIBDBomlyjMHHH7SbUSGgDxg==
X-Received: by 2002:a05:6602:2287:: with SMTP id d7mr4699829iod.42.1615924143956;
        Tue, 16 Mar 2021 12:49:03 -0700 (PDT)
Received: from xps15.herring.priv ([64.188.179.253])
        by smtp.googlemail.com with ESMTPSA id x24sm8965888iob.28.2021.03.16.12.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 12:49:02 -0700 (PDT)
From:   Rob Herring <robh@kernel.org>
To:     devicetree@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Maxime Ripard <mripard@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mark Brown <broonie@kernel.org>,
        Cheng-Yi Chiang <cychiang@chromium.org>,
        Benson Leung <bleung@chromium.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stefan Wahren <wahrenst@gmx.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Odelu Kukatla <okukatla@codeaurora.org>,
        Alex Elder <elder@kernel.org>, Suman Anna <s-anna@ti.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        linux-gpio@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-usb@vger.kernel.org
Subject: [PATCH] dt-bindings: Drop type references on common properties
Date:   Tue, 16 Mar 2021 13:48:58 -0600
Message-Id: <20210316194858.3527845-1-robh@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Users of common properties shouldn't have a type definition as the
common schemas already have one. Drop all the unnecessary type
references in the tree.

A meta-schema update to catch these is pending.

Cc: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Cheng-Yi Chiang <cychiang@chromium.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Stefan Wahren <wahrenst@gmx.net>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Odelu Kukatla <okukatla@codeaurora.org>
Cc: Alex Elder <elder@kernel.org>
Cc: Suman Anna <s-anna@ti.com>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: linux-gpio@vger.kernel.org
Cc: linux-pm@vger.kernel.org
Cc: linux-can@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-remoteproc@vger.kernel.org
Cc: alsa-devel@alsa-project.org
Cc: linux-usb@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
 .../bindings/arm/bcm/raspberrypi,bcm2835-firmware.yaml       | 5 +----
 Documentation/devicetree/bindings/arm/cpus.yaml              | 2 --
 .../bindings/display/allwinner,sun4i-a10-tcon.yaml           | 1 -
 .../devicetree/bindings/gpio/socionext,uniphier-gpio.yaml    | 3 +--
 .../devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml      | 1 -
 .../devicetree/bindings/interconnect/qcom,rpmh.yaml          | 1 -
 .../bindings/memory-controllers/nvidia,tegra210-emc.yaml     | 2 +-
 Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml   | 1 -
 Documentation/devicetree/bindings/net/qcom,ipa.yaml          | 1 -
 Documentation/devicetree/bindings/nvmem/nvmem-consumer.yaml  | 2 --
 .../devicetree/bindings/remoteproc/ti,omap-remoteproc.yaml   | 2 +-
 Documentation/devicetree/bindings/sound/ak4642.yaml          | 2 --
 .../devicetree/bindings/sound/google,cros-ec-codec.yaml      | 2 +-
 Documentation/devicetree/bindings/sound/renesas,rsnd.yaml    | 1 -
 .../devicetree/bindings/thermal/qcom-spmi-adc-tm5.yaml       | 1 -
 Documentation/devicetree/bindings/usb/usb.yaml               | 1 -
 16 files changed, 5 insertions(+), 23 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/bcm/raspberrypi,bcm2835-firmware.yaml b/Documentation/devicetree/bindings/arm/bcm/raspberrypi,bcm2835-firmware.yaml
index a2c63c8b1d10..c6144c8421fa 100644
--- a/Documentation/devicetree/bindings/arm/bcm/raspberrypi,bcm2835-firmware.yaml
+++ b/Documentation/devicetree/bindings/arm/bcm/raspberrypi,bcm2835-firmware.yaml
@@ -26,10 +26,7 @@ properties:
       - const: simple-mfd
 
   mboxes:
-    $ref: '/schemas/types.yaml#/definitions/phandle'
-    description: |
-      Phandle to the firmware device's Mailbox.
-      (See: ../mailbox/mailbox.txt for more information)
+    maxItems: 1
 
   clocks:
     type: object
diff --git a/Documentation/devicetree/bindings/arm/cpus.yaml b/Documentation/devicetree/bindings/arm/cpus.yaml
index 26b886b20b27..6be4a8852ee5 100644
--- a/Documentation/devicetree/bindings/arm/cpus.yaml
+++ b/Documentation/devicetree/bindings/arm/cpus.yaml
@@ -256,13 +256,11 @@ properties:
       where voltage is in V, frequency is in MHz.
 
   power-domains:
-    $ref: '/schemas/types.yaml#/definitions/phandle-array'
     description:
       List of phandles and PM domain specifiers, as defined by bindings of the
       PM domain provider (see also ../power_domain.txt).
 
   power-domain-names:
-    $ref: '/schemas/types.yaml#/definitions/string-array'
     description:
       A list of power domain name strings sorted in the same order as the
       power-domains property.
diff --git a/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-tcon.yaml b/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-tcon.yaml
index c13faf3e6581..3a7d5d731712 100644
--- a/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-tcon.yaml
+++ b/Documentation/devicetree/bindings/display/allwinner,sun4i-a10-tcon.yaml
@@ -73,7 +73,6 @@ properties:
   clock-output-names:
     description:
       Name of the LCD pixel clock created.
-    $ref: /schemas/types.yaml#/definitions/string-array
     maxItems: 1
 
   dmas:
diff --git a/Documentation/devicetree/bindings/gpio/socionext,uniphier-gpio.yaml b/Documentation/devicetree/bindings/gpio/socionext,uniphier-gpio.yaml
index 1a54db04f29d..bcafa494ed7a 100644
--- a/Documentation/devicetree/bindings/gpio/socionext,uniphier-gpio.yaml
+++ b/Documentation/devicetree/bindings/gpio/socionext,uniphier-gpio.yaml
@@ -43,8 +43,7 @@ properties:
 
   gpio-ranges: true
 
-  gpio-ranges-group-names:
-    $ref: /schemas/types.yaml#/definitions/string-array
+  gpio-ranges-group-names: true
 
   socionext,interrupt-ranges:
     description: |
diff --git a/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml b/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
index 6f2398cdc82d..1e7894e524f9 100644
--- a/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
@@ -102,7 +102,6 @@ patternProperties:
 
       st,adc-channel-names:
         description: List of single-ended channel names.
-        $ref: /schemas/types.yaml#/definitions/string-array
 
       st,filter-order:
         description: |
diff --git a/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml b/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml
index 799e73cdb90b..13da7b29c707 100644
--- a/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml
+++ b/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml
@@ -82,7 +82,6 @@ properties:
       this interconnect to send RPMh commands.
 
   qcom,bcm-voter-names:
-    $ref: /schemas/types.yaml#/definitions/string-array
     description: |
       Names for each of the qcom,bcm-voters specified.
 
diff --git a/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra210-emc.yaml b/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra210-emc.yaml
index 49ab09252e52..bc8477e7ab19 100644
--- a/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra210-emc.yaml
+++ b/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra210-emc.yaml
@@ -34,7 +34,7 @@ properties:
       - description: EMC general interrupt
 
   memory-region:
-    $ref: /schemas/types.yaml#/definitions/phandle
+    maxItems: 1
     description:
       phandle to a reserved memory region describing the table of EMC
       frequencies trained by the firmware
diff --git a/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml b/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
index fe6a949a2eab..55bff1586b6f 100644
--- a/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
+++ b/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
@@ -57,7 +57,6 @@ properties:
       - const: per
 
   clock-frequency:
-    $ref: /schemas/types.yaml#/definitions/uint32
     description: |
       The oscillator frequency driving the flexcan device, filled in by the
       boot loader. This property should only be used the used operating system
diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
index 8f86084bf12e..4e8dee4aa90d 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
@@ -100,7 +100,6 @@ properties:
       - description: Whether the IPA clock is enabled (if valid)
 
   qcom,smem-state-names:
-    $ref: /schemas/types.yaml#/definitions/string-array
     description: The names of the state bits used for SMP2P output
     items:
       - const: ipa-clock-enabled-valid
diff --git a/Documentation/devicetree/bindings/nvmem/nvmem-consumer.yaml b/Documentation/devicetree/bindings/nvmem/nvmem-consumer.yaml
index d5d7f113bade..828e4a1ece41 100644
--- a/Documentation/devicetree/bindings/nvmem/nvmem-consumer.yaml
+++ b/Documentation/devicetree/bindings/nvmem/nvmem-consumer.yaml
@@ -23,12 +23,10 @@ properties:
       List of phandle to the nvmem data cells.
 
   nvmem-names:
-    $ref: /schemas/types.yaml#/definitions/string-array
     description:
       Names for the each nvmem provider.
 
   nvmem-cell-names:
-    $ref: /schemas/types.yaml#/definitions/string-array
     description:
       Names for each nvmem-cells specified.
 
diff --git a/Documentation/devicetree/bindings/remoteproc/ti,omap-remoteproc.yaml b/Documentation/devicetree/bindings/remoteproc/ti,omap-remoteproc.yaml
index 1a1159097a2a..73400bc6e91d 100644
--- a/Documentation/devicetree/bindings/remoteproc/ti,omap-remoteproc.yaml
+++ b/Documentation/devicetree/bindings/remoteproc/ti,omap-remoteproc.yaml
@@ -93,7 +93,7 @@ properties:
 # The following are the optional properties:
 
   memory-region:
-    $ref: /schemas/types.yaml#/definitions/phandle
+    maxItems: 1
     description: |
       phandle to the reserved memory node to be associated
       with the remoteproc device. The reserved memory node
diff --git a/Documentation/devicetree/bindings/sound/ak4642.yaml b/Documentation/devicetree/bindings/sound/ak4642.yaml
index 6cd213be2266..1e2caa29790e 100644
--- a/Documentation/devicetree/bindings/sound/ak4642.yaml
+++ b/Documentation/devicetree/bindings/sound/ak4642.yaml
@@ -29,11 +29,9 @@ properties:
 
   clock-frequency:
     description: common clock binding; frequency of MCKO
-    $ref: /schemas/types.yaml#/definitions/uint32
 
   clock-output-names:
     description: common clock name
-    $ref: /schemas/types.yaml#/definitions/string
 
 required:
   - compatible
diff --git a/Documentation/devicetree/bindings/sound/google,cros-ec-codec.yaml b/Documentation/devicetree/bindings/sound/google,cros-ec-codec.yaml
index acfb9db021dc..77adbebed824 100644
--- a/Documentation/devicetree/bindings/sound/google,cros-ec-codec.yaml
+++ b/Documentation/devicetree/bindings/sound/google,cros-ec-codec.yaml
@@ -32,7 +32,7 @@ properties:
           The last one integer is the length of the shared memory.
 
   memory-region:
-    $ref: '/schemas/types.yaml#/definitions/phandle'
+    maxItems: 1
     description: |
       Shared memory region to EC.  A "shared-dma-pool".
       See ../reserved-memory/reserved-memory.txt for details.
diff --git a/Documentation/devicetree/bindings/sound/renesas,rsnd.yaml b/Documentation/devicetree/bindings/sound/renesas,rsnd.yaml
index 2e1046513603..e494a0416748 100644
--- a/Documentation/devicetree/bindings/sound/renesas,rsnd.yaml
+++ b/Documentation/devicetree/bindings/sound/renesas,rsnd.yaml
@@ -78,7 +78,6 @@ properties:
 
   clock-frequency:
     description: for audio_clkout0/1/2/3
-    $ref: /schemas/types.yaml#/definitions/uint32-array
 
   clkout-lr-asynchronous:
     description: audio_clkoutn is asynchronizes with lr-clock.
diff --git a/Documentation/devicetree/bindings/thermal/qcom-spmi-adc-tm5.yaml b/Documentation/devicetree/bindings/thermal/qcom-spmi-adc-tm5.yaml
index 95a728f4d333..3ea8c0c1f45f 100644
--- a/Documentation/devicetree/bindings/thermal/qcom-spmi-adc-tm5.yaml
+++ b/Documentation/devicetree/bindings/thermal/qcom-spmi-adc-tm5.yaml
@@ -59,7 +59,6 @@ patternProperties:
 
     properties:
       reg:
-        $ref: /schemas/types.yaml#/definitions/uint32
         description: Specify the sensor channel. There are 8 channels in PMIC5's ADC TM
         minimum: 0
         maximum: 7
diff --git a/Documentation/devicetree/bindings/usb/usb.yaml b/Documentation/devicetree/bindings/usb/usb.yaml
index 78491e66ed24..939f217b8c7b 100644
--- a/Documentation/devicetree/bindings/usb/usb.yaml
+++ b/Documentation/devicetree/bindings/usb/usb.yaml
@@ -16,7 +16,6 @@ properties:
     pattern: "^usb(@.*)?"
 
   phys:
-    $ref: /schemas/types.yaml#/definitions/phandle-array
     description:
       List of all the USB PHYs on this HCD
 
-- 
2.27.0

