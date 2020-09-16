Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A93126C73D
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 20:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbgIPSVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 14:21:54 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:38904 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727924AbgIPSVQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 14:21:16 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 150247F7B54BA4DBD4F2;
        Wed, 16 Sep 2020 22:18:27 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Wed, 16 Sep 2020
 22:18:15 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] netdev: Remove unused funtions
Date:   Wed, 16 Sep 2020 22:18:14 +0800
Message-ID: <20200916141814.7376-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no callers in tree, so can remove it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
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

