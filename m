Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094173F1B57
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 16:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240561AbhHSOL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 10:11:29 -0400
Received: from mout.perfora.net ([74.208.4.197]:44675 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240521AbhHSOL2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 10:11:28 -0400
Received: from toolbox.cardiotech.int ([81.221.236.183]) by mrelay.perfora.net
 (mreueus003 [74.208.5.2]) with ESMTPSA (Nemesis) id 0M7ZR3-1n1pE204ut-00xMEi;
 Thu, 19 Aug 2021 16:03:57 +0200
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
        KP Singh <kpsingh@kernel.org>, Marek Vasut <marex@denx.de>,
        Martin KaFai Lau <kafai@fb.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Olof Johansson <olof@lixom.net>,
        Otavio Salvador <otavio@ossystems.com.br>,
        Pascal Zimmermann <pzimmermann@dh-electronics.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        soc@kernel.org
Subject: [PATCH v1 0/7] ARM: prepare and add colibri imx6ull 1gb (emmc) support
Date:   Thu, 19 Aug 2021 16:03:38 +0200
Message-Id: <20210819140345.357167-1-marcel@ziswiler.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:lx5GBGXPRAQ1C2RGAY9/BxYJ6AKfNJ32vg25PpQG17n/6Pk2u7J
 j0IrCvlaDcncp28bcdtMZIR/DwKQVvCWFr7vbql1AglQzGyZwh9oLK0G32II0gQxXr+KoEO
 YlarmDCsgoaZn3VKxmD9TDVL/XOw4pV+gxmsZRPGcCYDGOQ0+6A7pOHxAyDkALGxGqTawBq
 oh5ehsLsIEqorCggir/4w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:mXrkhIbGR/4=:gpDAe+MQG0MDnf7deXR+2t
 50k/pRMfwSbbCVF3rQ8KSgb2oiLAWFxxF0yRiDYgeSp+ihHCHZhhWr8NjKdwvxrCh6k0f9VLd
 4d2aZhyOMaylPR54zmWrUt23uyoXmiI1I76kJNPnWZ/NwyqngR4f8Urs+E3cCcxEZuu8RWHxq
 nypxv1ZoN2O0ZlCHDDIXC0Obf4+f3f9BoE+eyxPAIlnjvIgEUFV/gP2cCMA3m2amoz2FuhB8O
 qhmx5sguQQKM6Kw5ylbfCwywvdob1KFO5HjQDnipXTkPzopfjO2bnXe3pEs7slv92ujdzcQPT
 maelNVPHwZfKJ0YBWd/c2nu9+MkTyqPFOXJim1tsbfaNbNqJLUyDog8Koxf26b5xfngwYsBTg
 Tx6mWtXmIfMWqVD5DBWdgH3HYIZpCrCgwqK7E9A+I0YkIRaqqz3kRzokp1DkMp9BlE9atzmgc
 i3JIfTx0V2x/FzsHaE8+FSKN/JW6iAouhD08/mfY5ZqB8ZaW3uBFvl568dfdwC/ir0cLd+/gV
 Ie5L51CmbQN7zIExKIyZI1PO5s9RLJaY8nMIS5+H3dAUU278IrRVdTBGO7G6h9OKph9G/ZO09
 2pjibwWSkHVbFwk7X3qfoE4AaKGNycwJlNR5vcoS4ZwnsqH9U8tPEFIUsnqIjitI8HbLUsiwQ
 ia10gA8i694SeE57Fjl2mxoKoQB2O13X1prDynb5X1xOcDW1pd18rSBXexy88JutsAV/m2D5S
 vJf4CJ3E9g85Bk+mafOXD/KXsBKlO8Bobv4zgAUdc7AbzlblszZSXERlSS9fkNEqIUSN8okRb
 F2N3lum8AWVz3fNSd1g4mHWrJVZeLPd+CsTXQJ57/+/J4npsRKHZJrsSsGUUDIbGTd+sscT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcel Ziswiler <marcel.ziswiler@toradex.com>


Clean-up imx_v6_v7_defconfig and then add support for the new Colibri
iMX6ULL 1GB (eMMC) which builds on the success of the existing Colibri
iMX6ULL SKUs using raw NAND but replaces this by more RAM (1 GB) and an
eMMC (4 GB).


Marcel Ziswiler (6):
  ARM: imx_v6_v7_defconfig: enable mtd physmap
  ARM: imx_v6_v7_defconfig: enable fb
  ARM: imx_v6_v7_defconfig: change snd soc tlv320aic3x to i2c variant
  ARM: imx_v6_v7_defconfig: rebuild default configuration
  ARM: imx_v6_v7_defconfig: build imx sdma driver as module
  ARM: imx_v6_v7_defconfig: enable bpf syscall and cgroup bpf

Max Krummenacher (1):
  ARM: dts: colibri-imx6ull-emmc: add device trees

 arch/arm/boot/dts/Makefile                    |   1 +
 .../boot/dts/imx6ull-colibri-emmc-eval-v3.dts |  17 ++
 .../dts/imx6ull-colibri-emmc-nonwifi.dtsi     | 185 ++++++++++++++++++
 arch/arm/boot/dts/imx6ull-colibri.dtsi        |  30 ++-
 arch/arm/configs/imx_v6_v7_defconfig          |  46 ++---
 5 files changed, 249 insertions(+), 30 deletions(-)
 create mode 100644 arch/arm/boot/dts/imx6ull-colibri-emmc-eval-v3.dts
 create mode 100644 arch/arm/boot/dts/imx6ull-colibri-emmc-nonwifi.dtsi

-- 
2.26.2

