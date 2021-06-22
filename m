Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E963B0287
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 13:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbhFVLQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 07:16:47 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:7375 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbhFVLQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 07:16:46 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G8NwZ43Lnz70qs;
        Tue, 22 Jun 2021 19:10:22 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 22 Jun 2021 19:14:27 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 22 Jun 2021 19:14:26 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
        <mark.rutland@arm.com>, <dbrazdil@google.com>, <qperret@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 0/3] net: hns3: add support for TX push
Date:   Tue, 22 Jun 2021 19:11:08 +0800
Message-ID: <1624360271-17525-1-git-send-email-huangguangbin2@huawei.com>
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

This series adds TX push support for the HNS3 ethernet driver.

Huazhong Tan (2):
  net: hns3: add support for TX push mode
  net: hns3: add ethtool priv-flag for TX push

Xiongfeng Wang (1):
  arm64: barrier: add DGH macros to control memory accesses merging

 arch/arm64/include/asm/assembler.h                 |  7 ++
 arch/arm64/include/asm/barrier.h                   |  1 +
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  2 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 86 +++++++++++++++++++++-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  6 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 21 +++++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |  2 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 11 ++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  8 ++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |  2 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 11 ++-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  8 ++
 12 files changed, 156 insertions(+), 9 deletions(-)

-- 
2.8.1

