Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13B13B319A
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 16:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbhFXOmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 10:42:32 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:8440 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbhFXOm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 10:42:29 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G9jQ56vX3zZkh7;
        Thu, 24 Jun 2021 22:37:01 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 24 Jun 2021 22:40:03 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 24 Jun 2021 22:40:02 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 0/3] net: hns3: add new debugfs commands
Date:   Thu, 24 Jun 2021 22:36:42 +0800
Message-ID: <1624545405-37050-1-git-send-email-huangguangbin2@huawei.com>
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

This series adds three new debugfs commands for the HNS3 ethernet driver.

Guangbin Huang (1):
  net: hns3: add support for link diagnosis info in debugfs

Jian Shen (2):
  net: hns3: add support for FD counter in debugfs
  net: hns3: add support for dumping MAC umv counter in debugfs

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   3 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  22 ++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  12 ++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 129 +++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  10 +-
 5 files changed, 174 insertions(+), 2 deletions(-)

-- 
2.8.1

