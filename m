Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 353EA49FD87
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 17:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349873AbiA1QCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 11:02:37 -0500
Received: from mout.perfora.net ([74.208.4.196]:56201 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349949AbiA1QC2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 11:02:28 -0500
Received: from localhost.localdomain ([81.221.85.15]) by mrelay.perfora.net
 (mreueus003 [74.208.5.2]) with ESMTPSA (Nemesis) id 0MfFlM-1muHqF05kY-00Oknr;
 Fri, 28 Jan 2022 17:01:21 +0100
From:   Marcel Ziswiler <marcel@ziswiler.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Marek Vasut <marek.vasut@gmail.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
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
        Jagan Teki <jagan@amarulasolutions.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Li Yang <leoyang.li@nxp.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Martin KaFai Lau <kafai@fb.com>,
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
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v3 00/12] arm64: prepare and add verdin imx8m mini support
Date:   Fri, 28 Jan 2022 17:00:48 +0100
Message-Id: <20220128160100.1228537-1-marcel@ziswiler.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:XBMXSyJ9c8n2tynbNgt7ppKUmKRGaxcuubs/aQwLyBhLFrEzpdU
 9HevJnBdbj6KHiJB7OADGoiKnKa2cyNhZIR0xbr4+mVK9t0dlPHKX5SWPCu5up95bUvu7xJ
 dsmUF7Kh7eRXvrOxDolIObnlrkZe7mKHeJrBEBYuSswKLbRuQ3OWINbhrJhmUCJdunjrwcY
 gO06SAkapGAnGvW4wmI0A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:vSR/S7nqE60=:ID2LLGjD4h04zHbUZQFD6g
 FBxbKvnZtIN46bkcoejgeDnMcJyYWuotNCmXXXTAriAyfy/A1YE8u+aUhSshUxdfsNDmEjmTD
 2S5g+ZZhhLLLFHdmQLEqR5hw4Wc77If5021nJoswfr3MhNrGwdjVmSWhntolqSCeZp/t9SHsG
 Bg9k6twePAlKEdqS4Sv4Z+atSrvblpiqHay5YkyyKOoJYLoW2YRi46t6AGX93vpH6e0xwiq/m
 trUZ5aTTHqI7roaovsathUfye5UiiVEWLJv0veyE3PJpfWB3KL6r1XTPn4cV+DUJL9PvE14UY
 amwoeFHPNz37yqtsstUumwzq6teiu0hOVZYP7KW1TxygO9fpf6Nkb+OOia68JogzbvrwnKPew
 9qZYcSWhBdBTtGwb/7fAKwfEi9lTlDsAOTZ83r0bCd1aPQhvmpuTMeT2N8CrjptuljzkN7l9+
 2FmpatEgxizfM9xM2mQf1LIcCF2WXfLZCb6uu1crz19rNxv3bBeKQP9XHwjjWUmeFprESt9HO
 AWLk+nJ7yzqH/hqy/7eR4UQ/EP8MYzLKnAX8JnNV/Bz+qXqkcQ3iQBmbxuu2PIBwuOtL4clAT
 nOCO176ZJyhK+oNeZpGvcCMwOuF2tctiTKxX/qdZiel9h4uCVeIsdpytmnxrGDdYbuWpRMC5I
 Ws0vpixSJYE3XRo/ijwhLsZQm2z5hvGA22pTyngbCz45amQ96HYlAlNWW9voXOOzL6F8=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcel Ziswiler <marcel.ziswiler@toradex.com>


Fix strange hex notation and gpio-hog example, rebuild default
configuration, enable various relevant configuration options mainly to
be built as modules, add toradex,verdin-imx8mm et al. to dt-bindings and
finally, add initial support for Verdin iMX8M Mini.

Changes in v3:
- Rebase on top of shawnguo's for-next.
- Drop [PATCH v2 02/11] ("dt-bindings: gpio: fix gpio-hog example") as
  it already got applied by Bart.
- Add Krzysztof's reviewed-by tag.
- New separate patch only for re-ordering as suggested by Krzysztof.
- Not dropping CONFIG_SECCOMP=y, CONFIG_SLIMBUS=m, CONFIG_INTERCONNECT=y
  and CONFIG_CONFIGFS_FS=y as requested by Krzysztof.
- New patch enabling imx8m pcie phy driver in arm64 defconfig.
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
 .../boot/dts/freescale/imx8mm-verdin.dtsi     | 1291 +++++++++++++++++
 arch/arm64/configs/defconfig                  |  126 +-
 13 files changed, 1839 insertions(+), 68 deletions(-)
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

