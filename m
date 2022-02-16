Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7314B823F
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 08:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbiBPHu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 02:50:27 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:39954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbiBPHuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 02:50:24 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463661D686F
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 23:49:59 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nKF46-00035w-Ue; Wed, 16 Feb 2022 08:49:30 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nKF45-00FBar-0P; Wed, 16 Feb 2022 08:49:29 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Ray Jui <rjui@broadcom.com>, Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Scott Branden <sbranden@broadcom.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Tony Lindgren <tony@atomide.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH v5 0/8] document dt-schema and fix node names for some USB Ethernet controllers
Date:   Wed, 16 Feb 2022 08:49:18 +0100
Message-Id: <20220216074927.3619425-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

changes v5:
- move compatible string changes to a separate patch
- add note about possible regressions

changes v4:
- reword commit logs.
- add note about compatible fix

Oleksij Rempel (9):
  dt-bindings: net: add schema for ASIX USB Ethernet controllers
  dt-bindings: net: add schema for Microchip/SMSC LAN95xx USB Ethernet
    controllers
  dt-bindings: usb: ci-hdrc-usb2: fix node node for ethernet controller
  ARM: dts: bcm283x: fix ethernet node name
  ARM: dts: exynos: fix ethernet node name for different odroid boards
  ARM: dts: exynos: fix compatible strings for Ethernet USB devices
  ARM: dts: omap3/4/5: fix ethernet node name for different OMAP boards
  ARM: dts: tegra20/30: fix ethernet node name for different tegra
    boards
  arm64: dts: imx8mm-kontron: fix ethernet node name

 .../devicetree/bindings/net/asix,ax88178.yaml | 68 ++++++++++++++++
 .../bindings/net/microchip,lan95xx.yaml       | 80 +++++++++++++++++++
 .../devicetree/bindings/usb/ci-hdrc-usb2.txt  |  2 +-
 arch/arm/boot/dts/bcm283x-rpi-smsc9512.dtsi   |  2 +-
 arch/arm/boot/dts/bcm283x-rpi-smsc9514.dtsi   |  2 +-
 arch/arm/boot/dts/exynos4412-odroidu3.dts     |  4 +-
 arch/arm/boot/dts/exynos4412-odroidx.dts      |  8 +-
 arch/arm/boot/dts/exynos5410-odroidxu.dts     |  4 +-
 .../boot/dts/exynos5422-odroidxu3-lite.dts    |  6 +-
 arch/arm/boot/dts/exynos5422-odroidxu3.dts    |  6 +-
 arch/arm/boot/dts/omap3-beagle-xm.dts         |  2 +-
 arch/arm/boot/dts/omap4-panda-common.dtsi     |  2 +-
 arch/arm/boot/dts/omap5-igep0050.dts          |  2 +-
 arch/arm/boot/dts/omap5-uevm.dts              |  2 +-
 arch/arm/boot/dts/tegra20-colibri.dtsi        |  2 +-
 arch/arm/boot/dts/tegra30-colibri.dtsi        |  2 +-
 arch/arm/boot/dts/tegra30-ouya.dts            |  2 +-
 .../dts/freescale/imx8mm-kontron-n801x-s.dts  |  2 +-
 18 files changed, 173 insertions(+), 25 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/asix,ax88178.yaml
 create mode 100644 Documentation/devicetree/bindings/net/microchip,lan95xx.yaml

-- 
2.30.2

