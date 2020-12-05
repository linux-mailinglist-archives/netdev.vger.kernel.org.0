Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFFB92CFC30
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 17:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbgLEQxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 11:53:41 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37368 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726648AbgLEQqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 11:46:34 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B5GauB9018218;
        Sat, 5 Dec 2020 08:45:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=tBRT7kliRoeg5z+j5fHKV8Hi8Ljt/pTuRDsFXYBb5Xo=;
 b=Do+OMrSFGZKUCb855JrFIaBjAAsZibrR8wxLgR9FSn7XwOYhzzR4gYRXpud7P9h68QT9
 Nj2S2cD85saTidkjg+kmc/1qXEcUmzGhwYqc803h1vTy3vED/QBRnRb4TU8rO7q0FzVO
 2Ft0gJVFAWBLBD0p/JMBB7gKrvVrY+jsoA7ePjqF+E2MSFH+zNFFSTTMBF7EP/AK7K45
 s6Bj7aV9Igz6YxE6lFrxx2xWwBx26+/AQ0eRpUF2K/fdNWdE/MYgPjPii8uAUMrsoBVq
 EaLa1HtIktXt0k6L3Jvwe2zR91QCVo/0nZQcm3MkAgB2VCrwLMUA7KPWwqWf4qqumHh8 gg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 358akr0881-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 05 Dec 2020 08:45:45 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 5 Dec
 2020 08:45:44 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 5 Dec
 2020 08:45:44 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 5 Dec 2020 08:45:44 -0800
Received: from jupiter064.il.marvell.com (unknown [10.5.116.100])
        by maili.marvell.com (Postfix) with ESMTP id 827E33F7040;
        Sat,  5 Dec 2020 08:45:42 -0800 (PST)
From:   Mickey Rachamim <mickeyr@marvell.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: [PATCH v2] MAINTAINERS: Add entry for Marvell Prestera Ethernet Switch driver
Date:   Sat, 5 Dec 2020 18:43:00 +0200
Message-ID: <20201205164300.28581-1-mickeyr@marvell.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-05_12:2020-12-04,2020-12-05 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add maintainers info for new Marvell Prestera Ethernet switch driver.

Signed-off-by: Mickey Rachamim <mickeyr@marvell.com>
---
v2:
 Update the maintainers list according to community recommendation.

 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 061e64b2423a..c92b44754436 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10550,6 +10550,14 @@ S:	Supported
 F:	Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
 F:	drivers/net/ethernet/marvell/octeontx2/af/
 
+MARVELL PRESTERA ETHERNET SWITCH DRIVER
+M:	Vadym Kochan <vkochan@marvell.com>
+M:	Taras Chornyi <tchornyi@marvell.com>
+L:	netdev@vger.kernel.org
+S:	Supported
+W:	http://www.marvell.com
+F:	drivers/net/ethernet/marvell/prestera/
+
 MARVELL SOC MMC/SD/SDIO CONTROLLER DRIVER
 M:	Nicolas Pitre <nico@fluxnic.net>
 S:	Odd Fixes
-- 
2.29.2

