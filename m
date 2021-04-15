Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D19AE35FFEA
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 04:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbhDOCVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 22:21:07 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:16462 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhDOCVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 22:21:07 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FLNLB35gqzwS2J;
        Thu, 15 Apr 2021 10:18:26 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Thu, 15 Apr 2021 10:20:34 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH RESEND net-next 0/2] net: hns3: updates for -next
Date:   Thu, 15 Apr 2021 10:20:37 +0800
Message-ID: <1618453239-10451-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for pushing link status to VFs for
the HNS3 ethernet driver.

Guangbin Huang (2):
  net: hns3: PF add support for pushing link status to VFs
  net: hns3: VF not request link status when PF support push link status
    feature

 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |  3 ++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 35 +++++++++++++++++++++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 12 ++++----
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  8 +++--
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  1 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c   |  6 ++++
 7 files changed, 55 insertions(+), 11 deletions(-)

-- 
2.7.4

