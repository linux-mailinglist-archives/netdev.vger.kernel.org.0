Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B54AA33B27E
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 13:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbhCOMXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 08:23:44 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13607 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbhCOMX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 08:23:27 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DzbBP6CSNz17LbZ;
        Mon, 15 Mar 2021 20:21:33 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Mon, 15 Mar 2021 20:23:16 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/9] net: hns3: refactor and new features for flow director
Date:   Mon, 15 Mar 2021 20:23:42 +0800
Message-ID: <1615811031-55209-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset refactor some functions and add some new features for
flow director.

patch 1~3: refactor large functions
patch 4, 7: add traffic class and user-def field support for ethtool
patch 5: use asynchronously configuration
patch 6: clean up for hns3_del_all_fd_entries()
patch 8, 9: add support for queue bonding mode

Jian Shen (9):
  net: hns3: refactor out hclge_add_fd_entry()
  net: hns3: refactor out hclge_fd_get_tuple()
  net: hns3: refactor for function hclge_fd_convert_tuple
  net: hns3: add support for traffic class tuple support for flow
    director by ethtool
  net: hns3: refactor flow director configuration
  net: hns3: refine for hns3_del_all_fd_entries()
  net: hns3: add support for user-def data of flow director
  net: hns3: add support for queue bonding mode of flow director
  net: hns3: add queue bonding mode support for VF

 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |    8 +
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |    9 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |    7 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   91 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   14 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   13 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |    2 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   21 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 1570 ++++++++++++++------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   63 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   33 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |    2 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   74 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |    7 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c   |   17 +
 15 files changed, 1450 insertions(+), 481 deletions(-)

-- 
2.7.4

