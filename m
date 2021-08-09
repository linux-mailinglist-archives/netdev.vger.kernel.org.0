Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C093E480A
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 16:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234478AbhHIOys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 10:54:48 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7812 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234237AbhHIOyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 10:54:47 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Gjzcg6DXLzYcrv;
        Mon,  9 Aug 2021 22:54:11 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 9 Aug 2021 22:54:24 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 9 Aug 2021 22:54:24 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 0/4] net: hns3: add support ethtool extended link state
Date:   Mon, 9 Aug 2021 22:50:38 +0800
Message-ID: <1628520642-30839-1-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for ethtool extended link state in the HNS3
ethernet driver.

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
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 27 +++++++
 include/uapi/linux/ethtool.h                       |  2 +
 7 files changed, 140 insertions(+), 15 deletions(-)
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.h

-- 
2.8.1

