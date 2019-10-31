Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4F5EAB1A
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 08:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbfJaHuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 03:50:00 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52590 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfJaHuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 03:50:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9V7nS7S005955;
        Thu, 31 Oct 2019 07:49:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=Yiz8xWkE59Ebiz6cJJL8S+Rlio/Ca1vv1Vy9Fuvwwro=;
 b=hfW3zcOsNbxz5+cnsfR9GVzh6Mcu7RV2zU/WFjtHSBXyvAU+B56+H2fsJTuE7gP6B9n4
 s07jKEiOZhs5KhFzeUF3p95wdpfTqberQoamQVQbSZhk+by/53pwOcIbQPdvn3CG9DKi
 4vJg3DnpPmzkIcQxa1ruWOPSwpXB4o6RyfZTO9O9D3tzsaLgAmmRb8FKmoHoC8IE8rKf
 X/9HYpoZXDa4AwQ2SU7tlC+uN/mEJypt+d7LhLm4C/1sbfBvFki/DKRbEooSNjgStrLg
 vYpDXmNSQCZYtSNg5gVPJmnz5UnmhdgBSGqIZ+VCOXi9SPhCUZZWSS1UUFBd5NiLLzaL cw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2vxwhfsc4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Oct 2019 07:49:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9V7nAHw070013;
        Thu, 31 Oct 2019 07:49:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2vysbtp756-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Oct 2019 07:49:44 +0000
Received: from abhmp0021.oracle.com (abhmp0021.oracle.com [141.146.116.27])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9V7nhAO023978;
        Thu, 31 Oct 2019 07:49:43 GMT
Received: from host5.lan (/77.138.183.59)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Oct 2019 00:49:43 -0700
From:   Yuval Shaia <yuval.shaia@oracle.com>
To:     tariqt@mellanox.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, dotanb@dev.mellanox.co.il,
        eli@mellanox.co.il, vlad@mellanox.com
Cc:     Yuval Shaia <yuval.shaia@oracle.com>
Subject: [PATCH] mlx4_core: fix wrong comment about the reason of subtract one from the max_cqes
Date:   Thu, 31 Oct 2019 09:49:31 +0200
Message-Id: <20191031074931.20715-1-yuval.shaia@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9426 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=882
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910310078
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9426 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=969 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910310078
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dotan Barak <dotanb@dev.mellanox.co.il>

Signed-off-by: Dotan Barak <dotanb@dev.mellanox.co.il>
Signed-off-by: Eli Cohen <eli@mellanox.co.il>
Signed-off-by: Vladimir Sokolovsky <vlad@mellanox.com>
Signed-off-by: Yuval Shaia <yuval.shaia@oracle.com>
---
 drivers/net/ethernet/mellanox/mlx4/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index fce9b3a24347..dcf6b4628c58 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -514,8 +514,7 @@ static int mlx4_dev_cap(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 	dev->caps.max_rq_desc_sz     = dev_cap->max_rq_desc_sz;
 	/*
 	 * Subtract 1 from the limit because we need to allocate a
-	 * spare CQE so the HCA HW can tell the difference between an
-	 * empty CQ and a full CQ.
+	 * spare CQE to enable resizing the CQ
 	 */
 	dev->caps.max_cqes	     = dev_cap->max_cq_sz - 1;
 	dev->caps.reserved_cqs	     = dev_cap->reserved_cqs;
-- 
2.20.1

