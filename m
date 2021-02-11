Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605883188B9
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 11:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhBKKyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 05:54:11 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:32356 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230002AbhBKKun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 05:50:43 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11BAj3Gb008610;
        Thu, 11 Feb 2021 02:49:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=bCk/R8C3q6tsAsz3Q1PobRWbB+sDN/neVpP1mx5zrzM=;
 b=TMP9kGGDnHM1ty+5e5+CTYJV4QIvACHgOoLfvCQem62piTPKHbw+XDJvmpIG+MoijqD/
 vQ5XIyOF1zXG4JnajBQ55hu22uubUSgtzMIoDItur5KRRif1WJ0w18hYl8Qq6axPdoh5
 ZGCZUrOIcWdUW09EOk5OxHsMme96chkoc1oygBq5ee4RFeMNRIwijnNKhHpE4UjiFYOq
 YXgTvLOjQa9o0fOIcoU3tJu/VbymblCjKDDDuIKxurPjBxSc5mX7cWILKQoduXe0zDTi
 U5Z0O02UqeRNOrB1IpdQp/qHM3YjLt1mI5mXNdqz4EmTxA3qjNqpWtRzVdsIiNTSXm6O wA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugqefa1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 02:49:53 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 02:49:51 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 02:49:51 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Feb 2021 02:49:51 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 22C943F703F;
        Thu, 11 Feb 2021 02:49:46 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>, <devicetree@vger.kernel.org>,
        <robh+dt@kernel.org>, <sebastian.hesselbarth@gmail.com>,
        <gregory.clement@bootlin.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Konstantin Porotchkin <kostap@marvell.com>
Subject: [PATCH v13 net-next 02/15] dts: marvell: add CM3 SRAM memory to cp11x ethernet device tree
Date:   Thu, 11 Feb 2021 12:48:49 +0200
Message-ID: <1613040542-16500-3-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1613040542-16500-1-git-send-email-stefanc@marvell.com>
References: <1613040542-16500-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_05:2021-02-10,2021-02-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Konstantin Porotchkin <kostap@marvell.com>

CM3 SRAM address space will be used for Flow Control configuration.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
Signed-off-by: Konstantin Porotchkin <kostap@marvell.com>
Acked-by: Marcin Wojtas <mw@semihalf.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 arch/arm64/boot/dts/marvell/armada-cp11x.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/marvell/armada-cp11x.dtsi b/arch/arm64/boot/dts/marvell/armada-cp11x.dtsi
index 9dcf16b..6fe0d26 100644
--- a/arch/arm64/boot/dts/marvell/armada-cp11x.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-cp11x.dtsi
@@ -59,7 +59,7 @@
 
 		CP11X_LABEL(ethernet): ethernet@0 {
 			compatible = "marvell,armada-7k-pp22";
-			reg = <0x0 0x100000>, <0x129000 0xb000>;
+			reg = <0x0 0x100000>, <0x129000 0xb000>, <0x220000 0x800>;
 			clocks = <&CP11X_LABEL(clk) 1 3>, <&CP11X_LABEL(clk) 1 9>,
 				 <&CP11X_LABEL(clk) 1 5>, <&CP11X_LABEL(clk) 1 6>,
 				 <&CP11X_LABEL(clk) 1 18>;
-- 
1.9.1

