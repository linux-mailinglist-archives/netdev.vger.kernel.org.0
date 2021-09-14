Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4023240AD49
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 14:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232546AbhINMQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 08:16:40 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9867 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232386AbhINMQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 08:16:39 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4H82Hf57LHz8yVq;
        Tue, 14 Sep 2021 20:10:54 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 14 Sep 2021 20:15:20 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 14 Sep 2021 20:15:19 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 0/2] PF support get MAC address space assigned by firmware
Date:   Tue, 14 Sep 2021 20:11:15 +0800
Message-ID: <20210914121117.13054-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series add support PF to get unicast/multicast MAC address space
assigned by firmware for the HNS3 ethernet driver.

Guangbin Huang (2):
  net: hns3: PF support get unicast MAC address space assigned by
    firmware
  net: hns3: PF support get multicast MAC address space assigned by
    firmware

 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  6 +++
 .../ethernet/hisilicon/hns3/hns3_debugfs.c    |  4 ++
 .../hisilicon/hns3/hns3pf/hclge_cmd.h         |  5 +-
 .../hisilicon/hns3/hns3pf/hclge_debugfs.c     |  3 ++
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 46 +++++++++++++++----
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  2 +
 6 files changed, 56 insertions(+), 10 deletions(-)

-- 
2.33.0

