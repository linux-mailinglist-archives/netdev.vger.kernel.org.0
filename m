Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5464AA3CC
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 23:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376425AbiBDW6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 17:58:39 -0500
Received: from mout.perfora.net ([74.208.4.197]:59427 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231921AbiBDW6f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 17:58:35 -0500
Received: from localhost.localdomain ([81.221.85.15]) by mrelay.perfora.net
 (mreueus003 [74.208.5.2]) with ESMTPSA (Nemesis) id 0MJzil-1nEjwI3EvN-001TvT;
 Fri, 04 Feb 2022 23:57:28 +0100
From:   Marcel Ziswiler <marcel@ziswiler.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Marek Vasut <marek.vasut@gmail.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Adam Ford <aford173@gmail.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Ariel D'Alessandro <ariel.dalessandro@collabora.com>,
        Arnd Bergmann <arnd@arndb.de>,
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
        Jacky Bai <ping.bai@nxp.com>,
        Jagan Teki <jagan@amarulasolutions.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Li Yang <leoyang.li@nxp.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Marek Vasut <marex@denx.de>, Martin KaFai Lau <kafai@fb.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        =?UTF-8?q?Oliver=20St=C3=A4bler?= <oliver.staebler@bytesatwork.ch>,
        Olof Johansson <olof@lixom.net>, Peng Fan <peng.fan@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Tim Harvey <tharvey@gateworks.com>,
        Will Deacon <will@kernel.org>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v4 00/12] arm64: prepare and add verdin imx8m mini support
Date:   Fri,  4 Feb 2022 23:56:54 +0100
Message-Id: <20220204225706.1539818-1-marcel@ziswiler.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:s1q4mmUgZ51jKk6IKlz4YvuuHxni9qNHRrVr0x+7e7K30aft1VR
 uEFZwnTzITMYdFtg1cLoNBf5gka79YIPuaBJtgYHwAhnSfbco/m+AGsBAJ9logQ+daq2Wqw
 mtON3gqoOkbsw0oZi9pKIRDkERl1aJKjDelmQT2JRUUSZfgek0rxeUh/sptRdEUEo3wPzDL
 XnkR3SWmO2pMaIid7bMRQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ow5dbJxjCk4=:mbAnRiA6DbuP8PPL6aA6dx
 skmq2qfTLHxqRKzhvafJK5iZNyGUCw47+e9HF9RLyjXJXtNEVJA9h8BiVKR/4gGCIPEbyccuQ
 8BR7Cn7nI9M7E1hUtyS/TzO0RdLg57MFe6p2+372IWJ7XhOh0thA1yrqZaaZx1LGiLh800VYY
 FqOMrbXerwfK0R6XW44A7QFlaYqAeFZ8RiB2wvywFqGun/cXgCjHdP+BqQSnCjCfsOTglyYlF
 /VrmP8mwr2dEUlpkUj0RDHNzeK2yi65bK2oodRLVwDjdWxrMWKM+tQQ55C1SAOQgAuhRG0oc5
 2mwMp4ezuLcIP1yB9rNmaC4SRZTHwAlRIK4ON3opa47IY2BAwbSW+sa2AF6ZruMmveAYCnK/w
 JqbjZDZ0KJknni7Pt3gofbIv7XxRBYwkGtv7eYdq4mg8xaKB1bHt5lf+alCc1UArZQWFlQWYa
 h1GOqbPLJISRiP4XgVtx8mvDF6Dg21N6Pitpv15f02QxPMt/aCGRWrmiGlkru9pdgllW6cgR1
 dYlZO/FzLHTo/2HcULgy0gOMbA2kT3suzPY+bqw+SxAR+44v7zXAUcoQqLIBre5qI4GmbOiaO
 ASiUxFJw6pYwXH3XPjx+1CtnPbnE7G59DXK6v1mRb4a9bPuCXXS/Eh0AqaqLoftLNkCaM8n3g
 B4a4Tkg5mQrvjtvG+R5WC7qGs4wdSC5efHDt29ZKNjiSdDvRM3FdhF9afKzUcHArHXiM=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcel Ziswiler <marcel.ziswiler@toradex.com>


Fix strange hex notation and gpio-hog example, rebuild default
configuration, enable various relevant configuration options mainly to
be built as modules, add toradex,verdin-imx8mm et al. to dt-bindings and
finally, add initial support for Verdin iMX8M Mini.

Changes in v4:
- Re-base on top of Shawn's for-next branch.
- Fix gpio-line-names taking V1.1 re-design into account.
- Fix wrong SODIMM pin number.
- Drop 2nd SPI CAN instance being N/A in all SKUs.

Changes in v3:
- Add Krzysztof's reviewed-by tag.
- Add Krzysztof's reviewed-by tag.
- New separate patch only for re-ordering as suggested by Krzysztof.
- Not dropping CONFIG_SECCOMP=y, CONFIG_SLIMBUS=m, CONFIG_INTERCONNECT=y
  and CONFIG_CONFIGFS_FS=y as requested by Krzysztof.
- Add Krzysztof's reviewed-by tag.
- New patch enabling imx8m pcie phy driver in arm64 defconfig.
- Add Krzysztof's reviewed-by tag.
- Add Krzysztof's reviewed-by tag.
- Rebase on top of shawnguo's for-next.
- Drop [PATCH v2 02/11] ("dt-bindings: gpio: fix gpio-hog example") as
  it already got applied by Bart.
- Remove the 'pm-ignore-notify' property analogous to commit aafac22d6b23
  ("arm64: dts: imx8mm/n: Remove the 'pm-ignore-notify' property").
- Now with PCIe support finally having landed in -next enable it as well.
- Add Krzysztof's acked-by tag.

Changes in v2:
- Add Laurent's reviewed-by tag.
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

Marcel Ziswiler (12):
  arm64: dts: imx8mm: fix strange hex notation
  arm64: defconfig: enable taskstats configuration
  arm64: defconfig: enable pcieaer configuration
  arm64: defconfig: re-order default configuration
  arm64: defconfig: rebuild default configuration
  arm64: defconfig: enable bpf/cgroup firewalling
  arm64: defconfig: enable imx8m pcie phy driver
  arm64: defconfig: build imx-sdma as a module
  arm64: defconfig: build r8169 as a module
  arm64: defconfig: enable verdin-imx8mm relevant drivers as modules
  dt-bindings: arm: fsl: add toradex,verdin-imx8mm et al.
  arm64: dts: freescale: add initial support for verdin imx8m mini

 .../devicetree/bindings/arm/fsl.yaml          |   21 +
 arch/arm64/boot/dts/freescale/Makefile        |    4 +
 .../arm64/boot/dts/freescale/imx8mm-pinfunc.h |    6 +-
 .../dts/freescale/imx8mm-verdin-dahlia.dtsi   |  150 ++
 .../boot/dts/freescale/imx8mm-verdin-dev.dtsi |   67 +
 .../imx8mm-verdin-nonwifi-dahlia.dts          |   18 +
 .../freescale/imx8mm-verdin-nonwifi-dev.dts   |   18 +
 .../dts/freescale/imx8mm-verdin-nonwifi.dtsi  |   75 +
 .../freescale/imx8mm-verdin-wifi-dahlia.dts   |   18 +
 .../dts/freescale/imx8mm-verdin-wifi-dev.dts  |   18 +
 .../dts/freescale/imx8mm-verdin-wifi.dtsi     |   95 ++
 .../boot/dts/freescale/imx8mm-verdin.dtsi     | 1279 +++++++++++++++++
 arch/arm64/configs/defconfig                  |  126 +-
 13 files changed, 1827 insertions(+), 68 deletions(-)
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

