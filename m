Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBAE101A8B
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 08:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfKSHyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 02:54:11 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35520 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfKSHyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 02:54:11 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJ7rsp9033794;
        Tue, 19 Nov 2019 07:53:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2019-08-05;
 bh=IyCiBE5FqGw0GPcIHmU7QGVoSGyMN7SqqTP1wqihQRo=;
 b=GOgXevtc2/R5pg/O4/aIHosMydLGb31489wC/o0L+0RAAtoSbW9KasR+3jol/TGg2DWj
 YYm3WaynA1ugeQmiB3WrR9O46wieuA8UPEwejgIpLEtbNA4CQd9nAw1zVbqOBGMMkmtJ
 GdnKmQlZxLNMjlVdhj3eNtqTpoAU4DbfCG854A+Nl5haDKXxxZfDZa/BXJMZnBdOGrWF
 ESbIRH7b9iwAWoBWVMflYime/k5LN+oC5ZCF63C07HLrva5a8FA3xMDIfTYp0EXdP8PG
 X6inrZKcewuw5EuvlO+5okj7Iu8+XSlLtPGURT3ltaidIvkmQVe4NRja9Q8sykfLC2fR Tw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2wa92pn24c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 07:53:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJ7rnqe063648;
        Tue, 19 Nov 2019 07:53:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2wc0afxk2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 07:53:56 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAJ7rt05016094;
        Tue, 19 Nov 2019 07:53:55 GMT
Received: from shipfan.cn.oracle.com (/10.113.210.105)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 Nov 2019 23:53:54 -0800
From:   Zhu Yanjun <yanjun.zhu@oracle.com>
To:     mchehab+samsung@kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        robh@kernel.org, netdev@vger.kernel.org, yanjun.zhu@oracle.com,
        rain.1986.08.12@gmail.com
Subject: [PATCH 1/1] MAINTAINERS: forcedeth: Change Zhu Yanjun's email address
Date:   Tue, 19 Nov 2019 03:03:48 -0500
Message-Id: <1574150628-3905-1-git-send-email-yanjun.zhu@oracle.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=903
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911190073
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=988 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911190073
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I prefer to use my personal email address for kernel related work.

Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e4f170d..8165658 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -643,7 +643,7 @@ F:	drivers/net/ethernet/alacritech/*
 
 FORCEDETH GIGABIT ETHERNET DRIVER
 M:	Rain River <rain.1986.08.12@gmail.com>
-M:	Zhu Yanjun <yanjun.zhu@oracle.com>
+M:	Zhu Yanjun <zyjzyj2000@gmail.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/nvidia/*
-- 
2.7.4

