Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4143B4BBE
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 03:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbhFZBGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 21:06:00 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5080 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbhFZBF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 21:05:58 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GBb8Y29BQzXlBy;
        Sat, 26 Jun 2021 08:58:21 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 26 Jun 2021 09:03:35 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 26 Jun 2021 09:03:34 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH V2 net-next 0/2] net: hns3: add new debugfs commands
Date:   Sat, 26 Jun 2021 09:00:15 +0800
Message-ID: <1624669217-38264-1-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds three new debugfs commands for the HNS3 ethernet driver.

change log:
V1 -> V2:
1. remove patch "net: hns3: add support for link diagnosis info in debugfs"
   and use ethtool extended link state to implement similar function
   according to Jakub Kicinski's opinion.



Jian Shen (2):
  net: hns3: add support for FD counter in debugfs
  net: hns3: add support for dumping MAC umv counter in debugfs

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  2 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 14 +++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  9 +++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 71 ++++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 10 ++-
 5 files changed, 104 insertions(+), 2 deletions(-)

-- 
2.8.1

