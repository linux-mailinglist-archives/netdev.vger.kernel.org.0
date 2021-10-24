Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E99E438805
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 11:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbhJXJr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 05:47:59 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:29928 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbhJXJr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 05:47:57 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HcY495P3Vzbmyx;
        Sun, 24 Oct 2021 17:40:57 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sun, 24 Oct 2021 17:45:34 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sun, 24 Oct 2021 17:45:33 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH V2 net-next 0/8] net: hns3: updates for -next
Date:   Sun, 24 Oct 2021 17:41:07 +0800
Message-ID: <20211024094115.42158-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes some updates for the HNS3 ethernet driver.

#1 debugfs support for dumping interrupt coalesce.
#2~#3 improve compatibility of mac statistic and add pause/pfc durations
      for it.
#5~#6 add update ethtool advertised link modes for FIBRE port when autoneg
      off.
#7~#8 add some error types for ras.


Guangbin Huang (5):
  net: hns3: modify mac statistics update process for compatibility
  net: hns3: device specifications add number of mac statistics
  net: hns3: add support pause/pfc durations for mac statistics
  net: hns3: modify functions of converting speed ability to ethtool
    link mode
  net: hns3: add update ethtool advertised link modes for FIBRE port
    when autoneg off

Huazhong Tan (1):
  net: hns3: add debugfs support for interrupt coalesce

Jiaran Zhang (1):
  net: hns3: add error recovery module and type for himac

Weihang Li (1):
  net: hns3: add new ras error type for roce

 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |   2 +
 .../ethernet/hisilicon/hns3/hns3_debugfs.c    | 121 +++++
 .../net/ethernet/hisilicon/hns3/hns3_enet.h   |   3 +-
 .../hisilicon/hns3/hns3pf/hclge_cmd.c         |   1 +
 .../hisilicon/hns3/hns3pf/hclge_cmd.h         |   1 +
 .../hisilicon/hns3/hns3pf/hclge_err.c         |  14 +-
 .../hisilicon/hns3/hns3pf/hclge_err.h         |   4 +
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 507 ++++++++++++------
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  32 +-
 9 files changed, 504 insertions(+), 181 deletions(-)

-- 
2.33.0

