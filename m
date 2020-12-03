Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53DA22CD330
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 11:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388585AbgLCKIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 05:08:04 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:5334 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726082AbgLCKIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 05:08:04 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B3A6kuw014252;
        Thu, 3 Dec 2020 02:07:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=YyR69L4hu/oRHcKWIfHtQbXQeGzFY2FBPwiZ5EB419k=;
 b=XE7CTYU1j3sNxRkS5Uj7xS7+KjgGpaECtKM5ePwhHdUCnnFdQNJsY14nXpPi/iS6e4IT
 +nTwB+hgeR4MDUdCart8aFLqEnf/FMaRDBeEsjrttUtm4vAcksk4aIUqONA7G7R0vuwG
 5w26W+Cw401190sW9FWP0dGr+tJqyZ7MgYpxWZupP37jbv/IRMux78U2nZAkCBVFFphM
 SjR5qiXpIAJqvdYg3EVikk8Cgs+t+MajYUawZIglUQbcRr+gxYS5/NIvtoZ8ra+eHhNH
 DKk6TuAZPckW+ut80cxtN1/F6sdQuIoUaJyZRr/TTsuZS/ExiZjiwp6OkmiHViA1pLTj KQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 355w50d9gj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 02:07:19 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Dec
 2020 02:07:18 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Dec 2020 02:07:18 -0800
Received: from jupiter064.il.marvell.com (unknown [10.5.116.100])
        by maili.marvell.com (Postfix) with ESMTP id 071BC3F703F;
        Thu,  3 Dec 2020 02:07:16 -0800 (PST)
From:   Mickey Rachamim <mickeyr@marvell.com>
To:     "David S . Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: [PATCH] MAINTAINERS: Add entry for Marvell Prestera Ethernet Switch driver
Date:   Thu, 3 Dec 2020 12:04:36 +0200
Message-ID: <20201203100436.25630-1-mickeyr@marvell.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_06:2020-12-03,2020-12-03 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add maintainers info for new Marvell Prestera Ethernet switch driver.

Signed-off-by: Mickey Rachamim <mickeyr@marvell.com>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a7bdebf955bb..04a27eb89428 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10540,6 +10540,15 @@ S:	Supported
 F:	Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
 F:	drivers/net/ethernet/marvell/octeontx2/af/
 
+MARVELL PRESTERA ETHERNET SWITCH DRIVER
+M:	Vadym Kochan <vkochan@marvell.com>
+M:	Taras Chornyi <tchornyi@marvell.com>
+M:	Mickey Rachamim <mickeyr@marvell.com>
+L:	netdev@vger.kernel.org
+S:	Supported
+W:	http://www.marvell.com
+F:	drivers/net/ethernet/marvell/prestera/
+
 MARVELL SOC MMC/SD/SDIO CONTROLLER DRIVER
 M:	Nicolas Pitre <nico@fluxnic.net>
 S:	Odd Fixes
-- 
2.17.1

