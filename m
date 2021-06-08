Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B54D39F764
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 15:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbhFHNNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 09:13:46 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3908 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbhFHNNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 09:13:37 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FzrCW40kfz6wL4;
        Tue,  8 Jun 2021 21:08:39 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 21:11:42 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 8 Jun 2021 21:11:38 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 0/5] net: hns3: add RAS compatibility adaptation solution
Date:   Tue, 8 Jun 2021 21:08:26 +0800
Message-ID: <1623157711-26846-1-git-send-email-huangguangbin2@huawei.com>
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

This patchset adds RAS compatibility adaptation solution for new devices.


Jiaran Zhang (4):
  net: hns3: add the RAS compatibility adaptation solution
  net: hns3: add support for imp-handle ras capability
  net: hns3: update error recovery module and type
  net: hns3: add error handling compatibility during initialization

Yufeng Mo (1):
  net: hns3: add support for handling all errors through MSI-X

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   4 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   3 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |   5 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   3 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 410 +++++++++++++++++++--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h |  89 +++++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  87 +++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   1 +
 8 files changed, 546 insertions(+), 56 deletions(-)

-- 
2.8.1

