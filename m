Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 062F23162B1
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 10:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhBJJvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 04:51:03 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:32588 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229793AbhBJJty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 04:49:54 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11A9eWnL013304;
        Wed, 10 Feb 2021 01:49:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=PZMQI6qrDBXVkYRESL4+mOJLgJYdSMTv37arfL6XHfc=;
 b=UQmTxu8lj4jz/+yNe5x1myNkn2Y7ssJnGrjE5Gj7ANBSN1g18X7/OHRxhO3yIg1R3u/U
 sxN4w1T6JtAiCog1bvtUMeFYLoHDyN1oS4UN5pE9Ppv+th8EIaEfFEwn/QJfJSS0J/nW
 RlXmAF/KZIOQSdtxkeK2da0qEf4VTPjIlA+qyresxdUz7jBinMgNUwmoRQ4bloZIdmOy
 w4ooE1dDmg4OtjQ3Ww1NKwyqygBU45oBORDON7WGuAl/no0t/k/jUrwSzvnA/9pvZLMo
 6DgjiWn2nnJwHTSYwGeSff7K0k0PBdK2H5jyYTojMujuftNZeotfq0SElMNgeeWyLvVH 0g== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugqb922-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 01:49:01 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Feb
 2021 01:48:59 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Feb
 2021 01:48:59 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 10 Feb 2021 01:48:59 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 2B1453F7041;
        Wed, 10 Feb 2021 01:48:54 -0800 (PST)
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
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v12 net-next 01/15] doc: marvell: add CM3 address space and PPv2.3 description
Date:   Wed, 10 Feb 2021 11:48:06 +0200
Message-ID: <1612950500-9682-2-git-send-email-stefanc@marvell.com>
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

From: Stefan Chulski <stefanc@marvell.com>

Patch adds CM3 address space and PPv2.3 description.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
Acked-by: Marcin Wojtas <mw@semihalf.com>
---
 Documentation/devicetree/bindings/net/marvell-pp2.txt | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/marvell-pp2.txt b/Documentation/devicetree/bindings/net/marvell-pp2.txt
index b783976..ce15c17 100644
--- a/Documentation/devicetree/bindings/net/marvell-pp2.txt
+++ b/Documentation/devicetree/bindings/net/marvell-pp2.txt
@@ -1,5 +1,6 @@
 * Marvell Armada 375 Ethernet Controller (PPv2.1)
   Marvell Armada 7K/8K Ethernet Controller (PPv2.2)
+  Marvell CN913X Ethernet Controller (PPv2.3)
 
 Required properties:
 
@@ -12,10 +13,11 @@ Required properties:
 	- common controller registers
 	- LMS registers
 	- one register area per Ethernet port
-  For "marvell,armada-7k-pp2", must contain the following register
+  For "marvell,armada-7k-pp2" used by 7K/8K and CN913X, must contain the following register
   sets:
 	- packet processor registers
 	- networking interfaces registers
+	- CM3 address space used for TX Flow Control
 
 - clocks: pointers to the reference clocks for this device, consequently:
 	- main controller clock (for both armada-375-pp2 and armada-7k-pp2)
@@ -81,7 +83,7 @@ Example for marvell,armada-7k-pp2:
 
 cpm_ethernet: ethernet@0 {
 	compatible = "marvell,armada-7k-pp22";
-	reg = <0x0 0x100000>, <0x129000 0xb000>;
+	reg = <0x0 0x100000>, <0x129000 0xb000>, <0x220000 0x800>;
 	clocks = <&cpm_syscon0 1 3>, <&cpm_syscon0 1 9>,
 		 <&cpm_syscon0 1 5>, <&cpm_syscon0 1 6>, <&cpm_syscon0 1 18>;
 	clock-names = "pp_clk", "gop_clk", "mg_clk", "mg_core_clk", "axi_clk";
-- 
1.9.1

