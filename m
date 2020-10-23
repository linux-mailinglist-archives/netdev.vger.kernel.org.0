Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E3D296C5B
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 11:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S461728AbgJWJvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 05:51:10 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:43186 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S461674AbgJWJvK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 05:51:10 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A337D6645788ACA88AE1;
        Fri, 23 Oct 2020 17:51:07 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Fri, 23 Oct 2020
 17:51:04 +0800
From:   Zhang Qilong <zhangqilong3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <vvs@virtuozzo.com>, <lirongqing@baidu.com>,
        <roopa@cumulusnetworks.com>, <netdev@vger.kernel.org>
Subject: [PATCH -next] neigh: remove the extra slash
Date:   Fri, 23 Oct 2020 18:01:46 +0800
Message-ID: <20201023100146.34948-1-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The normal path has only one slash.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
 net/core/neighbour.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 8e39e28b0a8d..503501842a7d 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3623,7 +3623,7 @@ int neigh_sysctl_register(struct net_device *dev, struct neigh_parms *p,
 	int i;
 	struct neigh_sysctl_table *t;
 	const char *dev_name_source;
-	char neigh_path[ sizeof("net//neigh/") + IFNAMSIZ + IFNAMSIZ ];
+	char neigh_path[sizeof("net/neigh/") + IFNAMSIZ + IFNAMSIZ];
 	char *p_name;
 
 	t = kmemdup(&neigh_sysctl_template, sizeof(*t), GFP_KERNEL);
-- 
2.17.1

