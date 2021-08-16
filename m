Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7312D3ECCA3
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 04:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbhHPCTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 22:19:50 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8020 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhHPCTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Aug 2021 22:19:47 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GnyWx3QdPzYq1g;
        Mon, 16 Aug 2021 10:18:53 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 16 Aug 2021 10:19:14 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 16 Aug 2021 10:19:14 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <amitc@mellanox.com>,
        <idosch@idosch.org>, <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH RESEND V2 net-next 0/4] net: hns3: add support ethtool extended link state
Date:   Mon, 16 Aug 2021 10:15:25 +0800
Message-ID: <1629080129-46507-1-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for ethtool extended link state in the HNS3
ethernet driver to add one additional information for user to know
why a link is not up.

change log:
V1 -> V2:
1. fix missing a P for "-EOPNOTSUP".
2. delete unnecessary error log of this feature is not supported by
   devices of earlier version.

Guangbin Huang (4):
  docs: ethtool: Add two link extended substates of bad signal integrity
  ethtool: add two link extended substates of bad signal integrity
  net: hns3: add header file hns3_ethtoo.h
  net: hns3: add support ethtool extended link state

 Documentation/networking/ethtool-netlink.rst       |  8 +++
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  2 +
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 82 ++++++++++++++++++----
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.h | 31 ++++++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  3 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 24 +++++++
 include/uapi/linux/ethtool.h                       |  2 +
 7 files changed, 137 insertions(+), 15 deletions(-)
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.h

-- 
2.8.1

