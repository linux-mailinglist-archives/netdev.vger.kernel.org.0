Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3D23A92CE
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 08:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbhFPGlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 02:41:40 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:7291 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbhFPGlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 02:41:36 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G4b505zZvz1BLxZ;
        Wed, 16 Jun 2021 14:34:28 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 14:39:29 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 14:39:29 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 0/7] net: hns3: updates for -next
Date:   Wed, 16 Jun 2021 14:36:10 +0800
Message-ID: <1623825377-41948-1-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes some optimization in IO path for the HNS3 ethernet
driver.

Huazhong Tan (1):
  net: hns3: add support to query tx spare buffer size for pf

Yunsheng Lin (6):
  net: hns3: minor refactor related to desc_cb handling
  net: hns3: refactor for hns3_fill_desc() function
  net: hns3: use tx bounce buffer for small packets
  net: hns3: support dma_map_sg() for multi frags skb
  net: hns3: optimize the rx page reuse handling process
  net: hns3: use bounce buffer when rx page can not be reused

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   8 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  54 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 575 ++++++++++++++++++---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  58 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  66 +++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   2 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  14 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   2 +
 8 files changed, 680 insertions(+), 99 deletions(-)

-- 
2.8.1

