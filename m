Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431981CA029
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 03:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgEHBjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 21:39:14 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:42760 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726509AbgEHBjN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 21:39:13 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C3308472343513D2840E;
        Fri,  8 May 2020 09:39:10 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Fri, 8 May 2020 09:39:04 +0800
From:   Xiongfeng Wang <wangxiongfeng2@huawei.com>
To:     <bfields@fieldses.org>, <chuck.lever@oracle.com>,
        <trond.myklebust@hammerspace.com>, <anna.schumaker@netapp.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-nfs@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <wangxiongfeng2@huawei.com>
Subject: [PATCH 1/2] sunrpc: add missing newline when printing parameter 'pool_mode' by sysfs
Date:   Fri, 8 May 2020 09:32:59 +0800
Message-ID: <1588901580-44687-2-git-send-email-wangxiongfeng2@huawei.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1588901580-44687-1-git-send-email-wangxiongfeng2@huawei.com>
References: <1588901580-44687-1-git-send-email-wangxiongfeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When I cat parameter '/sys/module/sunrpc/parameters/pool_mode', it
displays as follows. It is better to add a newline for easy reading.

[root@hulk-202 ~]# cat /sys/module/sunrpc/parameters/pool_mode
global[root@hulk-202 ~]#

Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
---
 net/sunrpc/svc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 187dd4e..d8ef47f 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -88,15 +88,15 @@ struct svc_pool_map svc_pool_map = {
 	switch (*ip)
 	{
 	case SVC_POOL_AUTO:
-		return strlcpy(buf, "auto", 20);
+		return strlcpy(buf, "auto\n", 20);
 	case SVC_POOL_GLOBAL:
-		return strlcpy(buf, "global", 20);
+		return strlcpy(buf, "global\n", 20);
 	case SVC_POOL_PERCPU:
-		return strlcpy(buf, "percpu", 20);
+		return strlcpy(buf, "percpu\n", 20);
 	case SVC_POOL_PERNODE:
-		return strlcpy(buf, "pernode", 20);
+		return strlcpy(buf, "pernode\n", 20);
 	default:
-		return sprintf(buf, "%d", *ip);
+		return sprintf(buf, "%d\n", *ip);
 	}
 }
 
-- 
1.7.12.4

