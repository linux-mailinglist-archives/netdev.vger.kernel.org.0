Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3795BB74D
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 10:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiIQIln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 04:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiIQIll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 04:41:41 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33C033E01;
        Sat, 17 Sep 2022 01:41:40 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MV47j4D7kz14QYH;
        Sat, 17 Sep 2022 16:37:37 +0800 (CST)
Received: from ubuntu1804.huawei.com (10.67.174.58) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 17 Sep 2022 16:41:38 +0800
From:   Xiu Jianfeng <xiujianfeng@huawei.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <xiujianfeng@huawei.com>
Subject: [PATCH] vhost: add __init/__exit annotations to module init/exit funcs
Date:   Sat, 17 Sep 2022 16:38:03 +0800
Message-ID: <20220917083803.21521-1-xiujianfeng@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.174.58]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing __init/__exit annotations to module init/exit funcs.

Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
---
 drivers/vhost/net.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 68e4ecd1cc0e..1cab1a831bb6 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1781,7 +1781,7 @@ static struct miscdevice vhost_net_misc = {
 	.fops = &vhost_net_fops,
 };
 
-static int vhost_net_init(void)
+static int __init vhost_net_init(void)
 {
 	if (experimental_zcopytx)
 		vhost_net_enable_zcopy(VHOST_NET_VQ_TX);
@@ -1789,7 +1789,7 @@ static int vhost_net_init(void)
 }
 module_init(vhost_net_init);
 
-static void vhost_net_exit(void)
+static void __exit vhost_net_exit(void)
 {
 	misc_deregister(&vhost_net_misc);
 }
-- 
2.17.1

