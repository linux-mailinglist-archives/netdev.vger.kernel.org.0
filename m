Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADDC309D02
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 15:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbhAaOf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 09:35:58 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:17294 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231869AbhAaOfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 09:35:38 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10VEOt5R007921;
        Sun, 31 Jan 2021 06:34:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=OoXwOnHWd0GaVx0sTAIBGHb9igdf2sD7e9mI0hp+01I=;
 b=SFEZ97Uw4tmXI4Y0BSK/wp477qlxc9QHl+kINz2/ThYqTaLduYYmJADS3CKrXlDr2D9o
 3DQYgRzFQkdwaHOmPqgHd9yhIANYNjENIv4LLzDYMCNIcOkLanh27LxVL0UHxxW8L+4a
 Jk0fKRJ1FVkhhrHVArv0afM960om4N2IqDhpSu1izDqYxiHbZtxjEXcTitFgSRQYZweZ
 U+x78Q07aYxUam0othSrtQ/KfTnDplyGy380x+58HwZr8Q0t0nvdrGM4nE1efh70A8Aq
 tyBGEH1DmBUcVuXb9GIz+HaE4NQE5glMUzSmLCKsEvs3qrmszP4fEaIMs2zEFtjlSrhV QA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36d7uq1py1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 31 Jan 2021 06:34:47 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 31 Jan
 2021 06:34:46 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 31 Jan
 2021 06:34:45 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 31 Jan 2021 06:34:45 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 7D9AF3F703F;
        Sun, 31 Jan 2021 06:34:42 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v7 net-next 01/15] doc: marvell: add cm3-mem and PPv2.3 description
Date:   Sun, 31 Jan 2021 16:33:44 +0200
Message-ID: <1612103638-16108-2-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1612103638-16108-1-git-send-email-stefanc@marvell.com>
References: <1612103638-16108-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-01-31_04:2021-01-29,2021-01-31 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

Patch introduce cm3-mem device tree bindings and add PPv2.3 description.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 Documentation/devicetree/bindings/net/marvell-pp2.txt | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/marvell-pp2.txt b/Documentation/devicetree/bindings/net/marvell-pp2.txt
index b783976..df80cff 100644
--- a/Documentation/devicetree/bindings/net/marvell-pp2.txt
+++ b/Documentation/devicetree/bindings/net/marvell-pp2.txt
@@ -1,5 +1,6 @@
 * Marvell Armada 375 Ethernet Controller (PPv2.1)
   Marvell Armada 7K/8K Ethernet Controller (PPv2.2)
+  Marvell CN913X Ethernet Controller (PPv2.3)
 
 Required properties:
 
@@ -12,7 +13,7 @@ Required properties:
 	- common controller registers
 	- LMS registers
 	- one register area per Ethernet port
-  For "marvell,armada-7k-pp2", must contain the following register
+  For "marvell,armada-7k-pp2" used by 7K/8K and CN913X, must contain the following register
   sets:
 	- packet processor registers
 	- networking interfaces registers
@@ -37,6 +38,7 @@ Required properties (port):
   GOP (Group Of Ports) point of view. This ID is used to index the
   per-port registers in the second register area.
 - phy-mode: See ethernet.txt file in the same directory
+- cm3-mem: phandle to CM3 SRAM definitions
 
 Optional properties (port):
 
-- 
1.9.1

