Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5613A2A80
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 13:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbhFJLnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 07:43:50 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3832 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbhFJLnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 07:43:49 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G124p1VmtzWtC7;
        Thu, 10 Jun 2021 19:36:58 +0800 (CST)
Received: from dggpeml500020.china.huawei.com (7.185.36.88) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 19:41:51 +0800
Received: from huawei.com (10.175.127.227) by dggpeml500020.china.huawei.com
 (7.185.36.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 10 Jun
 2021 19:41:51 +0800
From:   Baokun Li <libaokun1@huawei.com>
To:     <idryomov@gmail.com>, <jlayton@kernel.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <ceph-devel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <yangjihong1@huawei.com>, <yukuai3@huawei.com>,
        <libaokun1@huawei.com>
Subject: [PATCH -next] libceph: fix doc warnings in cls_lock_client.c
Date:   Thu, 10 Jun 2021 19:50:58 +0800
Message-ID: <20210610115058.3779341-1-libaokun1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500020.china.huawei.com (7.185.36.88)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add description to fixes the following W=1 kernel build warning(s):

 net/ceph/cls_lock_client.c:28: warning: Function parameter or
  member 'osdc' not described in 'ceph_cls_lock'
 net/ceph/cls_lock_client.c:28: warning: Function parameter or
  member 'oid' not described in 'ceph_cls_lock'
 net/ceph/cls_lock_client.c:28: warning: Function parameter or
  member 'oloc' not described in 'ceph_cls_lock'

 net/ceph/cls_lock_client.c:93: warning: Function parameter or
  member 'osdc' not described in 'ceph_cls_unlock'
 net/ceph/cls_lock_client.c:93: warning: Function parameter or
  member 'oid' not described in 'ceph_cls_unlock'
 net/ceph/cls_lock_client.c:93: warning: Function parameter or
  member 'oloc' not described in 'ceph_cls_unlock'

 net/ceph/cls_lock_client.c:143: warning: Function parameter or
  member 'osdc' not described in 'ceph_cls_break_lock'
 net/ceph/cls_lock_client.c:143: warning: Function parameter or
  member 'oid' not described in 'ceph_cls_break_lock'
 net/ceph/cls_lock_client.c:143: warning: Function parameter or
  member 'oloc' not described in 'ceph_cls_break_lock'

Signed-off-by: Baokun Li <libaokun1@huawei.com>
---
 net/ceph/cls_lock_client.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/ceph/cls_lock_client.c b/net/ceph/cls_lock_client.c
index 17447c19d937..82b7f3e3862f 100644
--- a/net/ceph/cls_lock_client.c
+++ b/net/ceph/cls_lock_client.c
@@ -10,7 +10,9 @@
 
 /**
  * ceph_cls_lock - grab rados lock for object
- * @oid, @oloc: object to lock
+ * @osdc: working on this ceph osd client
+ * @oid: object to lock
+ * @oloc: object to lock
  * @lock_name: the name of the lock
  * @type: lock type (CEPH_CLS_LOCK_EXCLUSIVE or CEPH_CLS_LOCK_SHARED)
  * @cookie: user-defined identifier for this instance of the lock
@@ -82,7 +84,9 @@ EXPORT_SYMBOL(ceph_cls_lock);
 
 /**
  * ceph_cls_unlock - release rados lock for object
- * @oid, @oloc: object to lock
+ * @osdc: working on this ceph osd client
+ * @oid: object to lock
+ * @oloc: object to lock
  * @lock_name: the name of the lock
  * @cookie: user-defined identifier for this instance of the lock
  */
@@ -130,7 +134,9 @@ EXPORT_SYMBOL(ceph_cls_unlock);
 
 /**
  * ceph_cls_break_lock - release rados lock for object for specified client
- * @oid, @oloc: object to lock
+ * @osdc: working on this ceph osd client
+ * @oid: object to lock
+ * @oloc: object to lock
  * @lock_name: the name of the lock
  * @cookie: user-defined identifier for this instance of the lock
  * @locker: current lock owner
-- 
2.31.1

