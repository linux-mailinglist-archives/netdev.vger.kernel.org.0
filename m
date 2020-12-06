Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10CD42D005B
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 05:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgLFEHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 23:07:50 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:8949 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgLFEHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 23:07:48 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CpXt53Y24zhm7Z;
        Sun,  6 Dec 2020 12:05:49 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Sun, 6 Dec 2020 12:06:04 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>, <huangdaode@huawei.com>,
        <shenjian15@huawei.com>, "Huazhong Tan" <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 0/3] net: hns3: updates for -next
Date:   Sun, 6 Dec 2020 12:06:12 +0800
Message-ID: <1607227575-56689-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some updates for the HNS3 ethernet driver.

#1 supports an extended promiscuous command which makes
promiscuous configuration more flexible, #2 adds ethtool
private flags to control whether enable tx unicast promisc.
#3 refine the vlan tag handling for port based vlan.

change log:
V2: modifies #2 suggested by Jakub Kicinski.
    fixes some spelling mistake in #3.

previous version:
https://patchwork.kernel.org/project/netdevbpf/cover/1606997936-22166-1-git-send-email-tanhuazhong@huawei.com/

Guojia Liao (2):
  net: hns3: add support for extended promiscuous command
  net: hns3: refine the VLAN tag handle for port based VLAN

Jian Shen (1):
  net: hns3: add priv flags support to switch limit promisc mode

 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |   1 +
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   8 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  11 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  86 ++++++++++++++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  34 ++++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 111 +++++++++++++--------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  13 ++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  18 +++-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   7 ++
 9 files changed, 223 insertions(+), 66 deletions(-)

-- 
2.7.4

