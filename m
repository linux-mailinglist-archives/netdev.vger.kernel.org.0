Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 482AB2B8A85
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 04:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgKSDyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 22:54:03 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8112 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgKSDyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 22:54:01 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Cc5Ps1xQ6zLpk0;
        Thu, 19 Nov 2020 11:53:37 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Thu, 19 Nov 2020 11:53:48 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [RFC net-next 0/2] net: updates for -next
Date:   Thu, 19 Nov 2020 11:54:08 +0800
Message-ID: <1605758050-21061-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#2 will add DIM for the HNS3 ethernet driver, then there will
be two implemation of IRQ adaptive coalescing (DIM and driver
custiom, so #1 adds a new netlink attribute to the
ETHTOOL_MSG_COALESCE_GET/ETHTOOL_MSG_COALESCE_SET commands
which controls the type of adaptive coalescing.

Huazhong Tan (2):
  ethtool: add support for controling the type of adaptive coalescing
  net: hns3: add support for dynamic interrupt moderation

 drivers/net/ethernet/hisilicon/Kconfig             |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 87 +++++++++++++++++++++-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  4 +
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  7 +-
 include/linux/ethtool.h                            |  1 +
 include/uapi/linux/ethtool.h                       |  2 +
 include/uapi/linux/ethtool_netlink.h               |  1 +
 net/ethtool/coalesce.c                             | 11 ++-
 net/ethtool/netlink.h                              |  2 +-
 9 files changed, 111 insertions(+), 5 deletions(-)

-- 
2.7.4

