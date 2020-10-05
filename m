Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED372835EA
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 14:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgJEMqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 08:46:52 -0400
Received: from inva021.nxp.com ([92.121.34.21]:58626 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725891AbgJEMqw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 08:46:52 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A330E20131D;
        Mon,  5 Oct 2020 14:46:50 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 96D56200598;
        Mon,  5 Oct 2020 14:46:50 +0200 (CEST)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 41BFB2032B;
        Mon,  5 Oct 2020 14:46:50 +0200 (CEST)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     shawnguo@kernel.org
Cc:     devicetree@vger.kernel.org, leoyang.li@nxp.com, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        camelia.groza@oss.nxp.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: [PATCH] arm64: dts: fsl: DPAA FMan DMA operations are coherent
Date:   Mon,  5 Oct 2020 15:46:39 +0300
Message-Id: <1601901999-28280-1-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@oss.nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although the DPAA 1 FMan operations are coherent, the device tree
node for the FMan does not indicate that, resulting in a needless
loss of performance. Adding the missing dma-coherent property.

Fixes: 1ffbecdd8321 ("arm64: dts: add DPAA FMan nodes")

Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
Tested-by: Camelia Groza <camelia.groza@oss.nxp.com>
---
 arch/arm64/boot/dts/freescale/qoriq-fman3-0.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/qoriq-fman3-0.dtsi b/arch/arm64/boot/dts/freescale/qoriq-fman3-0.dtsi
index 8bc6caa9167d..4338db14c5da 100644
--- a/arch/arm64/boot/dts/freescale/qoriq-fman3-0.dtsi
+++ b/arch/arm64/boot/dts/freescale/qoriq-fman3-0.dtsi
@@ -19,6 +19,7 @@ fman0: fman@1a00000 {
 	clock-names = "fmanclk";
 	fsl,qman-channel-range = <0x800 0x10>;
 	ptimer-handle = <&ptp_timer0>;
+	dma-coherent;
 
 	muram@0 {
 		compatible = "fsl,fman-muram";
-- 
2.1.0

