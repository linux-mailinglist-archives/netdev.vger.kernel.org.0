Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95A942BBA9
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 11:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237774AbhJMJeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 05:34:36 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:24306 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238986AbhJMJee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 05:34:34 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HTnJL28nmzYdv0;
        Wed, 13 Oct 2021 17:28:02 +0800 (CST)
Received: from dggpemm500002.china.huawei.com (7.185.36.229) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 13 Oct 2021 17:32:30 +0800
Received: from localhost.localdomain (10.175.112.125) by
 dggpemm500002.china.huawei.com (7.185.36.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 13 Oct 2021 17:32:29 +0800
From:   Chen Wandun <chenwandun@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <dsa@cumulusnetworks.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <wangkefeng.wang@huawei.com>
CC:     <chenwandun@huawei.com>
Subject: [PATCH] net: delete redundant function declaration
Date:   Wed, 13 Oct 2021 17:47:02 +0800
Message-ID: <20211013094702.3931071-1-chenwandun@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500002.china.huawei.com (7.185.36.229)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The implement of function netdev_all_upper_get_next_dev_rcu has been
removed in:
	commit f1170fd462c6 ("net: Remove all_adj_list and its references")
so delete redundant declaration in header file.

Fixes: f1170fd462c6 ("net: Remove all_adj_list and its references")
Signed-off-by: Chen Wandun <chenwandun@huawei.com>
---
 include/linux/netdevice.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 0723c1314ea2..b96b2a3762d1 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4801,8 +4801,6 @@ struct netdev_nested_priv {
 bool netdev_has_upper_dev(struct net_device *dev, struct net_device *upper_dev);
 struct net_device *netdev_upper_get_next_dev_rcu(struct net_device *dev,
 						     struct list_head **iter);
-struct net_device *netdev_all_upper_get_next_dev_rcu(struct net_device *dev,
-						     struct list_head **iter);
 
 #ifdef CONFIG_LOCKDEP
 static LIST_HEAD(net_unlink_list);
-- 
2.25.1

