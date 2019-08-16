Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4D2F8FD65
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 10:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbfHPIMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 04:12:36 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50786 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726866AbfHPIMH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 04:12:07 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 69CAC77673F27F850E45;
        Fri, 16 Aug 2019 16:11:58 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Fri, 16 Aug 2019 16:11:48 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/6] net: hns3: add some cleanups & bugfix
Date:   Fri, 16 Aug 2019 16:09:36 +0800
Message-ID: <1565942982-12105-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch-set includes cleanups and bugfix for the HNS3 ethernet
controller driver.

[patch 01/06 - 03/06] adds some cleanups.

[patch 04/06] changes the print level of RAS.

[patch 05/06] fixes a bug related to MAC TNL.

[patch 06/06] adds phy_attached_info().

Guojia Liao (3):
  net: hns3: add or modify comments
  net: hns3: modify redundant initialization of variable
  net: hns3: fix error and incorrect format

Huazhong Tan (1):
  net: hns3: prevent unnecessary MAC TNL interrupt

Xiaofei Tan (1):
  net: hns3: change print level of RAS error log from warning to error

Yonglong Liu (1):
  net: hns3: add phy_attached_info() to the hns3 driver

 drivers/net/ethernet/hisilicon/hns3/hnae3.c        |  9 +--
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        | 12 +--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  8 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  8 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  6 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |  3 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 90 +++++++++++-----------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 17 ++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  1 -
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c    |  2 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |  2 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |  2 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 11 ++-
 14 files changed, 89 insertions(+), 84 deletions(-)

-- 
2.7.4

