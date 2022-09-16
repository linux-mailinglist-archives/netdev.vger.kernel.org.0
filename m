Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA8A5BA890
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 10:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbiIPIu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 04:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiIPIu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 04:50:26 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A9198CAC;
        Fri, 16 Sep 2022 01:50:25 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MTSMY4B6VzMmyB;
        Fri, 16 Sep 2022 16:45:45 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 16 Sep
 2022 16:50:22 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [RFC PATCH net-next 0/2] refactor the module and net init/exit functions in tc_action
Date:   Fri, 16 Sep 2022 16:51:53 +0800
Message-ID: <20220916085155.33750-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most action modules have their own module and net registration and
unregistration interfaces, so add macros helper and replace them with
it.

Zhengchao Shao (2):
  net: sched: act_api: add helper macro for tcf_action in module and net
    init/exit
  net: sched: use module_net_tcf_action macro when module and net
    init/exit in action

 include/net/act_api.h      | 26 ++++++++++++++++++++++++++
 net/sched/act_bpf.c        | 32 +-------------------------------
 net/sched/act_connmark.c   | 31 +------------------------------
 net/sched/act_csum.c       | 32 +-------------------------------
 net/sched/act_ctinfo.c     | 31 +------------------------------
 net/sched/act_gate.c       | 31 +------------------------------
 net/sched/act_ife.c        | 32 +-------------------------------
 net/sched/act_mpls.c       | 32 +-------------------------------
 net/sched/act_nat.c        | 32 +-------------------------------
 net/sched/act_pedit.c      | 32 +-------------------------------
 net/sched/act_police.c     | 32 +-------------------------------
 net/sched/act_sample.c     | 32 +-------------------------------
 net/sched/act_skbedit.c    | 32 +-------------------------------
 net/sched/act_skbmod.c     | 32 +-------------------------------
 net/sched/act_tunnel_key.c | 32 +-------------------------------
 net/sched/act_vlan.c       | 32 +-------------------------------
 16 files changed, 41 insertions(+), 462 deletions(-)

-- 
2.17.1

