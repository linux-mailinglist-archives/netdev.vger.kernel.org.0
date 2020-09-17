Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E277026D10E
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 04:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbgIQCT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 22:19:29 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:49652 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725267AbgIQCT1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 22:19:27 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C3E6F57BA7866E7F09C0;
        Thu, 17 Sep 2020 10:19:23 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Thu, 17 Sep 2020
 10:19:16 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <saeed@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH v2 net-next] netdev: Remove unused functions
Date:   Thu, 17 Sep 2020 10:19:10 +0800
Message-ID: <20200917021910.41448-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
In-Reply-To: <20200916141814.7376-1-yuehaibing@huawei.com>
References: <20200916141814.7376-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no callers in tree, so can remove it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
---
v2: fix title typo 'funtions' --> 'functions'
---
 include/linux/netdevice.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 157e0242e9ee..909b1fbb0481 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4677,16 +4677,6 @@ int netdev_class_create_file_ns(const struct class_attribute *class_attr,
 void netdev_class_remove_file_ns(const struct class_attribute *class_attr,
 				 const void *ns);
 
-static inline int netdev_class_create_file(const struct class_attribute *class_attr)
-{
-	return netdev_class_create_file_ns(class_attr, NULL);
-}
-
-static inline void netdev_class_remove_file(const struct class_attribute *class_attr)
-{
-	netdev_class_remove_file_ns(class_attr, NULL);
-}
-
 extern const struct kobj_ns_type_operations net_ns_type_operations;
 
 const char *netdev_drivername(const struct net_device *dev);
-- 
2.17.1

