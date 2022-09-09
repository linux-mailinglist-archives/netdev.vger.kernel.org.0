Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEE55B2F3A
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 08:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbiIIGoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 02:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiIIGoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 02:44:03 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E09C7B1DD;
        Thu,  8 Sep 2022 23:44:02 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MP5xJ0M2XznVD0;
        Fri,  9 Sep 2022 14:41:24 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 9 Sep 2022 14:43:59 +0800
From:   Gaosheng Cui <cuigaosheng1@huawei.com>
To:     <santosh.shilimkar@oracle.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <andy.grover@oracle.com>, <cuigaosheng1@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <rds-devel@oss.oracle.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] net/rds: remove rds_ib_sysctl_max_unsig_bytes declaration
Date:   Fri, 9 Sep 2022 14:43:58 +0800
Message-ID: <20220909064358.1150863-1-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.244.148.83]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rds_ib_sysctl_max_unsig_bytes has been removed since
commit 1d34f175712b ("RDS: Remove unsignaled_bytes sysctl"),
so remove it.

Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
---
 net/rds/ib.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/rds/ib.h b/net/rds/ib.h
index 2ba71102b1f1..bf5367b87506 100644
--- a/net/rds/ib.h
+++ b/net/rds/ib.h
@@ -451,7 +451,6 @@ void rds_ib_sysctl_exit(void);
 extern unsigned long rds_ib_sysctl_max_send_wr;
 extern unsigned long rds_ib_sysctl_max_recv_wr;
 extern unsigned long rds_ib_sysctl_max_unsig_wrs;
-extern unsigned long rds_ib_sysctl_max_unsig_bytes;
 extern unsigned long rds_ib_sysctl_max_recv_allocation;
 extern unsigned int rds_ib_sysctl_flow_control;
 
-- 
2.25.1

