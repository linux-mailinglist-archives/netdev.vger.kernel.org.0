Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3810C3162B8
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 10:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbhBJJwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 04:52:05 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:49580 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229475AbhBJJuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 04:50:11 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11A9ePQj013264;
        Wed, 10 Feb 2021 01:49:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=eQZa6J55ZcbM+2eaKvi6SaNVqtXxUpE1xx5SbgYCo8c=;
 b=hFQkshzf8VtZ9pJi+xA7gIU3Rz7UqDICjbarz7XIzOLl6q/tAhI1aAMCL3YmVlNbO+tG
 fkZyYVQ8nZ+DxvXNIv4w+hd5V372Y4i0uS/PFBZMRTu37AhNk47+eCqqyULgOSWod2Zd
 NQ220vl2NuV0q3c3ltU12NaUaRNXXS7joX6NK3C0/6SRg5PeVbwaQ+zIaKyvYBKRG6Sa
 kgLeVfCjPPB/paryHJY+DqPVx9g12z+I/9EuJxj3Mlrl21lZCeeKliiaCnB3bjHLTYDG
 cr5gDyMGCtWA2mX0y9wFUWjSWjM8ct3bVB4efmFR0870QbKSL3skdpjtwgjlS3JWArgU Aw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugqb92r-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 01:49:21 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Feb
 2021 01:49:18 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 10 Feb 2021 01:49:18 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 7EFCC3F7040;
        Wed, 10 Feb 2021 01:49:14 -0800 (PST)
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
Subject: [PATCH v12 net-next 02/15] dts: marvell: add CM3 SRAM memory to cp11x ethernet device tree
Date:   Wed, 10 Feb 2021 11:48:07 +0200
Message-ID: <1612950500-9682-3-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1612950500-9682-1-git-send-email-stefanc@marvell.com>
References: <1612950500-9682-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_03:2021-02-09,2021-02-10 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Konstantin Porotchkin <kostap@marvell.com>

CM3 SRAM address space will be used for Flow Control configuration.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
Signed-off-by: Konstantin Porotchkin <kostap@marvell.com>
Acked-by: Marcin Wojtas <mw@semihalf.com>
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

