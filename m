Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5168B3B9B3
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387637AbfFJQiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:38:15 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53825 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728104AbfFJQiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 12:38:03 -0400
Received: by mail-wm1-f68.google.com with SMTP id x15so18828wmj.3;
        Mon, 10 Jun 2019 09:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=93d8Luo3dr92mQ97MIWFoBIVe2vH3TgLc7Y5zBMUADU=;
        b=BLco2ickJdzVTDOmtPA6pU8JGKbc8q/sFLGVjNqwdZQSjNAV9PQk1ZLJUBLOADSWWs
         gwUJ1+DOIjdupl+cO9WBuzZIxZ0WDt9vFzq+8Nq+qgF5Tr4Iq1REeTMYjpE26W3NkQ1r
         SUk1SQqhaHpn6JldkZfm5nY8tHKF5MQ0Izu4n650nIvTFyKX3mv+CBuUPkjD+vpLrQKa
         KErEwVcCmEdUpnNEYo9E39M5d0IIPWo7oZGslNeJoDZSq3+J9JguS1vrUL6B1+Sx2GZj
         kxhttuHbHpPSEt9SI7rNM8TQQMmlqAgKkJ8147+ERsYXIBuvbMEGL8sfdhKXpSh10baB
         ziYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=93d8Luo3dr92mQ97MIWFoBIVe2vH3TgLc7Y5zBMUADU=;
        b=CpVM0JzMnFH9zgxePWs3nv9jCPb0vsbPHVSsAjzwSpUKkHYhMEAGFkjhq7AbatUehN
         QqKlNOkBG0inQpdeFA5vH33VBKmCEsssltaO/LAPzEfV/lva3AkM8A/7k5wPmKghgQAB
         vqzGRsyhzYB62pPJZrBV0HE/X1mkUKBsntHaVha3fyLv2KEylO3nkNkIZSc4Jz967n1G
         NX/8VV6BoqHcDg8Yz4s+VrKBFmlVVNU0RaSL47pNFBGo8gWcRxax8x9N94N803Tihrzg
         Hf3SI/RbP+VPH6cTStBRCUbnxn1KiolgiuXLhiXw5eJfGSvZx9fy+Wm+laCc5Xlb+Rzy
         XiTQ==
X-Gm-Message-State: APjAAAV8FfK8tRMSNPmVBjjdRM3ZDrEycsLe0UT+eSlBXbVwYKcZZfYi
        M9TaabVzCKtXau2FkJsYffs=
X-Google-Smtp-Source: APXvYqwp/VkFBJAJAcYToiC670FPFfJr8pHKpmUcNpT/ZB+25Ehrm6GqyZnXYjFC4GFUrgQ4CBFIxg==
X-Received: by 2002:a7b:cb84:: with SMTP id m4mr15184615wmi.50.1560184680413;
        Mon, 10 Jun 2019 09:38:00 -0700 (PDT)
Received: from blackbox.darklights.net (p200300F133DDA40000C4C39937FBD289.dip0.t-ipconnect.de. [2003:f1:33dd:a400:c4:c399:37fb:d289])
        by smtp.googlemail.com with ESMTPSA id g5sm13900517wrp.29.2019.06.10.09.37.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 09:37:59 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-amlogic@lists.infradead.org, khilman@baylibre.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 4/4] arm64: dts: meson: g12b: odroid-n2: add the Ethernet PHY reset line
Date:   Mon, 10 Jun 2019 18:37:36 +0200
Message-Id: <20190610163736.6187-5-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190610163736.6187-1-martin.blumenstingl@googlemail.com>
References: <20190610163736.6187-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The reset line of the RTL8211F PHY is routed to the GPIOZ_15 pad.
Describe this in the device tree so the PHY framework can bring the PHY
into a known state when initializing it. GPIOZ_15 doesn't support
driving the output HIGH (to take the PHY out of reset, only output LOW
to reset the PHY is supported). The datasheet states it's an "3.3V input
tolerant open drain (OD) output pin". Instead there's a pull-up resistor
on the board to take the PHY out of reset. The GPIO itself will be set
to INPUT mode to take the PHY out of reset and LOW to reset the PHY,
which is achieved with the flags (GPIO_ACTIVE_LOW | GPIO_OPEN_DRAIN).

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dts b/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dts
index 4146cd84989c..0d9ec45b8059 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dts
@@ -186,6 +186,10 @@
 		/* Realtek RTL8211F (0x001cc916) */	
 		reg = <0>;
 		max-speed = <1000>;
+
+		reset-assert-us = <10000>;
+		reset-deassert-us = <10000>;
+		reset-gpios = <&gpio GPIOZ_15 (GPIO_ACTIVE_LOW | GPIO_OPEN_DRAIN)>;
 	};
 };
 
-- 
2.22.0

