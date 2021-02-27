Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A73326C18
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 08:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhB0HY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Feb 2021 02:24:58 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12650 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhB0HY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Feb 2021 02:24:57 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DndJN1FdPzlQ8B;
        Sat, 27 Feb 2021 15:22:12 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Sat, 27 Feb 2021 15:24:10 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [RESEND net 0/3] net: hns3: fixes fot -net
Date:   Sat, 27 Feb 2021 15:24:50 +0800
Message-ID: <1614410693-8107-1-git-send-email-tanhuazhong@huawei.com>
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

