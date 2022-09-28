Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29A595ED7BD
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 10:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233507AbiI1I31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 04:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233410AbiI1I3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 04:29:25 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E92975FEC;
        Wed, 28 Sep 2022 01:29:23 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4McqNS2R4CzHqMs;
        Wed, 28 Sep 2022 16:27:04 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 28 Sep
 2022 16:29:20 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <shuah@kernel.org>, <victor@mojatatu.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next] selftests/tc-testing: update qdisc/cls/action features in config
Date:   Wed, 28 Sep 2022 16:37:33 +0800
Message-ID: <20220928083733.252290-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since three patchsets "add tc-testing test cases", "refactor duplicate
codes in the tc cls walk function", and "refactor duplicate codes in the
qdisc class walk function" are merged to net-next tree, the list of
supported features needs to be updated in config file.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 tools/testing/selftests/tc-testing/config | 25 ++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/tc-testing/config b/tools/testing/selftests/tc-testing/config
index 2b2c2a835757..5ec7418a3c29 100644
--- a/tools/testing/selftests/tc-testing/config
+++ b/tools/testing/selftests/tc-testing/config
@@ -13,15 +13,28 @@ CONFIG_NET_SCHED=y
 # Queueing/Scheduling
 #
 CONFIG_NET_SCH_ATM=m
+CONFIG_NET_SCH_CAKE=m
+CONFIG_NET_SCH_CBQ=m
+CONFIG_NET_SCH_CBS=m
 CONFIG_NET_SCH_CHOKE=m
 CONFIG_NET_SCH_CODEL=m
+CONFIG_NET_SCH_DRR=m
+CONFIG_NET_SCH_DSMARK=m
 CONFIG_NET_SCH_ETF=m
 CONFIG_NET_SCH_FQ=m
+CONFIG_NET_SCH_FQ_CODEL=m
 CONFIG_NET_SCH_GRED=m
+CONFIG_NET_SCH_HFSC=m
 CONFIG_NET_SCH_HHF=m
+CONFIG_NET_SCH_HTB=m
+CONFIG_NET_SCH_INGRESS=m
+CONFIG_NET_SCH_MQPRIO=m
+CONFIG_NET_SCH_MULTIQ=m
+CONFIG_NET_NET_SCH_NETEM=m
+CONFIG_NET_SCH_PIE=m
 CONFIG_NET_SCH_PLUG=m
 CONFIG_NET_SCH_PRIO=m
-CONFIG_NET_SCH_INGRESS=m
+CONFIG_NET_SCH_QFQ=m
 CONFIG_NET_SCH_SFB=m
 CONFIG_NET_SCH_SFQ=m
 CONFIG_NET_SCH_SKBPRIO=m
@@ -37,6 +50,15 @@ CONFIG_NET_CLS_FW=m
 CONFIG_NET_CLS_U32=m
 CONFIG_CLS_U32_PERF=y
 CONFIG_CLS_U32_MARK=y
+CONFIG_NET_CLS_BASIC=m
+CONFIG_NET_CLS_BPF=m
+CONFIG_NET_CLS_CGROUP=m
+CONFIG_NET_CLS_FLOW=m
+CONFIG_NET_CLS_FLOWER=m
+CONFIG_NET_CLS_MATCHALL=m
+CONFIG_NET_CLS_ROUTE4=m
+CONFIG_NET_CLS_RSVP=m
+CONFGI_NET_CLS_TCINDEX=m
 CONFIG_NET_EMATCH=y
 CONFIG_NET_EMATCH_STACK=32
 CONFIG_NET_EMATCH_CMP=m
@@ -68,6 +90,7 @@ CONFIG_NET_ACT_IFE=m
 CONFIG_NET_ACT_TUNNEL_KEY=m
 CONFIG_NET_ACT_CT=m
 CONFIG_NET_ACT_MPLS=m
+CONFIG_NET_ACT_GATE=m
 CONFIG_NET_IFE_SKBMARK=m
 CONFIG_NET_IFE_SKBPRIO=m
 CONFIG_NET_IFE_SKBTCINDEX=m
-- 
2.17.1

