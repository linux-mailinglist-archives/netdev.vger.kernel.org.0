Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5501C305A57
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 12:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237099AbhA0LtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 06:49:09 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50338 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237069AbhA0Lqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 06:46:44 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10RBe57x000858;
        Wed, 27 Jan 2021 03:43:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Ve3lx0NYRS8hskaMsrlh4Bg04eUBEDqkOqO5VY0l3QQ=;
 b=J13IE2I7VRNTCA2ZNJcewFQp2ohIFfBZ9P4NQ0UapItNZLuREx505WWdda/D/MdNWEdX
 ao+RROjJlOvKKOIKX5gfVPRbHuUgR0b0y1zPGg4zaZSiR9LSUx7U+HusClHoSrRkQU/H
 qVx23QMWL/o2+36vPbq/R5KFbH1+fOegKkk+0dGGrKYmM+n4AdQoFN0lZA5ijvWs5Xr4
 73+HgE3ot8tABWJsevtMSvBWTeVy7bde8KoxOKx4UH+W/9+GIEYjLaOP2R55nkiko0L9
 HvUdH4M/BhYW3HWZiAM2h2H4gBDEcsfCmkmCNRyd3nS8MLp9QRpxAjhrmp9jeBD+/d7Y RA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 368j1ube76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 27 Jan 2021 03:43:55 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 27 Jan
 2021 03:43:50 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 27 Jan 2021 03:43:50 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 2A3963F7040;
        Wed, 27 Jan 2021 03:43:46 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v4 net-next 01/19] doc: marvell: add cm3-mem device tree bindings description
Date:   Wed, 27 Jan 2021 13:43:17 +0200
Message-ID: <1611747815-1934-2-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1611747815-1934-1-git-send-email-stefanc@marvell.com>
References: <1611747815-1934-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-27_05:2021-01-27,2021-01-27 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 Documentation/devicetree/bindings/net/marvell-pp2.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/marvell-pp2.txt b/Documentation/devicetree/bindings/net/marvell-pp2.txt
index b783976..f9f8cc6 100644
--- a/Documentation/devicetree/bindings/net/marvell-pp2.txt
+++ b/Documentation/devicetree/bindings/net/marvell-pp2.txt
@@ -37,6 +37,7 @@ Required properties (port):
   GOP (Group Of Ports) point of view. This ID is used to index the
   per-port registers in the second register area.
 - phy-mode: See ethernet.txt file in the same directory
+- cm3-mem: phandle to CM3 SRAM definitions
 
 Optional properties (port):
 
-- 
1.9.1

