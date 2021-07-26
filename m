Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05BC43D515D
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 04:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbhGZCKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 22:10:14 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7428 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbhGZCKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 22:10:14 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GY4824LYvz7xWh;
        Mon, 26 Jul 2021 10:46:58 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 26 Jul 2021 10:50:41 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 26 Jul 2021 10:50:41 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <moyufeng@huawei.com>,
        <chenhao288@hisilicon.com>, <huangguangbin2@huawei.com>
Subject: [PATCH V3 net-next 0/7] net: hns3: add support devlink
Date:   Mon, 26 Jul 2021 10:47:00 +0800
Message-ID: <1627267627-38467-1-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds devlink support for the HNS3 ethernet driver.

change log:
V2 -> V3:
1. remove two patches of setting rx/tx buffer size by devlink param.

V1 -> V2:
1. add more detailed descriptions of parameters in document hns3.rst.

RFC -> V1:
1. use DEVLINK_INFO_VERSION_GENERIC_FW instead of "fw-version".
2. add devlink documentation for hns3 driver.

Hao Chen (3):
  devlink: add documentation for hns3 driver
  net: hns3: add devlink reload support for PF
  net: hns3: add devlink reload support for VF

Yufeng Mo (4):
  net: hns3: add support for registering devlink for PF
  net: hns3: add support for registering devlink for VF
  net: hns3: add support for devlink get info for PF
  net: hns3: add support for devlink get info for VF

 Documentation/networking/devlink/hns3.rst          |  25 ++++
 Documentation/networking/devlink/index.rst         |   1 +
 drivers/net/ethernet/hisilicon/Kconfig             |   1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/Makefile    |   2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c | 154 ++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_devlink.h |  15 ++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  10 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   2 +
 .../net/ethernet/hisilicon/hns3/hns3vf/Makefile    |   2 +-
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.c        | 155 +++++++++++++++++++++
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.h        |  15 ++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   8 ++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   3 +
 13 files changed, 390 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/networking/devlink/hns3.rst
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.h
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.h

-- 
2.8.1

