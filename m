Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D24D2D438D
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 14:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732450AbgLINvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 08:51:18 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:49326 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726555AbgLINvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 08:51:17 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B9DepVN002450;
        Wed, 9 Dec 2020 05:50:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=VWFBleWfljYg00aV8tAaV6DyaEoX10N2C0RkC1EAKgk=;
 b=K9j2puGZaf0co1Iusph2OvTK+H1pN81yoNZC1YX/9ECuzb+PvcgbXlglVCFzZcqobRup
 IsHabXrEPibqVMBvD2HnZVDm+ZwACO2L8ZDp58zDI7MuL3H52czqKxeEQFnx4mY1Ecg3
 0UPD2Fycm4HBIy5y1pMyRKa4s5Yhym6rLAf4edem5kIYT9A/tzepfbz7JhjVT17nYY88
 Ll1zDM8JJ8oW7hxGtf+A5T1pNAy9/LKLdHpet3dcMH2WVNTzeitE9IKYh0UwMUgNPvW7
 /qk6ombkFuJfhS4qIZcUNZW29fR6jYZsOrAQxll7otiLxUbbhbxCAbSlgPOO5UByh1y0 OA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 358akrbfu7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 05:50:33 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 9 Dec
 2020 05:50:28 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 9 Dec
 2020 05:50:27 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 9 Dec 2020 05:50:27 -0800
Received: from jupiter064.il.marvell.com (unknown [10.5.116.100])
        by maili.marvell.com (Postfix) with ESMTP id C152E3F7045;
        Wed,  9 Dec 2020 05:50:25 -0800 (PST)
From:   Mickey Rachamim <mickeyr@marvell.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: [PATCH v3] MAINTAINERS: Add entry for Marvell Prestera Ethernet Switch driver
Date:   Wed, 9 Dec 2020 15:47:39 +0200
Message-ID: <20201209134739.28497-1-mickeyr@marvell.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_11:2020-12-09,2020-12-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add maintainers info for new Marvell Prestera Ethernet switch driver.

Signed-off-by: Mickey Rachamim <mickeyr@marvell.com>
---
1. Update +W to link to the project source github page.
2. Remove +L as inherited from the entry of networking drivers.

 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index f658b0465fe7..b42a9f8813ef 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10550,6 +10550,13 @@ S:	Supported
 F:	Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
 F:	drivers/net/ethernet/marvell/octeontx2/af/
 
+MARVELL PRESTERA ETHERNET SWITCH DRIVER
+M:	Vadym Kochan <vkochan@marvell.com>
+M:	Taras Chornyi <tchornyi@marvell.com>
+S:	Supported
+W:	https://github.com/Marvell-switching/switchdev-prestera
+F:	drivers/net/ethernet/marvell/prestera/
+
 MARVELL SOC MMC/SD/SDIO CONTROLLER DRIVER
 M:	Nicolas Pitre <nico@fluxnic.net>
 S:	Odd Fixes
-- 
2.29.2

