Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AECD2604296
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 13:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbiJSLHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 07:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbiJSLHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 07:07:02 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D2A1757A4
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 03:36:07 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Msm9Q4qMqzJn4f;
        Wed, 19 Oct 2022 17:47:22 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 19 Oct
 2022 17:50:01 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <keescook@chromium.org>, <gustavoars@kernel.org>,
        <gregkh@linuxfoundation.org>, <ast@kernel.org>,
        <peter.chen@kernel.org>, <bin.chen@corigine.com>,
        <luobin9@huawei.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net,v2 0/4] fix some issues in Huawei hinic driver
Date:   Wed, 19 Oct 2022 17:57:50 +0800
Message-ID: <20221019095754.189119-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix some issues in Huawei hinic driver. This patchset is compiled only,
not tested.

---
v2: remove cyclic release cmdq
---

Zhengchao Shao (4):
  net: hinic: fix incorrect assignment issue in
    hinic_set_interrupt_cfg()
  net: hinic: fix memory leak when reading function table
  net: hinic: fix the issue of CMDQ memory leaks
  net: hinic: fix the issue of double release MBOX callback of VF

 .../net/ethernet/huawei/hinic/hinic_debugfs.c  | 18 ++++++++++++------
 .../net/ethernet/huawei/hinic/hinic_hw_cmdq.c  |  2 +-
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c   |  2 +-
 .../net/ethernet/huawei/hinic/hinic_sriov.c    |  1 -
 4 files changed, 14 insertions(+), 9 deletions(-)

-- 
2.17.1

