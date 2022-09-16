Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 691B35BA4B0
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 04:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiIPCkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 22:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiIPCku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 22:40:50 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CB6491EF;
        Thu, 15 Sep 2022 19:40:47 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MTJ9338VbzNm7L;
        Fri, 16 Sep 2022 10:36:07 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 16 Sep 2022 10:40:44 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 16 Sep 2022 10:40:43 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>, <lipeng321@huawei.com>,
        <lanhao@huawei.com>, <shenjian15@huawei.com>
Subject: [PATCH net-next 0/4] net: hns3: updates for -next
Date:   Fri, 16 Sep 2022 10:37:59 +0800
Message-ID: <20220916023803.23756-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
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

This series includes some updates for the HNS3 ethernet driver.

Guangbin Huang (2):
  net: hns3: optimize converting dscp to priority process of
    hns3_nic_select_queue()
  net: hns3: add judge fd ability for sync and clear process of flow
    director

Hao Lan (1):
  net: hns3: refactor function hclge_mbx_handler()

Yonglong Liu (1):
  net: hns3: add support for external loopback test

 .../net/ethernet/hisilicon/hns3/hclge_mbx.h   |  11 +
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |   6 +
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  64 ++-
 .../net/ethernet/hisilicon/hns3/hns3_enet.h   |   3 +
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    |  61 ++-
 .../hisilicon/hns3/hns3pf/hclge_dcb.c         |  28 +-
 .../hisilicon/hns3/hns3pf/hclge_debugfs.c     |  17 +-
 .../hisilicon/hns3/hns3pf/hclge_main.c        |  46 +-
 .../hisilicon/hns3/hns3pf/hclge_main.h        |   4 -
 .../hisilicon/hns3/hns3pf/hclge_mbx.c         | 415 ++++++++++++------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.c |  18 +-
 11 files changed, 454 insertions(+), 219 deletions(-)

-- 
2.33.0

