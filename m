Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64DF336A14
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 03:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhCKCOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 21:14:15 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:13904 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbhCKCNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 21:13:46 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DwssD27c2zkXKW;
        Thu, 11 Mar 2021 10:12:16 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Thu, 11 Mar 2021 10:13:37 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/2] net: hns3: two updates for -next
Date:   Thu, 11 Mar 2021 10:14:10 +0800
Message-ID: <1615428852-2637-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes two updates for the HNS3 ethernet driver.

Yufeng Mo (2):
  net: hns3: use FEC capability queried from firmware
  net: hns3: use pause capability queried from firmware

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  4 ++++
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  3 +++
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  8 +++++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |  9 +++++++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  2 ++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 26 +++++++++++++++-------
 6 files changed, 43 insertions(+), 9 deletions(-)

-- 
2.7.4

