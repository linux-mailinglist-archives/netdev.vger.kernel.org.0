Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5691746F9B
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 12:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbfFOKjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 06:39:16 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54890 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfFOKjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 06:39:16 -0400
Received: by mail-wm1-f67.google.com with SMTP id g135so4724307wme.4;
        Sat, 15 Jun 2019 03:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TimQLf28BUhZs7uT+zSn3k4UT1AmjQyz4dSffxOSscE=;
        b=Btqc98H+zDiJhMTSNooCyVZM9aw+pT4W+2uxs0k/OeuS36XxZEW051BU6h7xdaBrUG
         5Uzt2aab/JcjIMwv4AHm4gtCN4Hcq5YvM7+De3x5C3q8PPSat2rMOpsIw9SN2Az7ErjH
         agfpdpnAiV36T1nn8jLuFfeGJ0QMqYPYu0+yKwQ3BnmW9ALpL1Dp0hEW3EbXXqvCyWOa
         vORmOUX82p8xMWAjWhIHe9IkS0ELSg4PPKoCr/GBlXYoZzlbyDR46CU6IAXjarJwPqkK
         Tc9Ifcr4EwB/ORSQoYqwV5crbHealtm8dd9y5YEJod5p2Bk6bVxxNbuuDtSN4QqRPxBi
         0QEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TimQLf28BUhZs7uT+zSn3k4UT1AmjQyz4dSffxOSscE=;
        b=rGYnXQtWZpUy6veHoIxCMGqEMG1NjjVQy67YuMvwEmimy0sZfaOgvifqGekQ0Kx6wY
         4O1mLV3wRrsbHXu1aLZZ2beXNNbMYx0p+VA0K4nC4pJSmoRThfokwFs5aNTC0j51Ey7+
         PQyax+BoZG4pRy0nqEfpqeyiwd4u7yOvwA+QVy6SS7iUQF18tNgfIvqk/uLR9wV3Uc9l
         00zok9ysXXwTmsZaC/d9He7Xq3rEBkJYsngUBuy5A5kThfLQzJIJ3LOq5PkYouWPzKno
         9ZgIaGANBNd3yZ0DLZdpb8+/BFGmqxL7C0tQOEw+Yew6lMZK49ErPE0naJiFFfPwpcVb
         u+rQ==
X-Gm-Message-State: APjAAAUunVibUL0fhmn3yGMGpsfDUPSzzrsDr6625M8Kw3sToEPCP1rW
        7JnYJRrfrdRbRN2o5XLRe2A=
X-Google-Smtp-Source: APXvYqwkD9m2q7CAv0eVVlX2vVh1T0OsigTsOfcpg3MUm3XGrTqG0vi6zVwW39+OYE5y/KWeTyIo9w==
X-Received: by 2002:a1c:6c08:: with SMTP id h8mr11776798wmc.62.1560595154046;
        Sat, 15 Jun 2019 03:39:14 -0700 (PDT)
Received: from blackbox.darklights.net (p200300F133C20E00A9A405DFDBBC0790.dip0.t-ipconnect.de. [2003:f1:33c2:e00:a9a4:5df:dbbc:790])
        by smtp.googlemail.com with ESMTPSA id o126sm12209031wmo.31.2019.06.15.03.39.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 15 Jun 2019 03:39:13 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-amlogic@lists.infradead.org, khilman@baylibre.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        robin.murphy@arm.com, narmstrong@baylibre.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 1/4] arm64: dts: meson: g12a: x96-max: fix the Ethernet PHY reset line
Date:   Sat, 15 Jun 2019 12:38:29 +0200
Message-Id: <20190615103832.5126-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190615103832.5126-1-martin.blumenstingl@googlemail.com>
References: <20190615103832.5126-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Odroid-N2 schematics show that the following pins are used for the
reset and interrupt lines:
- GPIOZ_14 is the PHY interrupt line
- GPIOZ_15 is the PHY reset line

The GPIOZ_14 and GPIOZ_15 pins are special. The datasheet describes that
they are "3.3V input tolerant open drain (OD) output pins". This means
the GPIO controller can drive the output LOW to reset the PHY. To
release the reset it can only switch the pin to input mode. The output
cannot be driven HIGH for these pins.
This requires configuring the reset line as GPIO_OPEN_DRAIN because
otherwise the PHY will be stuck in "reset" state (because driving the
pin HIGH seems to result in the same signal as driving it LOW).

The reset line works together with a pull-up resistor (R143 in the
Odroid-N2 schematics). The SoC can drive GPIOZ_14 LOW to assert the PHY
reset. However, since the SoC can't drive the pin HIGH (to release the
reset) we switch the mode to INPUT and let the pull-up resistor take
care of driving the reset line HIGH.

Switch to GPIOZ_15 for the PHY reset line instead of using GPIOZ_14
(which actually is the interrupt line).
Move from the "snps" specific resets to the MDIO framework's
reset-gpios because only the latter honors the GPIO flags.
Use the GPIO flags (GPIO_ACTIVE_LOW | GPIO_OPEN_DRAIN) to match with
the pull-up resistor because this will:
- drive the output LOW to reset the PHY (= active low)
- switch the pin to INPUT mode so the pull-up will take the PHY out of
  reset

Fixes: 51d116557b2044 ("arm64: dts: meson-g12a-x96-max: Add Gigabit Ethernet Support")
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts b/arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts
index d37868d21114..3f9385553132 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts
@@ -285,6 +285,10 @@
 		reg = <0>;
 		max-speed = <1000>;
 		eee-broken-1000t;
+
+		reset-assert-us = <10000>;
+		reset-deassert-us = <30000>;
+		reset-gpios = <&gpio GPIOZ_15 (GPIO_ACTIVE_LOW | GPIO_OPEN_DRAIN)>;
 	};
 };
 
@@ -295,9 +299,6 @@
 	phy-mode = "rgmii";
 	phy-handle = <&external_phy>;
 	amlogic,tx-delay-ns = <2>;
-	snps,reset-gpio = <&gpio GPIOZ_14 0>;
-	snps,reset-delays-us = <0 10000 1000000>;
-	snps,reset-active-low;
 };
 
 &pwm_ef {
-- 
2.22.0

