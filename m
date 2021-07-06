Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 646B83BC6CA
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 08:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbhGFGrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 02:47:46 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:6419 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbhGFGrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 02:47:37 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GJtHs74QVz78ZC;
        Tue,  6 Jul 2021 14:41:29 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 6 Jul 2021 14:44:55 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 6 Jul 2021 14:44:55 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>,
        <huangguangbin2@huawei.com>
Subject: [RFC PATCH net-next 0/8] net: hns3: add support devlink
Date:   Tue, 6 Jul 2021 14:41:24 +0800
Message-ID: <1625553692-2773-1-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds devlink support for the HNS3 ethernet driver.

Hao Chen (4):
  net: hns3: add devlink reload support for PF
  net: hns3: add devlink reload support for VF
  net: hns3: add support for PF setting rx/tx buffer size by devlink
    param
  net: hns3: add support for VF setting rx/tx buffer size by devlink
    param

Yufeng Mo (4):
  net: hns3: add support for registering devlink for PF
  net: hns3: add support for registering devlink for VF
  net: hns3: add support for devlink get info for PF
  net: hns3: add support for devlink get info for VF

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   8 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/Makefile    |   2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c | 239 ++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_devlink.h |  22 ++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  13 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   2 +
 .../net/ethernet/hisilicon/hns3/hns3vf/Makefile    |   2 +-
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.c        | 240 +++++++++++++++++++++
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.h        |  22 ++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  11 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   3 +
 12 files changed, 560 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.h
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.h

-- 
2.8.1

