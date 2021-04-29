Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22B336E955
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 13:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240520AbhD2LHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 07:07:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36016 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237051AbhD2LHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 07:07:05 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13TB5TPe065867;
        Thu, 29 Apr 2021 11:06:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=K15i1CGSnbguzBLfka7Fkv1c34A1bayqQF0r+BTLl1Y=;
 b=IN1+r6yIHsRQ3uvdp873Jp+ayYaa+t/FxxY1o2Kus51dIwYC8PV7CHsoaKAIN9V1jPV/
 8D//K/exsHlfs7GWDci6cswqay6t/akU7uYeMBx1/O5jSQ11/OJZ3dviJbr1o2n8zDOp
 A0usEETT5mH7KtihOVhEgD385lIrrX4wb5OsL6qtM/SeSOWDmiPcKvEH5BuL/bwNb7Is
 7IrhOKIC19LULBBMGQ1mG+D33NCkbfp2s8afvGvsSbKPNcRLeyWMStFuhEzDcIcRBQMK
 em38rpO0BjIPHgwpWEKB+F0H/v2BvMmVwEPv2+ubX14kmSTtWbOk7sijbzw46wNuVWBD iA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 385aft3y57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 11:06:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13TB4reK117731;
        Thu, 29 Apr 2021 11:06:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3848f0wgxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 11:06:13 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 13TB6Cwg122571;
        Thu, 29 Apr 2021 11:06:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3848f0wgxc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 11:06:12 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 13TB6BkG008790;
        Thu, 29 Apr 2021 11:06:11 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Apr 2021 04:06:10 -0700
Date:   Thu, 29 Apr 2021 14:06:04 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <dddavem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH v2 net-next] net/mlx5: net/mlx5: Fix some error messages
Message-ID: <YIqTHAq37U57ehAa@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-GUID: vR0WlVqWOshguFLTJbxxxJQJCFtwYnFm
X-Proofpoint-ORIG-GUID: vR0WlVqWOshguFLTJbxxxJQJCFtwYnFm
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9968 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1011 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104290075
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This code was using IS_ERR() instead of PTR_ERR() so it prints 1 instead
of the correct error code.  Even better would be to use %pe which prints
out the name of the error, as in "ENOMEM", "EINVAL" etc.

Fixes: 25cb31768042 ("net/mlx5: E-Switch, Improve error messages in term table creation")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2:  Use %pe instead of %ld.

Leon says this goes through netdev instead of the RDMA tree.

 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c    | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index a81ece94f599..a0efb19bf285 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -83,16 +83,16 @@ mlx5_eswitch_termtbl_create(struct mlx5_core_dev *dev,
 	ft_attr.autogroup.max_num_groups = 1;
 	tt->termtbl = mlx5_create_auto_grouped_flow_table(root_ns, &ft_attr);
 	if (IS_ERR(tt->termtbl)) {
-		esw_warn(dev, "Failed to create termination table (error %d)\n",
-			 IS_ERR(tt->termtbl));
+		esw_warn(dev, "Failed to create termination table (error %pe)\n",
+			 tt->termtbl);
 		return -EOPNOTSUPP;
 	}
 
 	tt->rule = mlx5_add_flow_rules(tt->termtbl, NULL, flow_act,
 				       &tt->dest, 1);
 	if (IS_ERR(tt->rule)) {
-		esw_warn(dev, "Failed to create termination table rule (error %d)\n",
-			 IS_ERR(tt->rule));
+		esw_warn(dev, "Failed to create termination table rule (error %pe)\n",
+			 tt->rule);
 		goto add_flow_err;
 	}
 	return 0;
@@ -283,8 +283,8 @@ mlx5_eswitch_add_termtbl_rule(struct mlx5_eswitch *esw,
 		tt = mlx5_eswitch_termtbl_get_create(esw, &term_tbl_act,
 						     &dest[i], attr);
 		if (IS_ERR(tt)) {
-			esw_warn(esw->dev, "Failed to get termination table (error %d)\n",
-				 IS_ERR(tt));
+			esw_warn(esw->dev, "Failed to get termination table (error %pe)\n",
+				 tt);
 			goto revert_changes;
 		}
 		attr->dests[num_vport_dests].termtbl = tt;
-- 
2.30.2

