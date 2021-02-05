Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4602D3106C9
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 09:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhBEIeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 03:34:23 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:12428 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbhBEIeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 03:34:05 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DX7vQ5HvBzjGrj;
        Fri,  5 Feb 2021 16:32:18 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Fri, 5 Feb 2021 16:33:15 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 0/6] net: hns3: updates for -nex
Date:   Fri, 5 Feb 2021 16:32:43 +0800
Message-ID: <1612513969-9278-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds some code optimizations and compatibility
handlings for the HNS3 ethernet driver.

change log:
V2: refactor #2 as Jukub Kicinski reported and remove the part
    about RSS size which will not be different in different hw.
    updates netdev->max_mtu as well in #4 reported by Jakub Kicinski.

previous version:
V1: https://patchwork.kernel.org/project/netdevbpf/cover/1612269593-18691-1-git-send-email-tanhuazhong@huawei.com/

Guangbin Huang (3):
  net: hns3: RSS indirection table use device specification
  net: hns3: debugfs add max tm rate specification print
  net: hns3: replace macro of max qset number with specification

GuoJia Liao (1):
  net: hns3: optimize the code when update the tc info

Jian Shen (1):
  net: hns3: add api capability bits for firmware

Yufeng Mo (1):
  net: hns3: add support for obtaining the maximum frame size

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  5 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  3 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  3 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  5 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  6 +--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c | 10 ++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  9 +++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |  8 ++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 57 +++++++++++++++-------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  8 +--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  | 15 ++++--
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   | 10 ++++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |  9 +++-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 47 ++++++++++++------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  8 +--
 15 files changed, 140 insertions(+), 63 deletions(-)

-- 
2.7.4

