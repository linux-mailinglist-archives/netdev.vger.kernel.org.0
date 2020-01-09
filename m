Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87D2E136292
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 22:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728281AbgAIVbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 16:31:09 -0500
Received: from foss.arm.com ([217.140.110.172]:37060 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbgAIVbI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 16:31:08 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 59B6931B;
        Thu,  9 Jan 2020 13:31:07 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BB1DB3F534;
        Thu,  9 Jan 2020 13:31:06 -0800 (PST)
Date:   Thu, 09 Jan 2020 21:31:05 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     alexandre.belloni@bootlin.com, a.zummo@towertech.it,
        broonie@kernel.org, devicetree@vger.kernel.org,
        dmaengine@vger.kernel.org, eugen.hristev@microchip.com,
        jic23@kernel.org, knaack.h@gmx.de, lars@metafoo.de,
        lee.jones@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-can@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-rtc@vger.kernel.org,
        linux-spi@vger.kernel.org, ludovic.desroches@microchip.com,
        Mark Brown <broonie@kernel.org>, mark.rutland@arm.com,
        mchehab@kernel.org, miquel.raynal@bootlin.com, mkl@pengutronix.de,
        netdev@vger.kernel.org, nicolas.ferre@microchip.com,
        pmeerw@pmeerw.net, radu_nicolae.pirea@upb.ro,
        richard.genoud@gmail.com, richard@nod.at, robh+dt@kernel.org,
        tudor.ambarus@microchip.com, vigneshr@ti.com, vkoul@kernel.org,
        wg@grandegger.com
Subject: Applied "dt-bindings: spi_atmel: add microchip,sam9x60-spi" to the spi tree
In-Reply-To: <1578488123-26127-13-git-send-email-claudiu.beznea@microchip.com>
Message-Id: <applied-1578488123-26127-13-git-send-email-claudiu.beznea@microchip.com>
X-Patchwork-Hint: ignore
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch

   dt-bindings: spi_atmel: add microchip,sam9x60-spi

has been applied to the spi tree at

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git for-5.6

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.  

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark

From 0a1eb761ff30cdc089bcc94e1bd540b6956487c5 Mon Sep 17 00:00:00 2001
From: Claudiu Beznea <claudiu.beznea@microchip.com>
Date: Wed, 8 Jan 2020 14:55:19 +0200
Subject: [PATCH] dt-bindings: spi_atmel: add microchip,sam9x60-spi

Add microchip,sam9x60-spi to DT bindings documentation.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/1578488123-26127-13-git-send-email-claudiu.beznea@microchip.com
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 Documentation/devicetree/bindings/spi/spi_atmel.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/spi/spi_atmel.txt b/Documentation/devicetree/bindings/spi/spi_atmel.txt
index f99c733d75c1..5bb4a8f1df7a 100644
--- a/Documentation/devicetree/bindings/spi/spi_atmel.txt
+++ b/Documentation/devicetree/bindings/spi/spi_atmel.txt
@@ -1,7 +1,7 @@
 Atmel SPI device
 
 Required properties:
-- compatible : should be "atmel,at91rm9200-spi".
+- compatible : should be "atmel,at91rm9200-spi" or "microchip,sam9x60-spi".
 - reg: Address and length of the register set for the device
 - interrupts: Should contain spi interrupt
 - cs-gpios: chipselects (optional for SPI controller version >= 2 with the
-- 
2.20.1

