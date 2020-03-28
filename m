Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93CB6196418
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 08:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgC1HL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 03:11:29 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:35076 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725372AbgC1HL3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Mar 2020 03:11:29 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7B2DBC5F8853D19168C9;
        Sat, 28 Mar 2020 15:10:52 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Sat, 28 Mar 2020 15:10:43 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 0/4] net: hns3: fixes for -net
Date:   Sat, 28 Mar 2020 15:09:54 +0800
Message-ID: <1585379398-36224-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset includes some bugfixes for the HNS3 ethernet driver.

[patch 1] removes flag WQ_MEM_RECLAIM flag when allocating WE,
since it will cause a warning when the reset task flushes a IB's WQ.

[patch 2] adds a new DESC_TYPE_FRAGLIST_SKB type to handle the
linear data of the fraglist SKB, since it is different with the frag
data.

[patch 3] adds different handings for RSS configuration when load
or reset.

[patch 4] fixes a link ksetting issue.

Guangbin Huang (1):
  net: hns3: fix set and get link ksettings issue

Guojia Liao (1):
  net: hns3: fix RSS config lost after VF reset.

Huazhong Tan (1):
  net: hns3: fix for fraglist SKB headlen not handling correctly

Yunsheng Lin (1):
  net: hns3: drop the WQ_MEM_RECLAIM flag when allocating WQ

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 18 ++++++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 10 +++-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 54 ++++++++++++----------
 4 files changed, 51 insertions(+), 32 deletions(-)

-- 
2.7.4

