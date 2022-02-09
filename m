Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C4C4AEF5B
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 11:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiBIKhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 05:37:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiBIKhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 05:37:05 -0500
Received: from mout.perfora.net (mout.perfora.net [74.208.4.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E12E145D95;
        Wed,  9 Feb 2022 02:25:16 -0800 (PST)
Received: from localhost.localdomain ([81.221.85.15]) by mrelay.perfora.net
 (mreueus004 [74.208.5.2]) with ESMTPSA (Nemesis) id 1MHWaj-1nUgCn0LWT-00DTV1;
 Wed, 09 Feb 2022 11:01:20 +0100
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
        Jagan Teki <jagan@amarulasolutions.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Li Yang <leoyang.li@nxp.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Marek Vasut <marex@denx.de>, Martin KaFai Lau <kafai@fb.com>,
        Mathew McBride <matt@traverse.com.au>,
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
Subject: [PATCH v5 00/12] arm64: prepare and add verdin imx8m mini support
Date:   Wed,  9 Feb 2022 11:00:43 +0100
Message-Id: <20220209100055.181389-1-marcel@ziswiler.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:n05M3tQke/wbx4BwulLlNYpxM+07HAnqQEgr8qhk4VBVHXDvK3+
 ujPIaviFQhKTCKCTKjOymaFZY2V/iwpSOPXVVeFgh6ASzWghhJgy+Sf6K9yHSIGj3j4wlDf
 j6ge4cTaAo2GCSInY/Abk0+HXZ14M4jmQDsUoW3XteLL02c1AKepeB3JFDHIZxJKXivnAKV
 k6xKqc+zr2d3n2JnR66Eg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:OBqy+dPAZuI=:2jNPH3Z+AeOAxPZsedu41j
 +gFV4XPNlbepYdV91tio2hDKY8O70Rxrvg8WgGqRlOCjiszn+394bWRhPO1Owvk0Ygw8Jnd0q
 kXWW93HRZePsb7S6yrXkARgz2t75+Z1yUJHhKtsof7cICrWaxlGhiRIGxR6ylpHNRS85OKogl
 +zEjO7iV+0ut7mkounj6yALv2ONLc6jIsUfR9LuPPJEOmnqz6QxZ106zBrf1j5rtdjgcVfHvy
 sHYL0AEMGTX1dO51Rvg5JXyxXVlbJN9xPrYo8+ON8Fbrd2Imq6pUB9MKmudxTm8mX/EaIWl7g
 3VvMjt2tQflZqmCuY5QzGH4qMg9PP+jNPRoSX8/oeo3u7kP5sPPScxRdksxSPpeuzvhzSbhfM
 nWUDQ9hvqaXF1OIUbqndrBKGgpcEgiaFqxiUp3qTN3O3tj2RoyKH+p1xbn9f3WYyxgr3X4M2F
 LMUrln6xbC9Uytsc/PjuNM51rPzFZR5vYOgUVu4XsBJ3Gv4utHAqsPtXhcdmt7rPwrT5eeDYv
 ktih+6EuKlbYB7Kg3jY2ewqkKJLjMzqGpDbigFSBInjmC97ZNDcDfRL5mDHZUtH8YN6aS1wT1
 mgdi3QNBtFkOS3Et30Sz1Bbt0pgbWw7+NeAsEaQj1bvH5RkDPUXWM3inXIIq8TtJlKKW+DiVc
 ZS+7aZ85msB9qJYjG4hVXOuQqxhFTWrPA9fb6xnKbRzYhrFwXrebCDcqD/WAu52gJU4Q=
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
- New separate patch only for re-ordering as suggested by Krzysztof.
- Not dropping CONFIG_SECCOMP=y, CONFIG_SLIMBUS=m, CONFIG_INTERCONNECT=y
  and CONFIG_CONFIGFS_FS=y as requested by Krzysztof.
- New patch enabling imx8m pcie phy driver in arm64 defconfig.
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

