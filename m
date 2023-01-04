Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05D7165CB71
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 02:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238574AbjADBe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 20:34:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238486AbjADBeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 20:34:17 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D02DAA
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 17:34:17 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NmsYW65fJzJr5b;
        Wed,  4 Jan 2023 09:33:03 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 4 Jan 2023 09:34:15 +0800
From:   Hao Lan <lanhao@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <shenjian15@huawei.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH net-next 0/2] net: hns3: support wake on lan for hns3
Date:   Wed, 4 Jan 2023 09:34:03 +0800
Message-ID: <20230104013405.65433-1-lanhao@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HNS3 (HiSilicon Network System 3) supports Wake-on-LAN,
magic mode and magic security mode on each pf.
This patch supports the ethtool LAN wake-up configuration and
query interfaces and debugfs query interfaces. It does not
support the suspend resume interface because there is no
corresponding application scenario.

Hao Lan (2):
  net: hns3: support wake on lan configuration and query
  net: hns3: support debugfs for wake on lan

 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  13 ++
 .../hns3/hns3_common/hclge_comm_cmd.c         |   1 +
 .../hns3/hns3_common/hclge_comm_cmd.h         |   3 +
 .../ethernet/hisilicon/hns3/hns3_debugfs.c    |  10 +
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    |  27 +++
 .../hisilicon/hns3/hns3pf/hclge_cmd.h         |  24 ++
 .../hisilicon/hns3/hns3pf/hclge_debugfs.c     |  62 ++++++
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 206 ++++++++++++++++++
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  10 +
 9 files changed, 356 insertions(+)

-- 
2.30.0

