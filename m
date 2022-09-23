Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88EE55E7177
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 03:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbiIWBlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 21:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbiIWBlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 21:41:12 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C6BD6934;
        Thu, 22 Sep 2022 18:41:11 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MYZWc3j2nz1P6nd;
        Fri, 23 Sep 2022 09:37:00 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 23 Sep 2022 09:41:05 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 23 Sep 2022 09:41:04 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <jiri@mellanox.com>, <moshe@mellanox.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <idosch@nvidia.com>
CC:     <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>, <lipeng321@huawei.com>,
        <chenhao418@huawei.com>
Subject: [PATCH net-next 1/2] devlink: expand __DEVLINK_PARAM_MAX_STRING_VALUE to 256
Date:   Fri, 23 Sep 2022 09:38:17 +0800
Message-ID: <20220923013818.51003-2-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220923013818.51003-1-huangguangbin2@huawei.com>
References: <20220923013818.51003-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao418@huawei.com>

The string length of devlink parameter is limited to 32, it may be not
enough if there are several parameters in one string, so expand it to 256.

Signed-off-by: Hao Chen <chenhao418@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 include/net/devlink.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 264aa98e6da6..52aaafc92f56 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -400,7 +400,7 @@ typedef u64 devlink_resource_occ_get_t(void *priv);
 
 #define DEVLINK_RESOURCE_GENERIC_NAME_PORTS "physical_ports"
 
-#define __DEVLINK_PARAM_MAX_STRING_VALUE 32
+#define __DEVLINK_PARAM_MAX_STRING_VALUE 256
 enum devlink_param_type {
 	DEVLINK_PARAM_TYPE_U8,
 	DEVLINK_PARAM_TYPE_U16,
-- 
2.33.0

