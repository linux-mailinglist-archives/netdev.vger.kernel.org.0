Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6EB3B9AC
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387482AbfFJQh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:37:59 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41220 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728104AbfFJQh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 12:37:58 -0400
Received: by mail-wr1-f68.google.com with SMTP id c2so9859919wrm.8;
        Mon, 10 Jun 2019 09:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KxTQ1F+Os2CstmvqUE/BjsdaVh4oEyh60Z7ykMvROWk=;
        b=QLTuSuj3WHPPBmJoh+N9vUdSULd+erekE60GenRMZt59UbozmhACV7Yjb3myqpck6W
         UkQaAtfF/Je0oyPSby1AFeWvGAMv7IQMrgEKgDNN/GmXNlpRM4krdvEswGBLQxTobou2
         sLR3motEd2W6hCHtu646djUIcYCG0UWNuY+VbmdFdrRk8yWYkiYdVndL6Rn74S8F4MA2
         o9zB4DGkIIszPVU8kNOYujvrgKkLitbL647VGRih64Dqx+N1Y5tdpXGcoNdDKsrNnVbk
         AIXm80Vj1e+kcgjCl7pZEXF9iwUvuIQuR2mMninEv1svbzPK9y8T9AMosxiKchj+lVpU
         Otqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KxTQ1F+Os2CstmvqUE/BjsdaVh4oEyh60Z7ykMvROWk=;
        b=H35tb83LdypPxVnyCSY/FfXiCSL+QnayyquU+3VFdWUaaA2WGFV9U4vUasgXUPm6wT
         wn02SNlyu9LCIfsI31Felby5Yb9zMAdh/pNezQ+f9iPk67eUS/PXMRwo5i4o4A2clwz8
         1dkp3F5aISXJLfiGT6YzG/hwBqO9kaeS4SRBIPnfAZjrJxoqU4qSGBZ5O9TN5fViCmsD
         Z9JzLI8pgQIuKHdae4GZiiQD+KQ+Wghw09EGGO/qjf71qWOffhJm/vB1ZJDBy1Wr5r5A
         /gxphf8ID97kfwEAeoOYs3XLqogEf9cviQSM5B8U3Lu5ROY6GASnKqgUx08/gALnXTmZ
         okqw==
X-Gm-Message-State: APjAAAWt1uCCIidGEKJb8kSfq+dZPQtTEeDVZh+fqVrkUN5M6wdvbXXa
        ou1xrYzj7JyE7zgh0pO+mCM=
X-Google-Smtp-Source: APXvYqymOhPQpHS+sVuoysG67YOlj14GSswxsJRgQv96Ns9FMgYV4kLExlHBDM2UuhVfgG+Ilrv9Zg==
X-Received: by 2002:adf:e311:: with SMTP id b17mr46082967wrj.11.1560184676657;
        Mon, 10 Jun 2019 09:37:56 -0700 (PDT)
Received: from blackbox.darklights.net (p200300F133DDA40000C4C39937FBD289.dip0.t-ipconnect.de. [2003:f1:33dd:a400:c4:c399:37fb:d289])
        by smtp.googlemail.com with ESMTPSA id g5sm13900517wrp.29.2019.06.10.09.37.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 09:37:55 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-amlogic@lists.infradead.org, khilman@baylibre.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 1/4] arm64: dts: meson: g12a: x96-max: fix the Ethernet PHY reset line
Date:   Mon, 10 Jun 2019 18:37:33 +0200
Message-Id: <20190610163736.6187-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190610163736.6187-1-martin.blumenstingl@googlemail.com>
References: <20190610163736.6187-1-martin.blumenstingl@googlemail.com>
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
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts b/arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts
index 98bc56e650a0..24956edaf8e2 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts
@@ -176,6 +176,10 @@
 		reg = <0>;
 		max-speed = <1000>;
 		eee-broken-1000t;
+
+		reset-assert-us = <10000>;
+		reset-deassert-us = <10000>;
+		reset-gpios = <&gpio GPIOZ_15 (GPIO_ACTIVE_LOW | GPIO_OPEN_DRAIN)>;
 	};
 };
 
@@ -186,9 +190,6 @@
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

