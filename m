Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22505952FE
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 08:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbiHPGu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 02:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231288AbiHPGum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 02:50:42 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86C8107ADF;
        Mon, 15 Aug 2022 19:01:24 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4M6DnS0pt0z1M7tx;
        Tue, 16 Aug 2022 09:58:04 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 16 Aug
 2022 10:01:22 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next,0/3] cleanup of qdisc offload function
Date:   Tue, 16 Aug 2022 10:04:20 +0800
Message-ID: <20220816020423.323820-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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

Some qdiscs don't care return value of qdisc offload function, so make 
function void.

Zhengchao Shao (3):
  net: sched: make mq_offload() void
  net: sched: make prio_offload() void
  net: sched: make red_offload() void

 net/sched/sch_mq.c   | 6 +++---
 net/sched/sch_prio.c | 6 +++---
 net/sched/sch_red.c  | 6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

-- 
2.17.1

