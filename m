Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA6E389B4F
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 04:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhETCXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 22:23:21 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4544 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbhETCXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 22:23:17 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Flths4VdNzkXK1;
        Thu, 20 May 2021 10:19:09 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 10:21:54 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 10:21:54 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 00/15] net: hns3: refactor some debugfs commands
Date:   Thu, 20 May 2021 10:21:29 +0800
Message-ID: <1621477304-4495-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series refactors the debugfs command to the new
process and removes the useless debugfs file node cmd
for the HNS3 ethernet driver.

Guangbin Huang (7):
  net: hns3: refactor dump tm map of debugfs
  net: hns3: refactor dump tm of debugfs
  net: hns3: refactor dump tc of debugfs
  net: hns3: refactor dump qos pause cfg of debugfs
  net: hns3: refactor dump qos pri map of debugfs
  net: hns3: refactor dump qos buf cfg of debugfs
  net: hns3: refactor dump qs shaper of debugfs

Hao Chen (3):
  net: hns3: refactor queue map of debugfs
  net: hns3: refactor queue info of debugfs
  net: hns3: refactor dump fd tcam of debugfs

Jiaran Zhang (1):
  net: hns3: refactor dump mac tnl status of debugfs

Yufeng Mo (4):
  net: hns3: refactor dump reg of debugfs
  net: hns3: refactor dump reg dcb info of debugfs
  net: hns3: refactor dump serv info of debugfs
  net: hns3: remove the useless debugfs file node cmd

 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   25 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  646 +++++---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h |    4 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 1698 +++++++++++---------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h |   13 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |    1 -
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |    1 -
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |  215 ++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  |   19 +-
 9 files changed, 1585 insertions(+), 1037 deletions(-)

-- 
2.7.4

