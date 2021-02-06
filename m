Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40853311EC1
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 17:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhBFQro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 11:47:44 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:31238 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230334AbhBFQrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 11:47:24 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 116Gj1mY021849;
        Sat, 6 Feb 2021 08:46:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=5lKn6Ecz4xGgCyyvpqKHZ0HmmgVVSCgpayo06pbd8FA=;
 b=lUa3EoqS/LXlVu6k0GeO1cXirP30zFoYapP+F/xQyObgTcKQUGMzUXmW0jnNMKki0DC+
 CbqTe8uBLeS5fsp5zZ+MFad6I+c2DTbjQfYvrKL6M4Eep85hgfD1a5iKoQMa0WB9Tqv0
 1/C8vd6av5bgN5PF1JGB+dCGPI9gnEtasbXrRKMVf2JcHpE4LoIdJUHgjCYONBsqSL8g
 QoClbzcZu4uE7LCDJzfXXn5PlAnN49jVQ2K9l3i+40EXDtXkPt9UlOMchvbRj+bBJ/cE
 MWyZ13S1bphxmjb9fF1pbIyqA20hvasF8EPscm7tYBlVnoz96IOZ5QZDTAwvEuvy55Fd Jw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbr8gur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 06 Feb 2021 08:46:33 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 6 Feb
 2021 08:46:32 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 6 Feb
 2021 08:46:32 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 6 Feb 2021 08:46:31 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id BD7F03F7040;
        Sat,  6 Feb 2021 08:46:28 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>, Konstantin Porotchkin <kostap@marvell.com>
Subject: [PATCH v8 net-next 02/15] dts: marvell: add CM3 SRAM memory to cp11x ethernet device tree
Date:   Sat, 6 Feb 2021 18:45:48 +0200
Message-ID: <1612629961-11583-3-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1612629961-11583-1-git-send-email-stefanc@marvell.com>
References: <1612629961-11583-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-06_06:2021-02-05,2021-02-06 signatures=0
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

