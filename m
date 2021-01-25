Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B93B13049A4
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732730AbhAZF0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:26:40 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:54198 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729157AbhAYRMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 12:12:20 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10PGpb7n012912;
        Mon, 25 Jan 2021 09:09:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Ve3lx0NYRS8hskaMsrlh4Bg04eUBEDqkOqO5VY0l3QQ=;
 b=F9y1FJGt31zfe+U0ZTsbL6ubUw80OZRhF6s/hoPuZmNICXRoIhET8godgf71iqmI8yRj
 VkaTeLHOK4jtbYHPG1XfCPHJkNj9A1GYQPndXl13YlIONGlERPAKWM2V1vbXawWVUOH9
 DEHJ/ZO3QBXrSFYGmGUX5Yypp27k3bcoPrHlow0CH0+/4lmFD+6LjCQk6L345+gD9T3I
 dJu69dRrfBFzDfcrAyu2V7mvTbZQId0gF3Ky5PVSvRSvRGAHLX/zN4GdRorYpPXm1og6
 QjC16NJleHbGWYUsLuq915fUagJqZpWJ0fd4OjW8UoRizco6uYYaRAyd43V44flkCsGa kQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 368m6ud2bt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 25 Jan 2021 09:09:23 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 25 Jan
 2021 09:09:21 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 25 Jan
 2021 09:09:20 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 25 Jan 2021 09:09:20 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id D08C73F7044;
        Mon, 25 Jan 2021 09:09:17 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH v3 RFC net-next 01/19] doc: marvell: add cm3-mem device tree bindings description
Date:   Mon, 25 Jan 2021 19:07:48 +0200
Message-ID: <1611594486-29431-2-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1611594486-29431-1-git-send-email-stefanc@marvell.com>
References: <1611594486-29431-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-25_07:2021-01-25,2021-01-25 signatures=0
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

