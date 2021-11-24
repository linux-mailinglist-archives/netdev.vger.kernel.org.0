Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F22E345B105
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 02:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbhKXBOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 20:14:43 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:27287 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbhKXBOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 20:14:40 -0500
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HzNHz2Hh4zbhmT;
        Wed, 24 Nov 2021 09:11:27 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 24 Nov 2021 09:11:28 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 24 Nov 2021 09:11:28 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 0/4] net: hns3: updates for -next
Date:   Wed, 24 Nov 2021 09:06:50 +0800
Message-ID: <20211124010654.6753-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes some updates for the HNS3 ethernet driver.

Jie Wang (1):
  net: hns3: debugfs add drop packet statistics of multicast and
    broadcast for igu

Yufeng Mo (3):
  net: hns3: add log for workqueue scheduled late
  net: hns3: format the output of the MAC address
  net: hns3: add dql info when tx timeout

 .../net/ethernet/hisilicon/hns3/hclge_mbx.h   |  3 +
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   | 14 ++++
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 36 ++++++---
 .../hisilicon/hns3/hns3pf/hclge_debugfs.h     |  8 +-
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 77 +++++++++++++------
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  2 +
 .../hisilicon/hns3/hns3pf/hclge_mbx.c         |  8 ++
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      |  7 +-
 8 files changed, 118 insertions(+), 37 deletions(-)

-- 
2.33.0

