Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3710248EB79
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 15:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241586AbiANOQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 09:16:51 -0500
Received: from mout.perfora.net ([74.208.4.194]:35039 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241561AbiANOQh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jan 2022 09:16:37 -0500
Received: from localhost.localdomain ([81.221.144.115]) by mrelay.perfora.net
 (mreueus002 [74.208.5.2]) with ESMTPSA (Nemesis) id 0MDzNh-1n7blH0XmR-00HPF9;
 Fri, 14 Jan 2022 15:15:28 +0100
From:   Marcel Ziswiler <marcel@ziswiler.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Marek Vasut <marek.vasut@gmail.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chester Lin <clin@suse.com>,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Fabio Estevam <festevam@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Jagan Teki <jagan@amarulasolutions.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Li Yang <leoyang.li@nxp.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lucas Stach <dev@lynxeye.de>, Martin KaFai Lau <kafai@fb.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Michael Walle <michael@walle.cc>,
        NXP Linux Team <linux-imx@nxp.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        =?UTF-8?q?Oliver=20St=C3=A4bler?= <oliver.staebler@bytesatwork.ch>,
        Olof Johansson <olof@lixom.net>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Tim Harvey <tharvey@gateworks.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Will Deacon <will@kernel.org>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 00/11] arm64: prepare and add verdin imx8m mini support
Date:   Fri, 14 Jan 2022 15:14:56 +0100
Message-Id: <20220114141507.395271-1-marcel@ziswiler.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:qvE0E69fR3U8SG8guukfvjMfmFHtZUCRsqWEl8F+pYrI0Ep53um
 rqRdbFy9zCwgeP8Higi+PW6l3hNVFaQ/IgKdlD/Zua4XPmCBAdcLhf3ZBxQxJyPnfsuxHW+
 seLE8kF2gjRf+mt2BOZ9T+UR+WFt5gOpcTyzzCN/xJTBttwfb8D2dvvuqFQ0qkuWlN6WSie
 cH+M2m7z8JzJ9nbeQW7Gg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:sIvfkNPuiaI=:R2VPpHu2TucjxHx9nUCJqd
 9NFVV92twZUheUe/14OH/tJh70MsMWxzVYF5HWCSFhD+Skt5nvser05zMberpHVW/ePDKBTxV
 xaPuyCVjRxQBlf4ePDGPFx46gLkyUSItg/hI3VAs9jBoro5K7/vOtFKv95Vvykwa669TBas31
 HNTanFRKnBFclhEqPMgn5cXMgzS1jwBFR0+53u/9ttokno3i4A/1WJFFOptyTRLB6B0ppO6is
 Bt4YzeecP+O4sTm02M3bVue/FgDj7zjn1XBOVdBLVhOQmTVSq0YT1R7Jgn/j53EOQD2TIPu9u
 5bJW2QPQihyeHcrRjVw0CZXOLEFb6Q+LNiQlTi8ZB1fCSE2Qyd2PwZnsn6i7bw11qk5EsazVq
 mS3Fvey/e7qqozba0iTVJ0jx8qCcXWBqImtjHc8rMoi3XBuBOzBplJKhjHVTkbAQKqK065kOf
 PGJzOuCHOPfCe8k38a6Sfw//+umdKtQ1797C1ypZlJKN1PkHkkQZEgD+tGIDsR02pmpWpwkRh
 j0bCUC4qIeZygs+jzME+tiw5cxA4AJquCeNTag5eAmQwaZ/5QIPUVbhSrnqM0YMbgi79pxnRX
 6QX4u4PrYsH291zva8ZsDCJ1uIVbx66xRqPgmeBAYtudOPm6VWBVlqdWj6ZNjGf+qw7ckNmF3
 LX1oFSQdiVzxUD8SkVwQzsDH3Rr57cX/WuQn4Jhyx6GpWSYBr7LPC7mI75UZXQKfYHAU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcel Ziswiler <marcel.ziswiler@toradex.com>


Fix strange hex notation and gpio-hog example, rebuild default
configuration, enable various relevant configuration options mainly to
be built as modules, add toradex,verdin-imx8mm et al. to dt-bindings and
finally, add initial support for Verdin iMX8M Mini.

Changes in v2:
- Added Laurent's reviewed-by tag.
- Added Rob's ack.
- New patch following full defconfig analysis as requested by Krzysztof.
- New patch following full defconfig analysis as requested by Krzysztof.
- Done full defconfig analysis as requested by Krzysztof.
- Add Song's acked-by tag.
- A similar change got accepted for imx_v6_v7_defconfig. Further
discussion may be found in [1].
[1] https://lore.kernel.org/lkml/20210920144938.314588-6-marcel@ziswiler.com/
- Explain why enabling it may be a good idea as requested by Krzysztof.
- Explain why enabling these may make sense and squash them relevant
  changes as requested by Krzysztof.
- Add Rob's acked-by tag.
- Fix Colibri vs. Verdin copy/paste mistake. Thanks to Francesco Dolcini
  <francesco.dolcini@toradex.com> for pointing that out to me.
- Remove bootargs which will be filled in by the bootloader as requested
  by Krzysztof.
- Remove the previously #ifdefed-out spi-nor as requested by Krzysztof.
- Fix capitalisation in cover-letter.

Marcel Ziswiler (11):
  arm64: dts: imx8mm: fix strange hex notation
  dt-bindings: gpio: fix gpio-hog example
  arm64: defconfig: enable taskstats configuration
  arm64: defconfig: enable pcieaer configuration
  arm64: defconfig: rebuild default configuration
  arm64: defconfig: enable bpf/cgroup firewalling
  arm64: defconfig: build imx-sdma as a module
  arm64: defconfig: build r8169 as a module
  arm64: defconfig: enable verdin-imx8mm relevant drivers as modules
  dt-bindings: arm: fsl: add toradex,verdin-imx8mm et al.
  arm64: dts: freescale: add initial support for verdin imx8m mini

 .../devicetree/bindings/arm/fsl.yaml          |   21 +
 .../devicetree/bindings/gpio/gpio.txt         |    2 +-
 arch/arm64/boot/dts/freescale/Makefile        |    4 +
 .../arm64/boot/dts/freescale/imx8mm-pinfunc.h |    6 +-
 .../dts/freescale/imx8mm-verdin-dahlia.dtsi   |  143 ++
 .../boot/dts/freescale/imx8mm-verdin-dev.dtsi |   67 +
 .../imx8mm-verdin-nonwifi-dahlia.dts          |   18 +
 .../freescale/imx8mm-verdin-nonwifi-dev.dts   |   18 +
 .../dts/freescale/imx8mm-verdin-nonwifi.dtsi  |   75 +
 .../freescale/imx8mm-verdin-wifi-dahlia.dts   |   18 +
 .../dts/freescale/imx8mm-verdin-wifi-dev.dts  |   18 +
 .../dts/freescale/imx8mm-verdin-wifi.dtsi     |   95 ++
 .../boot/dts/freescale/imx8mm-verdin.dtsi     | 1267 +++++++++++++++++
 arch/arm64/configs/defconfig                  |  123 +-
 14 files changed, 1806 insertions(+), 69 deletions(-)
 create mode 100644 arch/arm64/boot/dts/freescale/imx8mm-verdin-dahlia.dtsi
 create mode 100644 arch/arm64/boot/dts/freescale/imx8mm-verdin-dev.dtsi
 create mode 100644 arch/arm64/boot/dts/freescale/imx8mm-verdin-nonwifi-dahlia.dts
 create mode 100644 arch/arm64/boot/dts/freescale/imx8mm-verdin-nonwifi-dev.dts
 create mode 100644 arch/arm64/boot/dts/freescale/imx8mm-verdin-nonwifi.dtsi
 create mode 100644 arch/arm64/boot/dts/freescale/imx8mm-verdin-wifi-dahlia.dts
 create mode 100644 arch/arm64/boot/dts/freescale/imx8mm-verdin-wifi-dev.dts
 create mode 100644 arch/arm64/boot/dts/freescale/imx8mm-verdin-wifi.dtsi
 create mode 100644 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi

-- 
2.33.1

