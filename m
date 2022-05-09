Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1A7851F72F
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 10:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbiEIIuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 04:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237439AbiEIIXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 04:23:02 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA641F018A;
        Mon,  9 May 2022 01:19:00 -0700 (PDT)
Received: from kwepemi500019.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KxYVx2gPFz1JC4T;
        Mon,  9 May 2022 16:00:09 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500019.china.huawei.com (7.221.188.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 9 May 2022 16:01:18 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 9 May 2022 16:01:18 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH V2 net-next 0/6] net: hns3: updates for -next
Date:   Mon, 9 May 2022 15:55:26 +0800
Message-ID: <20220509075532.32166-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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

Change logs:
V1 -> V2:
 - Fix some sparse warnings of patch 3# and 4#.
 - Add patch #6 to fix sparse warnings of incorrect type of argument.


Guangbin Huang (2):
  net: hns3: add query vf ring and vector map relation
  net: hns3: fix incorrect type of argument in declaration of function
    hclge_comm_get_rss_indir_tbl

Hao Chen (1):
  net: hns3: fix access null pointer issue when set tx-buf-size as 0

Jie Wang (2):
  net: hns3: add byte order conversion for PF to VF mailbox message
  net: hns3: add byte order conversion for VF to PF mailbox message

Yufeng Mo (1):
  net: hns3: remove the affinity settings of vector0

 .../net/ethernet/hisilicon/hns3/hclge_mbx.h   |  62 +++++-
 .../hns3/hns3_common/hclge_comm_rss.h         |   2 +-
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    |   7 +-
 .../hisilicon/hns3/hns3pf/hclge_main.c        |  27 +--
 .../hisilicon/hns3/hns3pf/hclge_main.h        |   6 +-
 .../hisilicon/hns3/hns3pf/hclge_mbx.c         | 193 +++++++++++++-----
 .../hisilicon/hns3/hns3pf/hclge_trace.h       |   2 +-
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      |  58 +++---
 .../hisilicon/hns3/hns3vf/hclgevf_main.h      |   2 +-
 .../hisilicon/hns3/hns3vf/hclgevf_mbx.c       |  80 +++++---
 .../hisilicon/hns3/hns3vf/hclgevf_trace.h     |   2 +-
 11 files changed, 275 insertions(+), 166 deletions(-)

-- 
2.33.0

