Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65D2912E7F
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 14:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbfECMvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 08:51:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33486 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727365AbfECMvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 08:51:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x43CiUU7123808;
        Fri, 3 May 2019 12:51:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2018-07-02; bh=2G3+knudik998BX57KRVJhtFszU4RCr5pw8WFXkmQJ0=;
 b=JAC4P8XLkBG1ZIUP/1tXwCVcDXLLftdyy2qy+CWsMMY6OKAoZ0a9+AR1RCpIXnw0ScOn
 LB4xEgvrzCmN0r7vcGtXmaE0+mvDSf1DrH2tcgF5U+9F/GtZXL3j5HAfnlx3rOAP11tc
 BVip/xsB3WiFqu+BEp12sEXjxn0qTLRRtdqlwMYq4KOWUhOBk5KYPTOzTs31EGGsuqP2
 uUxAcP4NESoi5XCSNSSV5INhE1IYaHohprqaBoh9fVX3ZXDD1u6U86svywRXkvaJ3qIT
 hePCPmWwDZ8vPOk2SjnU+4XAiI22YJGg/DPkMd7riqAledwVRYi/PgnVQ32RAYGksLC1 HQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2s6xhyxgbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 May 2019 12:51:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x43ConC6110854;
        Fri, 3 May 2019 12:51:00 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2s7rtc91ag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 May 2019 12:51:00 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x43CoxY9021678;
        Fri, 3 May 2019 12:50:59 GMT
Received: from mwanda (/196.104.111.181)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 May 2019 05:50:58 -0700
Date:   Fri, 3 May 2019 15:50:51 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Esben Haabendal <esben@geanix.com>
Cc:     Michal Simek <michal.simek@xilinx.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2 net-next] net: ll_temac: remove an unnecessary condition
Message-ID: <20190503125051.GG29695@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190503125024.GF29695@mwanda>
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9245 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905030080
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9245 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905030080
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "pdata->mdio_bus_id" is unsigned so this condition is always true.
This patch just removes it.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/xilinx/ll_temac_mdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_mdio.c b/drivers/net/ethernet/xilinx/ll_temac_mdio.c
index c2a11703bc6d..a4667326f745 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_mdio.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_mdio.c
@@ -99,7 +99,7 @@ int temac_mdio_setup(struct temac_local *lp, struct platform_device *pdev)
 		of_address_to_resource(np, 0, &res);
 		snprintf(bus->id, MII_BUS_ID_SIZE, "%.8llx",
 			 (unsigned long long)res.start);
-	} else if (pdata && pdata->mdio_bus_id >= 0) {
+	} else if (pdata) {
 		snprintf(bus->id, MII_BUS_ID_SIZE, "%.8llx",
 			 pdata->mdio_bus_id);
 	}
-- 
2.18.0

