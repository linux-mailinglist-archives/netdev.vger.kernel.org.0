Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65CB45EC0CE
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 13:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbiI0LPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 07:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231950AbiI0LPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 07:15:00 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E986E49B78;
        Tue, 27 Sep 2022 04:14:57 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4McH3h5B06z1P6nT;
        Tue, 27 Sep 2022 19:10:40 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 19:14:55 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 19:14:54 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>, <shenjian15@huawei.com>,
        <lanhao@huawei.com>
Subject: [PATCH net-next 0/4] net: hns3: cleanup and optimization
Date:   Tue, 27 Sep 2022 19:12:01 +0800
Message-ID: <20220927111205.18060-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This serial includes some cleanup and one optimization patches for
HNS3 driver.

Guangbin Huang (1):
  net: hns3: delete unnecessary vf value judgement when get vport id

Hao Chen (2):
  net: hns3: fix hns3 driver header file not self-contained issue
  net: hns3: replace magic numbers with macro for IPv4/v6

Jian Shen (1):
  net: hns3: refine the tcam key convert handle

 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h      |  4 +++-
 .../hns3/hns3_common/hclge_comm_tqp_stats.h          |  2 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c      | 12 ++++++------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h      |  6 ++++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c  |  4 +---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h  | 11 +++--------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h   |  5 ++++-
 7 files changed, 25 insertions(+), 19 deletions(-)

-- 
2.33.0

