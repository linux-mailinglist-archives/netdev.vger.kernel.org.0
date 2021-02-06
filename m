Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448AE311EBE
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 17:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbhBFQrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 11:47:23 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:19762 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230294AbhBFQrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 11:47:09 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 116GkCvP024398;
        Sat, 6 Feb 2021 08:46:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=OoXwOnHWd0GaVx0sTAIBGHb9igdf2sD7e9mI0hp+01I=;
 b=flJ7BA9afq1i32pSgYGQnuU3VdP2gy690druGQ2koLlFhcsjPjYsz7uzI6cQMXLEQt8T
 NdS06/hoKDKEXoNmF5LfLm7ywLSqqTE+vMJhKwqwihON1G58hxQBX+K50ewH67TlWssH
 Gr/VuK2UVol8PIxeUoZARQhsJczSZjoFO+RyzLMXqtcZqgJJ1aVzTcxbz2vFlmrZaDkd
 nJUBet0odTmyQqxT1OmdWO9c3JHRCIy/C+1mUrHf5DxA2Geq5Ef6RR0/uw8QI/e6JQ3Q
 7hT7f6M3UoVe5jbdnUfO3sT0UnZTP1jR6FH4yg29DS4xmJf3m+TuSz/eQ9bwtuaJDgBs 1A== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugq09wf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 06 Feb 2021 08:46:21 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 6 Feb
 2021 08:46:19 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 6 Feb 2021 08:46:19 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 63AA83F7050;
        Sat,  6 Feb 2021 08:46:16 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v8 net-next 01/15] doc: marvell: add cm3-mem and PPv2.3 description
Date:   Sat, 6 Feb 2021 18:45:47 +0200
Message-ID: <1612629961-11583-2-git-send-email-stefanc@marvell.com>
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

