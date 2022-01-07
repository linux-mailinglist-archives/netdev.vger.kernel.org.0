Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3604B487BDC
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 19:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240614AbiAGSKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 13:10:41 -0500
Received: from mout.perfora.net ([74.208.4.197]:56811 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240523AbiAGSKk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 13:10:40 -0500
Received: from localhost.localdomain ([194.191.235.54]) by mrelay.perfora.net
 (mreueus004 [74.208.5.2]) with ESMTPSA (Nemesis) id 1MY6bJ-1ms0S53enN-00YRgs;
 Fri, 07 Jan 2022 19:03:45 +0100
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
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Fabio Estevam <festevam@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
        Jagan Teki <jagan@amarulasolutions.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Li Yang <leoyang.li@nxp.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lucas Stach <dev@lynxeye.de>, Martin KaFai Lau <kafai@fb.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
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
        Will Deacon <will@kernel.org>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v1 00/14] arm64: prepare and add verdin imx8m mini support
Date:   Fri,  7 Jan 2022 19:03:00 +0100
Message-Id: <20220107180314.1816515-1-marcel@ziswiler.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:lQAYnaUngUYQ76uILRN84VPgMhmWpzCUfkc68N9mfHP4fOWz9oG
 srl/W09VoexdO/nFLY0mzed7FqBOJPadFZqt/OIN3041PKAPxqnCQJNEY1DKDFtHBKL2YwP
 kp+6wSJMkeNyKxfobFhY3qke5JUzQ16a2+qm2po2aK/ANj/EBn5SwC4WCCXIrCAj/8BFK10
 5fNu6Iv0Vj8xvzCnz0Kyg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:0IwuyNRbEsc=:Jy2tkBEW4PLk6bjhWL7qhS
 9wUDXKFgD5OpK5Imkis0alQcUy5nOdvowQiQSnPUtnxHZYF1uo2ZquuDUZ2XIaVXxX2AxpiTc
 0Qb+Jw/TXqGEeCMbKH+pLnq+YdwZAWn9EzeO9SzuNjSaPeg8KvJX2UjyUmy0oURVm6eVrb3rq
 UH32x9+M7FlI8/EnWk3uDYhd6Ks/xwluh2OCu287JTF79/eyTucKwc9tDZHabWnO5OKliC+/+
 QZP8TkxFYoIOvW7jBHXdHqDybsFoVYjz9RKt+qj++FoJLsQ6LDK6eAgUFzA4CDbwqw44NzwiP
 HWbmtyLBmOca0s/GAWGpLVi6KUxh26A3cNhpgw7rPdkdYvTaP/hj3rjHhCvhX3YJqwT/BYFlj
 ECyqiEpq8CZuBTW99AVBpc/i4xfChyoxWCECBwhRqL+LaiAZ2a9/PJ+AIqv5372JtfIH703za
 dj5QsgSVQnbmMcV3X3wXIMbyE5ZPBHlVfWM+JjAiau0qYFsCsU+DgNGeX2wAd5yIAEtSWwfrB
 uYT5ut4kcg0GBEhfLdPy1yyDJK1/yUSWzUt20nPVWVwlYFtc+hYlXSrrANCpsk+hGnbGX2Ma9
 iTsiNkqis9Ixm3orId5eQSDMDpCmxv1c9tpy0ks7qf+OYR4uPtHO7rPB5Y0lQmu81ga6p4Ayf
 uEVuh2ovTteBvQONK/CBzpp9CQTD/ajZS9m6emAXOEK3BqEJsVpsHftu4Mf71T4aBQoE=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcel Ziswiler <marcel.ziswiler@toradex.com>


Fix strange hex notation and gpio-hog example, rebuild default
configuration, enable various relevant configuration options mainly to
be built as modules, add toradex,verdin-imx8mm et al. to dt-bindings and
finally add initial support for verdin imx8m mini.


Marcel Ziswiler (14):
  arm64: dts: imx8mm: fix strange hex notation
  dt-bindings: gpio: fix gpio-hog example
  arm64: defconfig: rebuild default configuration
  arm64: defconfig: enable bpf/cgroup firewalling
  arm64: defconfig: build imx-sdma as a module
  arm64: defconfig: build r8169 as a module
  arm64: defconfig: build ads1015 adc driver as a module
  arm64: defconfig: build lm75 temperature sensor driver as a module
  arm64: defconfig: build mcp251xfd can as a module
  arm64: defconfig: build sdio mwifiex as a module
  arm64: defconfig: build nxp bluetooth as modules
  arm64: defconfig: build nuvoton nau8822 as module
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
 .../boot/dts/freescale/imx8mm-verdin.dtsi     | 1277 +++++++++++++++++
 arch/arm64/configs/defconfig                  |  148 +-
 14 files changed, 1820 insertions(+), 90 deletions(-)
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

