Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F35930B972
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 09:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbhBBISk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 03:18:40 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:35718 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231489AbhBBISR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 03:18:17 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1128BRPb009926;
        Tue, 2 Feb 2021 00:17:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=5lKn6Ecz4xGgCyyvpqKHZ0HmmgVVSCgpayo06pbd8FA=;
 b=TYQkUU1SspcNDTTcTUeFCv8ST9fQPObMsxDicKW7vXVHhEaZr+m8EtX1krAbHULlf23q
 BBvaOnHW5nPtb2PS7bO6SZ8r8LLvLDRCL5bkCS9HrfTH4z2SYzvrMLwsTkg7ToFC3hY5
 4UDmczTNGAz99e+N6FV1+dPbGJJrzu4WrJg7zk8Ryl0a/dy+CGokaeGkZ8h9o4GwrpHT
 PPyHqfdlhhwo0JYkECyk9U0nMHPc+iGqbIlqawjpszzlmDpFk3o4KWNMP1JK39WEXSkE
 KOeoAC29csF1EdTeSEa+au/ZaV9XuplhX1V4bG/CBHRZpEF/5vOz1YKe3iQwO1EoBVkz Vw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36d7uq6e78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 02 Feb 2021 00:17:28 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 2 Feb
 2021 00:17:27 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 2 Feb
 2021 00:17:26 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 2 Feb 2021 00:17:26 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 0EDEA3F7040;
        Tue,  2 Feb 2021 00:17:22 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>, Konstantin Porotchkin <kostap@marvell.com>
Subject: [PATCH v7 net-next 02/15] dts: marvell: add CM3 SRAM memory to cp115 ethernet device tree
Date:   Tue, 2 Feb 2021 10:16:48 +0200
Message-ID: <1612253821-1148-3-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1612253821-1148-1-git-send-email-stefanc@marvell.com>
References: <1612253821-1148-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-02_04:2021-01-29,2021-02-02 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Konstantin Porotchkin <kostap@marvell.com>

CM3 SRAM address space would be used for Flow Control configuration.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
Signed-off-by: Konstantin Porotchkin <kostap@marvell.com>
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

