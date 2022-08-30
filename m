Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2215A6167
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 13:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbiH3LNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 07:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiH3LNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 07:13:48 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F80DD4E6;
        Tue, 30 Aug 2022 04:13:47 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MH4PM70B0znTTq;
        Tue, 30 Aug 2022 19:11:19 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 30 Aug 2022 19:13:45 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 30 Aug 2022 19:13:44 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <lanhao@huawei.com>
Subject: [PATCH net-next 0/4] net: hns3: updates for -next
Date:   Tue, 30 Aug 2022 19:11:13 +0800
Message-ID: <20220830111117.47865-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes some updates for the HNS3 ethernet driver.

Guangbin Huang (3):
  net: hns3: add getting capabilities of gro offload and fd from
    firmware
  net: hns3: add querying fec ability from firmware
  net: hns3: net: hns3: add querying and setting fec off mode from
    firmware

Hao Lan (1):
  net: hns3: add querying and setting fec llrs mode from firmware

 drivers/net/ethernet/hisilicon/hns3/hnae3.h   | 10 +-
 .../hns3/hns3_common/hclge_comm_cmd.c         | 12 ++-
 .../hns3/hns3_common/hclge_comm_cmd.h         |  3 +
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  7 +-
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 15 +--
 .../hisilicon/hns3/hns3pf/hclge_cmd.h         |  4 +-
 .../hisilicon/hns3/hns3pf/hclge_debugfs.c     |  5 +-
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 92 ++++++++++++++-----
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      |  2 +-
 9 files changed, 105 insertions(+), 45 deletions(-)

-- 
2.33.0

