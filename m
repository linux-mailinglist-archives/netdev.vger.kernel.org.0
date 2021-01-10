Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 619992F0801
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 16:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbhAJPdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 10:33:49 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:58454 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726069AbhAJPds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 10:33:48 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10AFPbMZ022764;
        Sun, 10 Jan 2021 07:31:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=7zWjGJUWgBhTVgspBjzVmO5tL3rxIGeYhc/8i0lYUM0=;
 b=AHk+lzwgWN7+oL2WIDrOAMJw7cyuvX+gk+paDttit3j727g+O0npqVtmRkXYO65GVyI0
 e1Rc4TfxAAm8/wURGMLc/C8mBLakFzfm5oNoh3Gj5/qQOZHEL0j3dnWGyOTLkFZXFsDv
 lWrrX5dDbexCYsHlOv19ARZYAlH1ja0Qhj2odhs8ltmdA9zwNPo5y1z7c3s6YG2aSzjW
 s9leAW2z1mPRUUvia+0OWUnEFqh92NjuwPZYwkV9n0YLqi/xjsFu7kEsYxQTgyW8vDpz
 +2elBLbYHMO69o0kwIxkBOxDTf7qN64FIKIVh5njI+fLymAbbTz+kc1y0avXUWwBt3PY tg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 35ycvphvcu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 10 Jan 2021 07:31:01 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 07:30:59 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 07:30:58 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 10 Jan 2021 07:30:58 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 5E5C43F703F;
        Sun, 10 Jan 2021 07:30:55 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>, Konstantin Porotchkin <kostap@marvell.com>
Subject: [PATCH RFC net-next  02/19] dts: marvell: add CM3 SRAM memory to cp115 ethernet device tree
Date:   Sun, 10 Jan 2021 17:30:06 +0200
Message-ID: <1610292623-15564-3-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Konstantin Porotchkin <kostap@marvell.com>

CM3 SRAM address space would be used for Flow Control configuration.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 arch/arm64/boot/dts/marvell/armada-cp11x.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/marvell/armada-cp11x.dtsi b/arch/arm64/boot/dts/marvell/armada-cp11x.dtsi
index 9dcf16b..359cf42 100644
--- a/arch/arm64/boot/dts/marvell/armada-cp11x.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-cp11x.dtsi
@@ -69,6 +69,8 @@
 			status = "disabled";
 			dma-coherent;
 
+			cm3-mem = <&CP11X_LABEL(cm3_sram)>;
+
 			CP11X_LABEL(eth0): eth0 {
 				interrupts = <39 IRQ_TYPE_LEVEL_HIGH>,
 					<43 IRQ_TYPE_LEVEL_HIGH>,
@@ -211,6 +213,14 @@
 			};
 		};
 
+		CP11X_LABEL(cm3_sram): cm3@220000 {
+			compatible = "mmio-sram";
+			reg = <0x220000 0x800>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0 0x220000 0x800>;
+		};
+
 		CP11X_LABEL(rtc): rtc@284000 {
 			compatible = "marvell,armada-8k-rtc";
 			reg = <0x284000 0x20>, <0x284080 0x24>;
-- 
1.9.1

