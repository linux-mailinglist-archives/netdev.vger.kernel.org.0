Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0849238796D
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 15:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244804AbhERNDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 09:03:10 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3013 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233342AbhERNDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 09:03:09 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FkwzJ4vSFzQpt2;
        Tue, 18 May 2021 20:58:20 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 18 May 2021 21:01:42 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 18 May
 2021 21:01:41 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH net-next] net: dcb: Remove unnecessary INIT_LIST_HEAD()
Date:   Tue, 18 May 2021 21:03:58 +0800
Message-ID: <20210518130358.1304701-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The list_head dcb_app_list is initialized statically.
It is unnecessary to initialize by INIT_LIST_HEAD().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 net/dcb/dcbnl.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
index 653e3bc9c87b..51f80a2f8194 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -2075,8 +2075,6 @@ EXPORT_SYMBOL(dcb_ieee_getapp_default_prio_mask);
 
 static int __init dcbnl_init(void)
 {
-	INIT_LIST_HEAD(&dcb_app_list);
-
 	rtnl_register(PF_UNSPEC, RTM_GETDCB, dcb_doit, NULL, 0);
 	rtnl_register(PF_UNSPEC, RTM_SETDCB, dcb_doit, NULL, 0);
 
-- 
2.25.1

