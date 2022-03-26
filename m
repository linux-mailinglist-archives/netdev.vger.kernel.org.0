Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 195214E803E
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 10:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbiCZJ6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 05:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiCZJ6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 05:58:13 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB01B1CFEF;
        Sat, 26 Mar 2022 02:56:36 -0700 (PDT)
Received: from kwepemi100015.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KQZ7l3j5GzfZNn;
        Sat, 26 Mar 2022 17:54:59 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100015.china.huawei.com (7.221.188.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 26 Mar 2022 17:56:34 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 26 Mar 2022 17:56:34 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 0/6] net: hns3: add some fixes for -net
Date:   Sat, 26 Mar 2022 17:50:59 +0800
Message-ID: <20220326095105.54075-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds some fixes for the HNS3 ethernet driver.

Guangbin Huang (1):
  net: hns3: fix phy can not link up when autoneg off and reset

Hao Chen (4):
  net: hns3: fix ethtool tx copybreak buf size indicating not aligned
    issue
  net: hns3: add max order judgement for tx spare buffer
  net: hns3: add netdev reset check for hns3_set_tunable()
  net: hns3: add NULL pointer check for hns3_set/get_ringparam()

Peng Li (1):
  net: hns3: clean residual vf config after disable sriov

 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  3 ++
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 44 +++++++++++++---
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 23 ++++++---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 50 +++++++++++++++++++
 .../hisilicon/hns3/hns3pf/hclge_mdio.c        |  4 +-
 5 files changed, 107 insertions(+), 17 deletions(-)

-- 
2.33.0

