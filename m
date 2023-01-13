Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A908D668963
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 03:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233365AbjAMCIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 21:08:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbjAMCIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 21:08:51 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02701DF0A
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 18:08:48 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NtPq136C5zqTyX;
        Fri, 13 Jan 2023 10:03:57 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 13 Jan 2023 10:08:45 +0800
From:   Hao Lan <lanhao@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <shenjian15@huawei.com>,
        <wangjie125@huawei.com>, <netdev@vger.kernel.org>
Subject: [PATCH net-next 0/2] add some vf fault detect patch for hns
Date:   Fri, 13 Jan 2023 10:08:27 +0800
Message-ID: <20230113020829.48451-1-lanhao@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently hns3 driver supports vf fault detect feature.Patch #1 is
add hns3 vf fault detect cap bit support.Patch #2 is add vf fault
process in hns3 ras.

Jie Wang (2):
  net: hns3: add hns3 vf fault detect cap bit support
  net: hns3: add vf fault process in hns3 ras

 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |   5 +
 .../hns3/hns3_common/hclge_comm_cmd.c         |   1 +
 .../hns3/hns3_common/hclge_comm_cmd.h         |   2 +
 .../ethernet/hisilicon/hns3/hns3_debugfs.c    |   3 +
 .../hisilicon/hns3/hns3pf/hclge_err.c         | 113 +++++++++++++++++-
 .../hisilicon/hns3/hns3pf/hclge_err.h         |   2 +
 .../hisilicon/hns3/hns3pf/hclge_main.c        |   3 +-
 .../hisilicon/hns3/hns3pf/hclge_main.h        |   1 +
 8 files changed, 124 insertions(+), 6 deletions(-)

-- 
2.30.0

