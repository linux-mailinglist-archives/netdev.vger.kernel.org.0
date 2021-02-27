Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467AB326B5E
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 04:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhB0DeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 22:34:23 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:13383 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbhB0DeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 22:34:20 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DnXBm1Xxvz7qy3;
        Sat, 27 Feb 2021 11:32:00 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Sat, 27 Feb 2021 11:33:27 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 0/3] net: hns3: fixes fot -net
Date:   Sat, 27 Feb 2021 11:34:04 +0800
Message-ID: <1614396847-6001-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patchset includes some fixes for the HNS3 ethernet driver.

Jian Shen (3):
  net: hns3: fix error mask definition of flow director
  net: hns3: fix query vlan mask value error for flow director
  net: hns3: fix bug when calculating the TCAM table info

 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h  | 6 +++---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 7 +++----
 2 files changed, 6 insertions(+), 7 deletions(-)

-- 
2.7.4

