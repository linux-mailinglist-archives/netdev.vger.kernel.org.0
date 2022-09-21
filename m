Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1075BFDE2
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 14:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbiIUMcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 08:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiIUMca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 08:32:30 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CEDE696D5;
        Wed, 21 Sep 2022 05:32:27 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MXd5X4z4QzpTxk;
        Wed, 21 Sep 2022 20:29:36 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 21 Sep
 2022 20:32:25 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <shuah@kernel.org>, <victor@mojatatu.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH -next, v3 00/10] cleanup in Huawei hinic driver
Date:   Wed, 21 Sep 2022 20:33:48 +0800
Message-ID: <20220921123358.63442-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do code cleanup in Huawei hinic driver.

Zhengchao Shao (10):
  net: hinic: modify kernel doc comments
  net: hinic: change type of function to be static
  net: hinic: remove unused functions
  net: hinic: remove unused macro
  net: hinic: remove duplicate macro definition
  net: hinic: simplify code logic
  net: hinic: change hinic_deinit_vf_hw() to void
  net: hinic: remove unused enumerated value
  net: hinic: replace magic numbers with macro
  net: hinic: remove the unused input parameter prod_idx in
    sq_prepare_ctrl()

 .../net/ethernet/huawei/hinic/hinic_debugfs.h |  1 -
 .../net/ethernet/huawei/hinic/hinic_ethtool.c |  1 -
 .../net/ethernet/huawei/hinic/hinic_hw_cmdq.c |  9 ++---
 .../net/ethernet/huawei/hinic/hinic_hw_cmdq.h |  3 --
 .../net/ethernet/huawei/hinic/hinic_hw_csr.h  |  1 -
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  | 17 ++-------
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |  5 ---
 .../net/ethernet/huawei/hinic/hinic_hw_if.c   | 35 -------------------
 .../net/ethernet/huawei/hinic/hinic_hw_if.h   |  9 -----
 .../net/ethernet/huawei/hinic/hinic_hw_mbox.c |  9 ++---
 .../net/ethernet/huawei/hinic/hinic_hw_mbox.h |  4 ---
 .../net/ethernet/huawei/hinic/hinic_hw_qp.c   | 11 +++---
 .../net/ethernet/huawei/hinic/hinic_hw_qp.h   |  5 ++-
 .../net/ethernet/huawei/hinic/hinic_hw_wq.c   |  2 --
 .../net/ethernet/huawei/hinic/hinic_hw_wqe.h  | 25 -------------
 .../net/ethernet/huawei/hinic/hinic_main.c    |  4 ---
 drivers/net/ethernet/huawei/hinic/hinic_rx.c  |  2 +-
 drivers/net/ethernet/huawei/hinic/hinic_rx.h  |  2 --
 .../net/ethernet/huawei/hinic/hinic_sriov.c   | 15 ++++----
 .../net/ethernet/huawei/hinic/hinic_sriov.h   |  2 --
 drivers/net/ethernet/huawei/hinic/hinic_tx.c  |  6 ++--
 drivers/net/ethernet/huawei/hinic/hinic_tx.h  |  2 --
 22 files changed, 23 insertions(+), 147 deletions(-)

-- 
2.17.1

