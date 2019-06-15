Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFCE46F99
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 12:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfFOKjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 06:39:21 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40361 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbfFOKjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 06:39:20 -0400
Received: by mail-wm1-f66.google.com with SMTP id v19so4576954wmj.5;
        Sat, 15 Jun 2019 03:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nqWd/qVeeNGJLrkCP2JUFMQSQXMsBJtFqxofheHNWXk=;
        b=fuKDebUT8TsEdWgZzpehH53vOrTTqVVxivh6FDxX6NCHu8uJ/oiWb+z+jGtfWs3qIN
         ojtZXxPH9da+PV9kw1SCYbdBoFXvJv/EQAcEjdkptXXZD+HA8CTRjxeG5zJyxDSLAhDb
         ySEUTQK23Lbw/mKTb6LonhZG8qF3yF6wewmfyd0N81D6v9TO+nfIiTx0HIV70OPvs5CA
         EHihMrLkp605aEOvaU8r3sLgShlXeSuqHSM6ObZhBkSKwjvVA1dHxP/0RK54GqLUP3TB
         yLdfwXapp9nXbdjitlh4IWGBbKWeA9mYfePr2ClFHYIpOsqyRtZ4QEaj9OJcwuC71EI5
         taTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nqWd/qVeeNGJLrkCP2JUFMQSQXMsBJtFqxofheHNWXk=;
        b=aFKpg0DJKnBZjvGZQdvxpF7bJTVZF3u5kpK9PMOgLZOxgzg3VxTKTiUm0ZyDg+Q5vb
         1YlF14wTvoqJtDi+U0vkyZc7TTCQGhDxCFNqmXU8iiRZoC0l7QUyCoMIAg0NTKvFcEBW
         8tEFqF0bcnJ9paVjgRFfwdQe8kCSFlErbnIhh9aHId8Zyui4baFJAH336bfvY8gsShR/
         q7DfLvHnK+sIRQ0GgA/T7kxznoLnFuxYJ1gHmhROYmghqpRZq1Wp/cgdsUQteELg44UY
         z0nfDhDAEP0hW6j6iFXF1zeNgey6eGigiSYn2Xl/1JVwTNA/fihqj1VNw4npAoAsUSbh
         UIIA==
X-Gm-Message-State: APjAAAUmgorWX1Dnx4hq5uqVoQLK50aXgshBI+YCKzNfp1NLJHC1d4nt
        OQDL/YuEMSRAtLtfVLIkBcs=
X-Google-Smtp-Source: APXvYqwqvus05/JABsbGBZD+hMbcsTtFNC/JJ4BlBVVmPUhHLms3DAEG+Qg+dLV+L2PLpNGIoAmASQ==
X-Received: by 2002:a1c:7e90:: with SMTP id z138mr9645089wmc.128.1560595158121;
        Sat, 15 Jun 2019 03:39:18 -0700 (PDT)
Received: from blackbox.darklights.net (p200300F133C20E00A9A405DFDBBC0790.dip0.t-ipconnect.de. [2003:f1:33c2:e00:a9a4:5df:dbbc:790])
        by smtp.googlemail.com with ESMTPSA id o126sm12209031wmo.31.2019.06.15.03.39.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 15 Jun 2019 03:39:17 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-amlogic@lists.infradead.org, khilman@baylibre.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        robin.murphy@arm.com, narmstrong@baylibre.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 4/4] arm64: dts: meson: g12b: odroid-n2: add the Ethernet PHY reset line
Date:   Sat, 15 Jun 2019 12:38:32 +0200
Message-Id: <20190615103832.5126-5-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190615103832.5126-1-martin.blumenstingl@googlemail.com>
References: <20190615103832.5126-1-martin.blumenstingl@googlemail.com>
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

Acked-by: Neil Armstrong <narmstrong@baylibre.com>
Tested-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dts b/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dts
index c3e0735e6d9f..82b42c073c5e 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dts
@@ -250,6 +250,10 @@
 		/* Realtek RTL8211F (0x001cc916) */	
 		reg = <0>;
 		max-speed = <1000>;
+
+		reset-assert-us = <10000>;
+		reset-deassert-us = <30000>;
+		reset-gpios = <&gpio GPIOZ_15 (GPIO_ACTIVE_LOW | GPIO_OPEN_DRAIN)>;
 	};
 };
 
-- 
2.22.0

