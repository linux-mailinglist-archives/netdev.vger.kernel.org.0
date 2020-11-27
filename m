Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E186F2C6122
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 09:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbgK0Irq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 03:47:46 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7741 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728682AbgK0Iro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 03:47:44 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Cj7Xw3CnFzkh8s;
        Fri, 27 Nov 2020 16:47:12 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Fri, 27 Nov 2020 16:47:32 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/7] net: hns3: updates for -next
Date:   Fri, 27 Nov 2020 16:47:15 +0800
Message-ID: <1606466842-57749-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes some updates for the HNS3 ethernet driver.

#1~#6: add some updates related to the checksum offload.
#7: add support for multiple TCs' MAC pauce mode.

Huazhong Tan (6):
  net: hns3: add support for RX completion checksum
  net: hns3: add support for TX hardware checksum offload
  net: hns3: remove unsupported NETIF_F_GSO_UDP_TUNNEL_CSUM
  net: hns3: add udp tunnel checksum segmentation support
  net: hns3: add more info to hns3_dbg_bd_info()
  net: hns3: add a check for devcie's verion in hns3_tunnel_csum_bug()

Yonglong Liu (1):
  net: hns3: keep MAC pause mode when multiple TCs are enabled

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   7 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  62 ++++++++--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 131 ++++++++++++++++-----
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  21 +++-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |   4 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   3 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |  23 +++-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |   4 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |   3 +-
 10 files changed, 207 insertions(+), 52 deletions(-)

-- 
2.7.4

