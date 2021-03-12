Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF1F3387E0
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 09:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbhCLItx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 03:49:53 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:13151 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbhCLItr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 03:49:47 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DxfZl3qc5zmWVJ;
        Fri, 12 Mar 2021 16:47:27 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Fri, 12 Mar 2021 16:49:39 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/4] net: hns3: support imp-controlled PHYs
Date:   Fri, 12 Mar 2021 16:50:12 +0800
Message-ID: <1615539016-45698-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for imp-controlled PHYs in the HNS3
ethernet driver.

Guangbin Huang (4):
  net: hns3: add support for imp-controlled PHYs
  net: hns3: add get/set pause parameters support for imp-controlled
    PHYs
  net: hns3: add ioctl support for imp-controlled PHYs
  net: hns3: add phy loopback support for imp-controlled PHYs

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   4 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   2 +
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   9 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |   4 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  44 +++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |  20 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 241 ++++++++++++++++++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c    |  39 ++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.h    |   2 +
 9 files changed, 321 insertions(+), 44 deletions(-)

-- 
2.7.4

