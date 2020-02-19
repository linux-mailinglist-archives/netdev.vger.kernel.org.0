Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D989816394C
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 02:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgBSBYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 20:24:20 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10209 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727940AbgBSBYN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 20:24:13 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9FAEE2C74B945B3103F0;
        Wed, 19 Feb 2020 09:24:07 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Wed, 19 Feb 2020 09:23:59 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/4] net: hns3: misc updates for -net-next
Date:   Wed, 19 Feb 2020 09:23:29 +0800
Message-ID: <1582075413-34966-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes some misc updates for the HNS3
ethernet driver.

[patch 1] modifies an unsuitable print when setting dulex mode.
[patch 2] adds some debugfs info for TC and DWRR.
[patch 3] adds some debugfs info for loopback.
[patch 4] adds a missing help info for QS shaper in debugfs.

Guangbin Huang (1):
  net: hns3: modify an unsuitable print when setting unknown duplex to
    fibre

Yonglong Liu (2):
  net: hns3: add enabled TC numbers and DWRR weight info in debugfs
  net: hns3: add missing help info for QS shaper in debugfs

Yufeng Mo (1):
  net: hns3: add support for dump MAC ID and loopback status in debugfs

 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  2 +
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 63 ++++++++++++++++++++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  3 ++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  1 +
 5 files changed, 67 insertions(+), 4 deletions(-)

-- 
2.7.4

