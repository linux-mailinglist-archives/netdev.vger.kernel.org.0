Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D66A218298E
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 08:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388149AbgCLHMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 03:12:21 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:11632 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388069AbgCLHMT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 03:12:19 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id ED8102E6CF4DC1D5E059;
        Thu, 12 Mar 2020 15:12:13 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Thu, 12 Mar 2020 15:12:05 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 0/4] net: hns3: fixes for -net
Date:   Thu, 12 Mar 2020 15:11:02 +0800
Message-ID: <1583997066-24773-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes several bugfixes for the HNS3 ethernet driver.

[patch 1] fixes an "tc qdisc del" failure.
[patch 2] fixes SW & HW VLAN table not consistent issue.
[patch 3] fixes a RMW issue related to VLAN filter switch.
[patch 4] clears port based VLAN when uploading PF.

Jian Shen (3):
  net: hns3: fix VF VLAN table entries inconsistent issue
  net: hns3: fix RMW issue for VLAN filter switch
  net: hns3: clear port base VLAN when unload PF

Yonglong Liu (1):
  net: hns3: fix "tc qdisc del" failed issue

 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 43 ++++++++++++++++++++--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  1 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  3 ++
 5 files changed, 45 insertions(+), 5 deletions(-)

-- 
2.7.4

