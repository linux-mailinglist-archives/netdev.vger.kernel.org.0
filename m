Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F798314A98
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 09:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhBIIoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 03:44:17 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55670 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230010AbhBIInz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 03:43:55 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1198a67m003792;
        Tue, 9 Feb 2021 00:43:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=gydshgIQ+ZkNNgRnhgR/amHg+u+odtq9xNAUJtzy0AM=;
 b=UO8VRF8Vq2o06xqUtwYclBljkqk2FVxCM64c2Xnj60YoCUm1jZj8zkNKcrTTAaw2SUYI
 yP5DdyZWbl9AbjxpMVirrpzZUutZyUvc+l0T+P6td9AZKJQrSbKZuP3ceH723VJ5q5EZ
 Ck7u6jfS2NCpWVykwPSnRKytLxTcEdxrz8aS8ehGA6Un380Jx9weRtLfThP0xcTstx1c
 1CXTTzWEpRdmo2gvXCSr1mJ58jTv1qv7DBWqdVzxiaALX/4eiMyzpxNQUhZt9kF9cNM9
 65vS+mDwukCAb8YxdrohfDKs4MVSHsp5Tizj2ANAMithKyakx+802PWxj+5o9ui5VUEH TA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbrfspy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 00:43:03 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Feb
 2021 00:43:01 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 9 Feb 2021 00:43:01 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id D65873F703F;
        Tue,  9 Feb 2021 00:42:57 -0800 (PST)
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
Subject: [PATCH v11 net-next 01/15] doc: marvell: add CM3 address space and PPv2.3 description
Date:   Tue, 9 Feb 2021 10:42:17 +0200
Message-ID: <1612860151-12275-2-git-send-email-stefanc@marvell.com>
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

From: Stefan Chulski <stefanc@marvell.com>

Patch adds CM3 address space and PPv2.3 description.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
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

