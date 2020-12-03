Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5C82CD552
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 13:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730354AbgLCMTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 07:19:37 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:9366 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725960AbgLCMTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 07:19:36 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Cmvxs47jlz77y8;
        Thu,  3 Dec 2020 20:18:25 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Thu, 3 Dec 2020 20:18:46 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>, <huangdaode@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/3] net: hns3: updates for -next
Date:   Thu, 3 Dec 2020 20:18:53 +0800
Message-ID: <1606997936-22166-1-git-send-email-tanhuazhong@huawei.com>
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

Guojia Liao (2):
  net: hns3: add support for extended promiscuous command
  net: hns3: refine the VLAN tag handle for port based VLAN

Jian Shen (1):
  net: hns3: add priv flags support to switch limit promisc mode

 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |   1 +
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   8 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  12 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  87 ++++++++++++++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  34 ++++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 111 +++++++++++++--------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  13 ++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  18 +++-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   7 ++
 9 files changed, 225 insertions(+), 66 deletions(-)

-- 
2.7.4

