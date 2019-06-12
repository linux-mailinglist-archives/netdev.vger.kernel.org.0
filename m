Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1604312D
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 22:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390065AbfFLUzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 16:55:52 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34590 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389710AbfFLUzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 16:55:52 -0400
Received: by mail-wm1-f67.google.com with SMTP id w9so5106840wmd.1;
        Wed, 12 Jun 2019 13:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/gDKxCzkOGRMbdoCC0wOn2Sy/Yhww68pPHd5X9PQ/go=;
        b=rUFa0q2c0ueMNjFCD1Ac5K6Fk3nNqiUfkEeny7sxh9dWEiE47qRnzWq/iyJskI1FN6
         TkvKq+3i0BEq+hEvnmDXfmeMkxmbmaEeWY7Al9ZAMXzhvuIb9UTLv4OqgxxaucaebMeg
         HglMyVVyQVo1UvCHaN4eTBCMv6080H2AYZzxmGKwLBpLGuZLsdg+A3gDjedobRasNnVX
         oaNucyrsFv/jrfCh0Qim+CfblXfOK1UP/F3mfsKW+kk5Lq2GmcyG9an87uJWAmMbNQxx
         EI32FZJtuNT9y8crY9P8KETEaPvzZOjxyWZSv8f5bsUX3LIc4AyJBC6fj12cVvNpwplH
         F5gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/gDKxCzkOGRMbdoCC0wOn2Sy/Yhww68pPHd5X9PQ/go=;
        b=LQY51wi0dYzqG+xVyhJAicXxyPtoK3E+hi7+NIJM4wD8vGVncXIXQC4Jzib6sqM7Iq
         6eULmr6l0x9OR9LwaLDeLJBo8vww4kUrk8V7WVBWz8j34jpofb9+LELY1ebav7xi+gEE
         myIZQmko/i3+IUNSe0nK3lmPtyjU9OPZ52pvKDKv5/ZFQMnrAJe643mPlcGLVAlAMH3l
         hYREmcanGi7KSu+9XQZGLjaRcCs38CLhTaU25vNWzV6YJZO7twr2KW4nfDik9hgQnteR
         NfB1hIAP9/YNUdEHzCd8HrKufFq/lComMrAR0km+2CVbH4PRlEd7GIXwji4S3qzfXpM4
         YHMQ==
X-Gm-Message-State: APjAAAWrBb8FwK8zirJQLt+87lKuYDGPaC0jWd4ERyOcesaGaSVvy1iw
        Z5br/MF2BihxQ4xc0eP8PkI=
X-Google-Smtp-Source: APXvYqzcczDON40ZlWQv3oZhlUvn1FVQLcLqir1pA8IDNtA5z7hDUzg0Hn0fX1zXP3GmKNC7Wsrr/Q==
X-Received: by 2002:a7b:c081:: with SMTP id r1mr820317wmh.76.1560372949589;
        Wed, 12 Jun 2019 13:55:49 -0700 (PDT)
Received: from blackbox.darklights.net (p200300F133DDA400428D5CFFFEB99DB8.dip0.t-ipconnect.de. [2003:f1:33dd:a400:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id s7sm3445793wmc.2.2019.06.12.13.55.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 13:55:48 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-amlogic@lists.infradead.org, khilman@baylibre.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        robin.murphy@arm.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v2 4/4] arm64: dts: meson: g12b: odroid-n2: add the Ethernet PHY reset line
Date:   Wed, 12 Jun 2019 22:55:29 +0200
Message-Id: <20190612205529.19834-5-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190612205529.19834-1-martin.blumenstingl@googlemail.com>
References: <20190612205529.19834-1-martin.blumenstingl@googlemail.com>
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
index 4146cd84989c..f911bbdc4e70 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dts
@@ -186,6 +186,10 @@
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

