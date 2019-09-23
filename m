Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84929BB6F1
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 16:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438329AbfIWOif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 10:38:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41024 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437975AbfIWOie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 10:38:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8NET0lx112083;
        Mon, 23 Sep 2019 14:38:20 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2v5cgqq8q8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Sep 2019 14:38:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8NEbim1131175;
        Mon, 23 Sep 2019 14:38:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2v6yvn09kr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Sep 2019 14:38:19 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8NEcH7N015170;
        Mon, 23 Sep 2019 14:38:17 GMT
Received: from zhuyj-Latitude-E6220.lan (/1.202.62.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Sep 2019 07:38:16 -0700
From:   rain.1986.08.12@gmail.com
To:     yanjun.zhu@oracle.com, mchehab+samsung@kernel.org,
        davem@davemloft.net, gregkh@linuxfoundation.org, robh@kernel.org,
        linus.walleij@linaro.org, nicolas.ferre@microchip.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Rain River <rain.1986.08.12@gmail.com>
Subject: [PATCH 1/1] MAINTAINERS: add Yanjun to FORCEDETH maintainers list
Date:   Mon, 23 Sep 2019 22:37:46 +0800
Message-Id: <20190923143746.4310-1-rain.1986.08.12@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9389 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=916
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909230141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9389 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1034
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909230141
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rain River <rain.1986.08.12@gmail.com>

Yanjun has been spending quite a lot of time fixing bugs
in FORCEDETH source code. I'd like to add Yanjun to maintainers
list.

Signed-off-by: Rain River <rain.1986.08.12@gmail.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a400af0501c9..336ad8fe8b60 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -643,6 +643,7 @@ F:	drivers/net/ethernet/alacritech/*
 
 FORCEDETH GIGABIT ETHERNET DRIVER
 M:	Rain River <rain.1986.08.12@gmail.com>
+M:	Zhu Yanjun <yanjun.zhu@oracle.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/nvidia/*
-- 
2.17.1

