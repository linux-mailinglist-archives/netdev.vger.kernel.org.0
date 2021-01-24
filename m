Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC4E301B80
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 12:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbhAXLsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 06:48:09 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:31506 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726673AbhAXLrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 06:47:40 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10OBhhV5025153;
        Sun, 24 Jan 2021 03:44:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=7zWjGJUWgBhTVgspBjzVmO5tL3rxIGeYhc/8i0lYUM0=;
 b=hMTTp0T54vLbEDDSm4TmjMcBhHAHsvIgPTL0NsBYA+qNxzEALBQmkD4aDh65pgHZ9u98
 Bv0K9rAw2hk/dbQafSibn4Qsgvji4q3408mruVxjoYtDz3Ch3Ud6KpyYFLUUcSazLksa
 pC1YsTawug1vhysqqwsBo7RzqrJ8D+FYq5XIrkhs3fhCuX3yjPoaw4uxRaHwZPz8vy4t
 kYELj1QZB6Wi58vYz+FBqXpYjjwQJvPE36q/xB8MqG7qt24JJ44XN25r8Zn4fYc41Fyl
 GUn3EMW/+9UttxjIIqHuh1igccuZsfedq6T1LA6m5HfTtO20gT/WRV6ot6oLsua6/RxW Tw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 368m6u9st2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 24 Jan 2021 03:44:53 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 24 Jan
 2021 03:44:51 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 24 Jan
 2021 03:44:51 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 24 Jan 2021 03:44:50 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id BC66F3F7040;
        Sun, 24 Jan 2021 03:44:47 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>, Konstantin Porotchkin <kostap@marvell.com>
Subject: [PATCH v2 RFC net-next 02/18] dts: marvell: add CM3 SRAM memory to cp115 ethernet device tree
Date:   Sun, 24 Jan 2021 13:43:51 +0200
Message-ID: <1611488647-12478-3-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1611488647-12478-1-git-send-email-stefanc@marvell.com>
References: <1611488647-12478-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-24_04:2021-01-22,2021-01-24 signatures=0
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

