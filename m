Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAEC143C95C
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 14:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241833AbhJ0MSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 08:18:41 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:25316 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232242AbhJ0MSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 08:18:39 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HfSGV44vZzbhKM;
        Wed, 27 Oct 2021 20:11:30 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 27 Oct 2021 20:16:09 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 27 Oct 2021 20:16:08 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 0/7] net: hns3: add some fixes for -net
Date:   Wed, 27 Oct 2021 20:11:42 +0800
Message-ID: <20211027121149.45897-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds some fixes for the HNS3 ethernet driver.

Guangbin Huang (4):
  net: hns3: fix pause config problem after autoneg disabled
  net: hns3: ignore reset event before initialization process is done
  net: hns3: expand buffer len for some debugfs command
  net: hns3: adjust string spaces of some parameters of tx bd info in
    debugfs

Jie Wang (2):
  net: hns3: fix data endian problem of some functions of debugfs
  net: hns3: add more string spaces for dumping packets number of queue
    info in debugfs

Yufeng Mo (1):
  net: hns3: change hclge/hclgevf workqueue to WQ_UNBOUND mode

 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  1 +
 .../ethernet/hisilicon/hns3/hns3_debugfs.c    | 16 ++---
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 33 +++++++---
 .../hisilicon/hns3/hns3pf/hclge_debugfs.c     | 30 ++++-----
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 65 ++++++++++---------
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  1 -
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.c |  2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.h |  1 +
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      |  5 +-
 .../hisilicon/hns3/hns3vf/hclgevf_main.h      |  1 +
 10 files changed, 90 insertions(+), 65 deletions(-)

-- 
2.33.0

