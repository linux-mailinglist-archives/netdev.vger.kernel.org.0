Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E46C34B562
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 09:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbhC0IOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 04:14:48 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15006 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbhC0IOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 04:14:33 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F6s4n0VN5zPvZ6;
        Sat, 27 Mar 2021 16:11:53 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Sat, 27 Mar 2021 16:14:19 +0800
From:   Xiongfeng Wang <wangxiongfeng2@huawei.com>
To:     <dsahern@kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <wangxiongfeng2@huawei.com>
Subject: [PATCH 1/9] l3mdev: Correct function names in the kerneldoc comments
Date:   Sat, 27 Mar 2021 16:15:48 +0800
Message-ID: <20210327081556.113140-2-wangxiongfeng2@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210327081556.113140-1-wangxiongfeng2@huawei.com>
References: <20210327081556.113140-1-wangxiongfeng2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following W=1 kernel build warning(s):

 net/l3mdev/l3mdev.c:111: warning: expecting prototype for l3mdev_master_ifindex(). Prototype was for l3mdev_master_ifindex_rcu() instead
 net/l3mdev/l3mdev.c:145: warning: expecting prototype for l3mdev_master_upper_ifindex_by_index(). Prototype was for l3mdev_master_upper_ifindex_by_index_rcu() instead

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
---
 net/l3mdev/l3mdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/l3mdev/l3mdev.c b/net/l3mdev/l3mdev.c
index ad7730b68772..17927966abb3 100644
--- a/net/l3mdev/l3mdev.c
+++ b/net/l3mdev/l3mdev.c
@@ -103,7 +103,7 @@ int l3mdev_ifindex_lookup_by_table_id(enum l3mdev_type l3type,
 EXPORT_SYMBOL_GPL(l3mdev_ifindex_lookup_by_table_id);
 
 /**
- *	l3mdev_master_ifindex - get index of L3 master device
+ *	l3mdev_master_ifindex_rcu - get index of L3 master device
  *	@dev: targeted interface
  */
 
@@ -136,7 +136,7 @@ int l3mdev_master_ifindex_rcu(const struct net_device *dev)
 EXPORT_SYMBOL_GPL(l3mdev_master_ifindex_rcu);
 
 /**
- *	l3mdev_master_upper_ifindex_by_index - get index of upper l3 master
+ *	l3mdev_master_upper_ifindex_by_index_rcu - get index of upper l3 master
  *					       device
  *	@net: network namespace for device index lookup
  *	@ifindex: targeted interface
-- 
2.20.1

