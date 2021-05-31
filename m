Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70CF23953F0
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 04:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhEaCkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 22:40:52 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:2417 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbhEaCkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 22:40:47 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4FtfXY2fGqz66yg;
        Mon, 31 May 2021 10:35:25 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 31 May 2021 10:39:07 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 31 May 2021 10:39:01 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/8] net: hns3: add VLAN filter control support
Date:   Mon, 31 May 2021 10:38:37 +0800
Message-ID: <1622428725-30049-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset add VLAN filter control support for HNS3 driver.

Jian Shen (8):
  net: hns3: add 'QoS' support for port based VLAN configuration
  net: hns3: refine for hclge_push_vf_port_base_vlan_info()
  net: hns3: remove unnecessary updating port based VLAN
  net: hns3: refine function hclge_set_vf_vlan_cfg()
  net: hns3: add support for modify VLAN filter state
  net: hns3: add query basic info support for VF
  net: hns3: add support for VF modify VLAN filter state
  net: hns3: add debugfs support for vlan configuration

 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |  10 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   9 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  15 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  39 +--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   1 -
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   8 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |   4 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  12 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 283 ++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h |  19 ++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 286 ++++++++++++++++-----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  36 ++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  75 +++---
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  50 +++-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   1 +
 15 files changed, 693 insertions(+), 155 deletions(-)

-- 
2.7.4

