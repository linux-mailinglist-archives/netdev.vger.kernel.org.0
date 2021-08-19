Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF8B3F22C9
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 00:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236719AbhHSWLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 18:11:03 -0400
Received: from mout.perfora.net ([74.208.4.197]:33231 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236766AbhHSWK6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 18:10:58 -0400
Received: from toolbox.cardiotech.int ([81.221.236.183]) by mrelay.perfora.net
 (mreueus002 [74.208.5.2]) with ESMTPSA (Nemesis) id 0MUYKb-1mgvhI3nyl-00RKn6;
 Fri, 20 Aug 2021 00:09:24 +0200
From:   Marcel Ziswiler <marcel@ziswiler.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andreas Kemnade <andreas@kemnade.info>,
        Andrii Nakryiko <andrii@kernel.org>,
        Anson Huang <Anson.Huang@nxp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Fabio Estevam <festevam@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
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
        Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, soc@kernel.org
Subject: [PATCH v2 0/9] ARM: prepare and add colibri imx6ull 1gb (emmc) support
Date:   Fri, 20 Aug 2021 00:09:01 +0200
Message-Id: <20210819220910.586819-1-marcel@ziswiler.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:M7jZ1dV3SMzKEadODKaF8SQsj8meK+kkTJZ10fSsSmTujoPQ3+A
 DB3wjDJ8+8oaqu00xJ68VSf6dLBG24Iu6X62NiJiDVB8y9FDg3WOmVdGOjdD0UnRmhberzd
 J2jljSe/ue0HzlFhkpc9oGHDXqtSRWeETubdPTtXrgdHYWNCFBEfs3VEXdzkNF30zWuo2Tv
 1IGM1o3XZKZq6s0C7tLzg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:yFDIVQYoi3E=:4EZnkmZOdg0/SrB0ZKogLB
 fdUNGtW3x39RntUiihgpR5nI8ZWLV9z1L8ut9781mTCnxyfd8/vF4xXk+0tVAjLqjW6vG+2af
 YOfbuVuZEilyqM5ajgp9AFEYFJPAu/SrM/5LTCf0ukLHW/00C7k7kDzsAzAgMN8RVOyA5fFBB
 e352fRP26DwGE6CjHpqwwEItIspaBbpQ1J1VG7di0ikkZy3KHaqym8IBn7bDL6dvsI8gcVWM3
 oyf1l5cHA611lfKUS2Qamp6chrJHYtJ00iRJhWOnFX1SsBI3QW5GsLGaM++pASZnyGNNEZmy7
 FSwNmDb9HygsTZb63kadqtTGMg/vKvL+aGQLu3V0S3b/uVprJ7z6GLUttrJn03QyiekmTOYQZ
 amiWYSWj5v8mTqv6Jk8H0PlSGebJj+BnjlLkcOBmlJeKfB3NGIK5cN8z8YQu6A0MbIG0M8r4O
 K4YNqbXqpouC41qZm7jkiI4Z/TSBqHvASFBGsWTZP3Qr9H8hD+mr12Y/MuvJnME7n2x9hHm9c
 GS7+p21JbJdjG1Uop9+hA8p8eLtZEP8cI/cNFxRovsamN5aQOcOqSMgi+5Fye+qwA7P1Bw10a
 ihgLpWPM8x+geW7eADnbc/SnIlUv/HsH73MH1jCdt4cVg6OeNNmeaTsCsv6hW3+hZInmELAkc
 51ecRMEamRqBSe+OhdMFGMkzOiV2ZPJeSXIQwTL271fkpjnIefoXq3C24LapGV4HXDWt4rrf+
 y+iJjG06SsHHgb7ruCMILq/wTxSx7zXxNJgT8VieG71b0fErMm+U912smIETOpr8+IXrjJnjF
 8UX0oo79mzhyTCW73pY1V0Z/FUIGFYFrpuCrOaEaWlh5s3XJSZjg9o7uKmD0OSgT0ka+QDE
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcel Ziswiler <marcel.ziswiler@toradex.com>


Clean-up imx_v6_v7_defconfig and then add support for the new Colibri
iMX6ULL 1GB (eMMC) which builds on the success of the existing Colibri
iMX6ULL SKUs using raw NAND but replaces this with more RAM (1 GB) and
an eMMC (4 GB).

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

