Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D08F5A44C0
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 10:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiH2IOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 04:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiH2IOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 04:14:40 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A8F54648;
        Mon, 29 Aug 2022 01:14:37 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MGNTt2vz3zGpwd;
        Mon, 29 Aug 2022 16:12:50 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 29 Aug
 2022 16:14:35 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next,v2 3/3] net: sched: gred: remove unused enumeration values
Date:   Mon, 29 Aug 2022 16:17:04 +0800
Message-ID: <20220829081704.255235-4-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220829081704.255235-1-shaozhengchao@huawei.com>
References: <20220829081704.255235-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the previous patch, the variable "other" that is not used is removed.
The enumerated value TCA_GRED_VQ_STAT_OTHER of is not used. Remove it.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 include/uapi/linux/pkt_sched.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 55fadb3ace17..f2e0426e2414 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -335,7 +335,6 @@ enum {
 	TCA_GRED_VQ_STAT_FORCED_DROP,	/* u32 */
 	TCA_GRED_VQ_STAT_FORCED_MARK,	/* u32 */
 	TCA_GRED_VQ_STAT_PDROP,		/* u32 */
-	TCA_GRED_VQ_STAT_OTHER,		/* u32 */
 	TCA_GRED_VQ_FLAGS,		/* u32 */
 	__TCA_GRED_VQ_MAX
 };
-- 
2.17.1

