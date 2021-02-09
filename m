Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB20314A9A
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 09:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhBIIoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 03:44:55 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:63076 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229981AbhBIIoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 03:44:12 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1198a96X003809;
        Tue, 9 Feb 2021 00:43:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=RdNj1xs03e1paOFCKsPuFia7ORTcb4m3bYZEEMGW1cU=;
 b=bc0QrbiXSD02eF1GD8eCElpJ/5vOs3NyyVx9AxzmQo9Hc1+brYPszsOX04heSa865cDF
 4OPiaKJXJRDhGZsE6ChYNDMbU/IOlUsQkIr86cocrtCy9xVcGeCpG1dDVJFEEWp87DVU
 gRg/dy1BMG9ISO2YuNsOpnUns3U2INlC3vzCU5LFncrYDgLLv6RNSy/FAmqQBSV9VtZe
 rBulMXZ8oU1UH6h4ILBpL6tf/kTX87F9LZmZzIGx8bZawX46xdFqlda9skAB3c0/67Y2
 Hr55vH2b3wGGlPC8gfv4JGT2t3UXmWyaX8yCr5X+9BDV4I4BLZlnzAlk7YbnX3gbXhEe wg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbrfsqb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 00:43:20 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Feb
 2021 00:43:19 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 9 Feb 2021 00:43:19 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 12E993F7043;
        Tue,  9 Feb 2021 00:43:14 -0800 (PST)
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
Subject: [PATCH v11 net-next 02/15] dts: marvell: add CM3 SRAM memory to cp11x ethernet device tree
Date:   Tue, 9 Feb 2021 10:42:18 +0200
Message-ID: <1612860151-12275-3-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1612860151-12275-1-git-send-email-stefanc@marvell.com>
References: <1612860151-12275-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_02:2021-02-09,2021-02-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Konstantin Porotchkin <kostap@marvell.com>

CM3 SRAM address space would be used for Flow Control configuration.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
Signed-off-by: Konstantin Porotchkin <kostap@marvell.com>
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

