Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13474410BAB
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 14:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbhISM6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 08:58:19 -0400
Received: from mout.perfora.net ([74.208.4.194]:40169 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232394AbhISM6H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 08:58:07 -0400
Received: from localhost.localdomain ([81.221.236.183]) by mrelay.perfora.net
 (mreueus004 [74.208.5.2]) with ESMTPSA (Nemesis) id 1Mk0iC-1nCFXq27NA-00kNtD;
 Sun, 19 Sep 2021 14:55:51 +0200
From:   Marcel Ziswiler <marcel@ziswiler.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andreas Kemnade <andreas@kemnade.info>,
        Andrii Nakryiko <andrii@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Fabio Estevam <festevam@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Li Yang <leoyang.li@nxp.com>, Marek Vasut <marex@denx.de>,
        Martin KaFai Lau <kafai@fb.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Olof Johansson <olof@lixom.net>,
        Otavio Salvador <otavio@ossystems.com.br>,
        Pascal Zimmermann <pzimmermann@dh-electronics.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Stefan Riedmueller <s.riedmueller@phytec.de>,
        Tim Harvey <tharvey@gateworks.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        soc@kernel.org
Subject: [PATCH v3 0/9] ARM: prepare and add colibri imx6ull 1gb (emmc) support
Date:   Sun, 19 Sep 2021 14:55:27 +0200
Message-Id: <20210919125536.117743-1-marcel@ziswiler.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:yuHgL3suxeZmdwsdlRvLWnSFvJn72p/B2Q+ZQMEX0ze4w1sIYue
 y5CCiA2Zjt4hqEwc22z/ciodKapEGTsgjSZShBuM/nYLBbNnaXur+tYDPaHdgJvqz8WYdZx
 HRtEiZYYcRkwUx+8TzP8GU0gXZmwORQYNE4dom17cic0jOMbzX+lEu3b9EqtdIeg5a3ap2p
 U+nLna7CUpHhSTMhHZiLw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:4pLuSYrx7r0=:D+0o56dgmtQTlUwxMTBXpY
 ej4Vj3DrdFy5Bhcy4iFBN7UFMLXF9p1ZktceuqBkqPU19t5/ppDxw9gyEH6QLAEYREb98lxUa
 cyDFqVcrrDDyaMOEOEfX0a1BaRY/Dvif7lLLC1YjDCGVkmcbf/gblePOSIrZRxufHz2L2evAu
 JflJaNUyw0cdADJQIW972jMipMhMsk64sb+VWu6ixoqrL7detfBONhFMumoDD8FAb4NdksdIg
 V2zRLtd+Zhy+pzIqjNbmqOAFy0Qn6Vq7bcJ1fE9m6ChhfLIIYjB7WPCHc659wZfI8pSNHIKaj
 XPL97aaQ5Pp/9Zdxeg6yjtVYD/ydii98KQcTrexBTRG3/Qx1MkfJFI9oEgHKRzAtl5mH56TiN
 E0JHZ0PpwGuX4NEgVFtPkrPpVGR58o61rWrNkDFG7DQz4Q3kJ5v5a2ASsKrCGvbHebz9FEZ7K
 Ynxh0oxZUaS1Dg9edMivS/pbpQeQAw1RBmIrFfAmUXyJZaKCcrBfWsUiqMnRWwaBE6xXydv4p
 Na/W/W1k2c2zKsqAD+6N6a2EurymF55/h1qcC5c6HJzGKR/jY53vwnN7q9bZ2lGp/IvIV8jOD
 j5nYHpcMmhSSecsD65++pwq+rcehlTMi+jpQTh6wMPu9Wn5TynHXzDDL8nQY0s/7oh53/AI8i
 Fs4wcOjae1pFtdWUXTLtInwlRKrBM+72kCU/1VovrGBb1asGARcsapPh6z9Gv9XIx5epPbwmg
 PNPt8pT4f8FEOVkKeA/Hq235+0pNcsbo+2OqGg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcel Ziswiler <marcel.ziswiler@toradex.com>


Clean-up imx_v6_v7_defconfig and then add support for the new Colibri
iMX6ULL 1GB (eMMC) which builds on the success of the existing Colibri
iMX6ULL SKUs using raw NAND but replaces this with more RAM (1 GB) and
an eMMC (4 GB).

Changes in v3:
- Add Fabio's reviewed-by. Thanks!
- Added fixes tag as pointed out by Stefan and Fabio. Thanks!
- Add Rob's ack. Thanks!

Changes in v2:
- New patch cleaning-up dt-bindings documentation.
- Fix indentation.
- Use latest agreed upon SPDX-License-Identifier GPL-2.0+ OR MIT.
- Drop AG in our copyright statement as recommended by our legal.
- New patch documenting dt-bindings.

Marcel Ziswiler (8):
  ARM: imx_v6_v7_defconfig: enable mtd physmap
  ARM: imx_v6_v7_defconfig: enable fb
  ARM: imx_v6_v7_defconfig: change snd soc tlv320aic3x to i2c variant
  ARM: imx_v6_v7_defconfig: rebuild default configuration
  ARM: imx_v6_v7_defconfig: build imx sdma driver as module
  ARM: imx_v6_v7_defconfig: enable bpf syscall and cgroup bpf
  dt-bindings: arm: fsl: clean-up all toradex boards/modules
  dt-bindings: arm: fsl: add toradex,colibri-imx6ull-emmc

Max Krummenacher (1):
  ARM: dts: colibri-imx6ull-emmc: add device tree

 .../devicetree/bindings/arm/fsl.yaml          |  87 ++++----
 arch/arm/boot/dts/Makefile                    |   1 +
 .../boot/dts/imx6ull-colibri-emmc-eval-v3.dts |  17 ++
 .../dts/imx6ull-colibri-emmc-nonwifi.dtsi     | 185 ++++++++++++++++++
 arch/arm/boot/dts/imx6ull-colibri.dtsi        |  32 ++-
 arch/arm/configs/imx_v6_v7_defconfig          |  46 ++---
 6 files changed, 299 insertions(+), 69 deletions(-)
 create mode 100644 arch/arm/boot/dts/imx6ull-colibri-emmc-eval-v3.dts
 create mode 100644 arch/arm/boot/dts/imx6ull-colibri-emmc-nonwifi.dtsi

-- 
2.26.2

