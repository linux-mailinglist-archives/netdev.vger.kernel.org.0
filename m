Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78B42362E3C
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 09:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbhDQHKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 03:10:03 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17006 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbhDQHKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 03:10:00 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FMkdV1V3tzPqwq;
        Sat, 17 Apr 2021 15:06:22 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Sat, 17 Apr 2021 15:09:09 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/3] net: hns3: misc updates for -next
Date:   Sat, 17 Apr 2021 15:09:21 +0800
Message-ID: <1618643364-64872-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes some misc updates for the HNS3 ethernet driver.

Huazhong Tan (3):
  net: hns3: remove a duplicate pf reset counting
  net: hns3: cleanup inappropriate spaces in struct hlcgevf_tqp_stats
  net: hns3: change the value of the SEPARATOR_VALUE macro in
    hclgevf_main.c

 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 2 --
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h | 4 ++--
 3 files changed, 3 insertions(+), 5 deletions(-)

-- 
2.7.4

