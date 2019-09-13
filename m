Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD647B214D
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 15:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391197AbfIMNo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 09:44:29 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44306 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388489AbfIMNo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 09:44:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8DDiEI9169394;
        Fri, 13 Sep 2019 13:44:19 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2uytd3ms1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Sep 2019 13:44:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8DDhv5b028851;
        Fri, 13 Sep 2019 13:44:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2uytdwtpyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Sep 2019 13:44:18 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8DDi3pL032480;
        Fri, 13 Sep 2019 13:44:04 GMT
Received: from zhuyj-Latitude-E6220.lan (/124.126.211.68)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Sep 2019 06:44:03 -0700
From:   rain.1986.08.12@gmail.com
To:     mchehab+samsung@kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        rain.1986.08.12@gmail.com, netdev@vger.kernel.org
Subject: [PATCH 1/1] MAINTAINERS: update FORCEDETH MAINTAINERS info
Date:   Fri, 13 Sep 2019 21:43:45 +0800
Message-Id: <20190913134345.28318-1-rain.1986.08.12@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9378 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=817
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909130136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9378 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1034
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=887 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909130136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rain River <rain.1986.08.12@gmail.com>

Many FORCEDETH NICs are used in our hosts. Several bugs are fixed and
some features are developed for FORCEDETH NICs. And I have been
reviewing patches for FORCEDETH NIC for several months. Mark me as the
FORCEDETH NIC maintainer. I will send out the patches and maintain
FORCEDETH NIC.

Signed-off-by: Rain River <rain.1986.08.12@gmail.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e7a47b5210fd..0a28090df677 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -649,6 +649,12 @@ M:	Lino Sanfilippo <LinoSanfilippo@gmx.de>
 S:	Maintained
 F:	drivers/net/ethernet/alacritech/*
 
+FORCEDETH GIGABIT ETHERNET DRIVER
+M:	Rain River <rain.1986.08.12@gmail.com>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/net/ethernet/nvidia/*
+
 ALCATEL SPEEDTOUCH USB DRIVER
 M:	Duncan Sands <duncan.sands@free.fr>
 L:	linux-usb@vger.kernel.org
-- 
2.17.1

