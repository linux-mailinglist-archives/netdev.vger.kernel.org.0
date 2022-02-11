Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3BED4B21C9
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 10:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348581AbiBKJZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 04:25:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348558AbiBKJZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 04:25:04 -0500
Received: from mout.perfora.net (mout.perfora.net [74.208.4.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA90A1093;
        Fri, 11 Feb 2022 01:24:59 -0800 (PST)
Received: from localhost.localdomain ([81.221.85.15]) by mrelay.perfora.net
 (mreueus003 [74.208.5.2]) with ESMTPSA (Nemesis) id 0MC3mA-1nRDZx0FBw-008rrY;
 Fri, 11 Feb 2022 10:23:45 +0100
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
        Chester Lin <clin@suse.com>,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Fabio Estevam <festevam@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Heiko Thiery <heiko.thiery@gmail.com>,
        Jagan Teki <jagan@amarulasolutions.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Li Yang <leoyang.li@nxp.com>, Lucas Stach <dev@lynxeye.de>,
        Lucas Stach <l.stach@pengutronix.de>,
        Marek Vasut <marex@denx.de>, Martin KaFai Lau <kafai@fb.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Oleksij Rempel <linux@rempel-privat.de>,
        =?UTF-8?q?Oliver=20St=C3=A4bler?= <oliver.staebler@bytesatwork.ch>,
        Olof Johansson <olof@lixom.net>,
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
Subject: [PATCH v6 00/12] arm64: prepare and add verdin imx8m mini support
Date:   Fri, 11 Feb 2022 10:23:10 +0100
Message-Id: <20220211092322.287487-1-marcel@ziswiler.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:7w5KYRKknb7BBDzPYukxiHh8yFyZKgSG9xwi/4LCD9cxSfbNnZA
 pfVIg4x+OjCZx3OYYTUpS6Ejdg9I9y4pr2HyC/rVjP61OSGk6rt7dyWNPa1Ec3I9gq4hH9c
 WBxjo38Xg2mDpcIYgotq/IFKwqAp+RO5dH87WVRDEosKjQ1tkRyvsYAQeSaIYX0gFNMxyvi
 15bzF8L66zXSbWXRNKQCQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:+ZUf9f1Mwk8=:u9ps+IeiHfrybGOvLWFmoB
 qCHNyq8RF3QcHEwb1bmLNJS6CJZo3E9srdgqdWb7+Gi9wo/kH9YXBOkUbCqKZdWIrTT/IyqpS
 C8QKNB4Y43mEVPDErQtvunEo/TGVPsCSzO73Ma/eCnjBaZRs95bxGMZXljRIMpZKpj2Tookix
 i3KIe+8zJIDcAzw3baoDW2X/9p5syEyr2tJZotYEvHez0VEeegS856rhEf1WUQfmd9ZZ22G1S
 OOmOWrt1xMVE3+j55BuLUZ8POsOxXUJPe5qYK7g9YgddkR1++wLN5+pW6kVlh2nByY4+58V/7
 Jgzzbgs4CdaqNWSJjuWbwCQ591QJqqzq9PR1HnArCVuKQei6GRWv7n9ZkgBAZce8YzN49pOm0
 azE/oBUCsxCO5SFrRjGhson2+mVn71sPFmWXXO1am6D6O6qeyatQB58PtnE9p+NVcAG/e33nC
 pqOQry9EZLN+dhmUl22glExsxQSnsSiPj6srwHMs60zm7QeUgKocoJh7/mafacGEziZkoWrn3
 AWmzhOXPoTxSDykEfaVf8pg4tOO2pgXAqgz4A4Bg2NYy59cQstPczuiOlxLNnxospnQwoKPWo
 64GVk6UmmnL/HDFpnUCYbCR5nXNn/Ao4IHe8OKPm0Th33BeN+2IMe/+Sd1n0MetPAy9NoBT1g
 pyQNy++Veq9u8y2jgVoLFyW2QZgPu3rtFhaXOR4cHaREo4CjLVP3yoZFsrCR2E+0U0XA=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcel Ziswiler <marcel.ziswiler@toradex.com>


Fix strange hex notation and gpio-hog example, rebuild default
configuration, enable various relevant configuration options mainly to
be built as modules, add toradex,verdin-imx8mm et al. to dt-bindings and
finally, add initial support for Verdin iMX8M Mini.

Changes in v6:
- Rename codec to audio-codec.
- Put status property last.
Thanks, Shawn for reviewing and pointing those out!

Changes in v5:
- Add Rob's ack.
- Remove invalid wifi-host property.
- Remove rpmsg_reserved from the NXP vendor BSP not applicable upstream.
- Remove 2nd cs-gpio only going to an N/A component.
- Remove spi-num-chipselects as it is implicit by cs-gpios.
- Remove vbus-wakeup-supply not being a valid property.
- Fix picophy,dc-vol-level-adjust and picophy,pre-emp-curr-control which
  upstream are rather called samsung,picophy-dc-vol-level-adjust resp.
  samsung,picophy-pre-emp-curr-control.
Thanks, Fabio for reviewing and pointing those out!

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
 .../dts/freescale/imx8mm-verdin-wifi.dtsi     |   94 ++
 .../boot/dts/freescale/imx8mm-verdin.dtsi     | 1264 +++++++++++++++++
 arch/arm64/configs/defconfig                  |  126 +-
 13 files changed, 1811 insertions(+), 68 deletions(-)
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

