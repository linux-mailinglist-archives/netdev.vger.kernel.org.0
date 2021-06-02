Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD896397F43
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 05:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhFBDCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 23:02:33 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2943 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbhFBDCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 23:02:32 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FvtxW0Bqqz691Z;
        Wed,  2 Jun 2021 10:57:51 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 2 Jun 2021 11:00:48 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 2 Jun 2021 11:00:47 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <richardcochran@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>,
        <tanhuazhong@huawei.com>, <huangguangbin2@huawei.com>
Subject: [RESEND net-next 0/2] net: hns3: add support for PTP
Date:   Wed, 2 Jun 2021 10:57:42 +0800
Message-ID: <1622602664-20274-1-git-send-email-huangguangbin2@huawei.com>
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

This series adds PTP support for the HNS3 ethernet driver.

Huazhong Tan (2):
  net: hns3: add support for PTP
  net: hns3: add debugfs support for ptp info

 drivers/net/ethernet/hisilicon/Kconfig             |   1 +
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  13 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  13 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  27 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   9 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  12 +
 .../net/ethernet/hisilicon/hns3/hns3pf/Makefile    |   2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   4 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |  55 +++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  57 ++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   6 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c | 520 +++++++++++++++++++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h | 133 ++++++
 13 files changed, 844 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h

-- 
2.8.1

