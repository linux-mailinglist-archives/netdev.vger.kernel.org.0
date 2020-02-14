Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08D6B15CF98
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 02:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbgBNByc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 20:54:32 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10170 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728193AbgBNByK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 20:54:10 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 9886A58D8AFD5AD66025;
        Fri, 14 Feb 2020 09:54:06 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.439.0; Fri, 14 Feb 2020 09:53:59 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 0/3] net: hns3: fixes for -net
Date:   Fri, 14 Feb 2020 09:53:40 +0800
Message-ID: <1581645223-23038-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes three bugfixes for the HNS3 ethernet driver.

[patch 1] fixes a management table lost issue after IMP reset.
[patch 2] fixes a VF bandwidth configuration not work problem.
[patch 3] fixes a problem related to IPv6 address copying.

Guangbin Huang (1):
  net: hns3: fix a copying IPv6 address error in
    hclge_fd_get_flow_tuples()

Yonglong Liu (1):
  net: hns3: fix VF bandwidth does not take effect in some case

Yufeng Mo (1):
  net: hns3: add management table after IMP reset

 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 22 ++++++++++++++++------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |  2 +-
 2 files changed, 17 insertions(+), 7 deletions(-)

-- 
2.7.4

