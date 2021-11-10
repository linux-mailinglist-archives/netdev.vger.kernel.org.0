Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD9A44BB70
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 06:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbhKJFv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 00:51:58 -0500
Received: from inva020.nxp.com ([92.121.34.13]:38132 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229965AbhKJFvj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 00:51:39 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id E16A31A0E0E;
        Wed, 10 Nov 2021 06:48:51 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id A8FF61A0E07;
        Wed, 10 Nov 2021 06:48:51 +0100 (CET)
Received: from lsv03186.swis.in-blr01.nxp.com (lsv03186.swis.in-blr01.nxp.com [92.120.146.182])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 78E94183ACCB;
        Wed, 10 Nov 2021 13:48:50 +0800 (+08)
From:   Apeksha Gupta <apeksha.gupta@nxp.com>
To:     qiangqing.zhang@nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-devel@linux.nxdi.nxp.com, LnxRevLi@nxp.com,
        sachin.saxena@nxp.com, hemant.agrawal@nxp.com, nipun.gupta@nxp.com,
        Apeksha Gupta <apeksha.gupta@nxp.com>
Subject: [PATCH 5/5] arm64: dts: imx8mm-evk-dpdk: dts for fec-uio driver
Date:   Wed, 10 Nov 2021 11:18:38 +0530
Message-Id: <20211110054838.27907-6-apeksha.gupta@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211110054838.27907-1-apeksha.gupta@nxp.com>
References: <20211110054838.27907-1-apeksha.gupta@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New DTS file 'imx8mm-evk-dpdk.dts' is added to support fec
ethernet device detection in user space DPDK application via
fec-uio driver.

Signed-off-by: Sachin Saxena <sachin.saxena@nxp.com>
Signed-off-by: Apeksha Gupta <apeksha.gupta@nxp.com>
---
 arch/arm64/boot/dts/freescale/Makefile            |  1 +
 arch/arm64/boot/dts/freescale/imx8mm-evk-dpdk.dts | 10 ++++++++++
 2 files changed, 11 insertions(+)
 create mode 100644 arch/arm64/boot/dts/freescale/imx8mm-evk-dpdk.dts

diff --git a/arch/arm64/boot/dts/freescale/Makefile b/arch/arm64/boot/dts/freescale/Makefile
index db9e36ebe932..d8aabfc770fd 100644
--- a/arch/arm64/boot/dts/freescale/Makefile
+++ b/arch/arm64/boot/dts/freescale/Makefile
@@ -33,6 +33,7 @@ dtb-$(CONFIG_ARCH_LAYERSCAPE) += fsl-lx2162a-qds.dtb
 
 dtb-$(CONFIG_ARCH_MXC) += imx8mm-beacon-kit.dtb
 dtb-$(CONFIG_ARCH_MXC) += imx8mm-evk.dtb
+dtb-$(CONFIG_ARCH_MXC) += imx8mm-evk-dpdk.dtb
 dtb-$(CONFIG_ARCH_MXC) += imx8mm-ddr4-evk.dtb
 dtb-$(CONFIG_ARCH_MXC) += imx8mm-icore-mx8mm-ctouch2.dtb
 dtb-$(CONFIG_ARCH_MXC) += imx8mm-icore-mx8mm-edimm2.2.dtb
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-evk-dpdk.dts b/arch/arm64/boot/dts/freescale/imx8mm-evk-dpdk.dts
new file mode 100644
index 000000000000..3b5503933a35
--- /dev/null
+++ b/arch/arm64/boot/dts/freescale/imx8mm-evk-dpdk.dts
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright 2021 NXP
+ */
+
+#include "imx8mm-evk.dts"
+
+&fec1 {
+	compatible = "fsl,imx8mm-fec-uio";
+};
-- 
2.17.1

