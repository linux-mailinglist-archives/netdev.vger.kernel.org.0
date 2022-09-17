Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9E625BB747
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 10:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiIQIjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 04:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiIQIjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 04:39:14 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F125A2F4
        for <netdev@vger.kernel.org>; Sat, 17 Sep 2022 01:39:13 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MV4750nqyzBsNg;
        Sat, 17 Sep 2022 16:37:05 +0800 (CST)
Received: from ubuntu1804.huawei.com (10.67.174.58) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 17 Sep 2022 16:39:10 +0800
From:   Xiu Jianfeng <xiujianfeng@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>
Subject: [PATCH] net: macvtap: add __init/__exit annotations to module init/exit funcs
Date:   Sat, 17 Sep 2022 16:35:35 +0800
Message-ID: <20220917083535.20040-1-xiujianfeng@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.174.58]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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
 drivers/net/macvtap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index cecf8c63096c..d1f435788e90 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -207,7 +207,7 @@ static struct notifier_block macvtap_notifier_block __read_mostly = {
 	.notifier_call	= macvtap_device_event,
 };
 
-static int macvtap_init(void)
+static int __init macvtap_init(void)
 {
 	int err;
 
@@ -241,7 +241,7 @@ static int macvtap_init(void)
 }
 module_init(macvtap_init);
 
-static void macvtap_exit(void)
+static void __exit macvtap_exit(void)
 {
 	rtnl_link_unregister(&macvtap_link_ops);
 	unregister_netdevice_notifier(&macvtap_notifier_block);
-- 
2.17.1

