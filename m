Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974CF3A10BB
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238509AbhFIJ6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 05:58:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59816 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235816AbhFIJ6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 05:58:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1599pYGk070268;
        Wed, 9 Jun 2021 09:56:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=8efO7ufX7MrjDhIhmhqa+bTyVhR2yMn9f78EGTIFgEw=;
 b=ImNnWMKXHK//tKzadGYOjWzvnCLUJSYjulsgpM2ImBVGhD6vra25wXM5wThPpLdIETx1
 A/zqhewvzdgcE7tk+2Gl5o2JxijytSJA2leZnerHopuvHG8/q7tjYnO/M1f0CLSzdLQM
 7M2QE30ouRCbocEPdsNsUc2qAV/R601ly1ABSZJ3Pr6LxuG2OSAkjuw92P/dVXG6COU7
 c9PVPManN7iZ+qf1cKP2cAxdcEVSEQXy1PKgUmV+Ucm49UNBUC2wkC/UG8xMclaHmpF9
 WzzVB2V+YBwdGA8NyPmslheCwYSd7NCFGZJcJE7lvbYXHy1zoBv64mB7OdXm8jUWP/GW 4Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 3914quq5fn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 09:56:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1599t5mC186163;
        Wed, 9 Jun 2021 09:56:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 390k1rspye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 09:56:55 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1599usjs188866;
        Wed, 9 Jun 2021 09:56:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 390k1rspy7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 09:56:54 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 1599urs8017848;
        Wed, 9 Jun 2021 09:56:53 GMT
Received: from mwanda (/41.212.42.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Jun 2021 02:56:53 -0700
Date:   Wed, 9 Jun 2021 12:56:45 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>, Vlad Buslov <vladbu@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next] netdevsim: delete unnecessary debugfs checking
Message-ID: <YMCQXQx4kHdk7Whx@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-ORIG-GUID: umWlKwLxJeHg1qBqCo7IjqDRifFPsF6f
X-Proofpoint-GUID: umWlKwLxJeHg1qBqCo7IjqDRifFPsF6f
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 spamscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106090046
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In normal situations where the driver doesn't dereference
"nsim_node->ddir" or "nsim_node->rate_parent" itself then we are not
supposed to check the return from debugfs functions.  In the case of
debugfs_create_dir() the check was wrong as well because it doesn't
return NULL, it returns error pointers.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/netdevsim/dev.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 527b019ae0b2..6f4bc70049d2 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1141,7 +1141,6 @@ static int nsim_rate_node_new(struct devlink_rate *node, void **priv,
 {
 	struct nsim_dev *nsim_dev = devlink_priv(node->devlink);
 	struct nsim_rate_node *nsim_node;
-	int err;
 
 	if (!nsim_esw_mode_is_switchdev(nsim_dev)) {
 		NL_SET_ERR_MSG_MOD(extack, "Node creation allowed only in switchdev mode.");
@@ -1153,29 +1152,16 @@ static int nsim_rate_node_new(struct devlink_rate *node, void **priv,
 		return -ENOMEM;
 
 	nsim_node->ddir = debugfs_create_dir(node->name, nsim_dev->nodes_ddir);
-	if (!nsim_node->ddir) {
-		err = -ENOMEM;
-		goto err_node;
-	}
+
 	debugfs_create_u16("tx_share", 0400, nsim_node->ddir, &nsim_node->tx_share);
 	debugfs_create_u16("tx_max", 0400, nsim_node->ddir, &nsim_node->tx_max);
 	nsim_node->rate_parent = debugfs_create_file("rate_parent", 0400,
 						     nsim_node->ddir,
 						     &nsim_node->parent_name,
 						     &nsim_dev_rate_parent_fops);
-	if (IS_ERR(nsim_node->rate_parent)) {
-		err = PTR_ERR(nsim_node->rate_parent);
-		goto err_ddir;
-	}
 
 	*priv = nsim_node;
 	return 0;
-
-err_ddir:
-	debugfs_remove_recursive(nsim_node->ddir);
-err_node:
-	kfree(nsim_node);
-	return err;
 }
 
 static int nsim_rate_node_del(struct devlink_rate *node, void *priv,
-- 
2.30.2

