Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB852307E16
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 19:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbhA1Sfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 13:35:39 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:21192 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232034AbhA1Sef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 13:34:35 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10SI6KAA011207;
        Thu, 28 Jan 2021 10:31:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=YccNla7+MM6+0y0+HkOTLVpcXPupLVKj6UvrIorxUl0=;
 b=jggNVQKW2AEPhWamfQOgRe+T+pBMM+hsL17izKzF+CBRh7C8kDyAmTS32PjcJxLou7eR
 tgCKhgHXLlyZ8eT6fuIMeLx2BzX3B8qaFkv7sJwEJbWJRPyVyroPDL3x5Isk9R9wvQe5
 ZZhPXMDp00F2sgAxu/hvxhVj0Y3eqTMLvvM6MNnl5xWIQku0VGzOj2hdm6DKcDWTjf/V
 1Qf6NWgeahddQ8Qd9n6dwkDkeI+LSPiAqhiuozgRFY2AoDOTKv17v0o85BoDE7HsVT3n
 NMiZVZJo3a1ARNO1XSk2SMOcGy2XkSEwG7OqkNFe0enOQgp7jW76KkU/4Abs+AzksaWu 3g== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36b1xpncpr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 28 Jan 2021 10:31:47 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 28 Jan
 2021 10:31:45 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 28 Jan
 2021 10:31:44 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 28 Jan 2021 10:31:45 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 1785C3F703F;
        Thu, 28 Jan 2021 10:31:41 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v5 net-next 04/18] doc: marvell: add PPv2.3 description to marvell-pp2.txt
Date:   Thu, 28 Jan 2021 20:31:08 +0200
Message-ID: <1611858682-9845-5-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1611858682-9845-1-git-send-email-stefanc@marvell.com>
References: <1611858682-9845-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-28_12:2021-01-28,2021-01-28 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 Documentation/devicetree/bindings/net/marvell-pp2.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/marvell-pp2.txt b/Documentation/devicetree/bindings/net/marvell-pp2.txt
index f9f8cc6..df80cff 100644
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
-- 
1.9.1

