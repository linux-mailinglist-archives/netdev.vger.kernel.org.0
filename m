Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5897171D69
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 15:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389926AbgB0OU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 09:20:29 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:45752 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389728AbgB0OUY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 09:20:24 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 814B096DA91F34D52009;
        Thu, 27 Feb 2020 22:20:17 +0800 (CST)
Received: from localhost.localdomain (10.175.34.53) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.439.0; Thu, 27 Feb 2020 22:20:09 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, Luo bin <luobin9@huawei.com>
Subject: [PATCH net v1 0/3] hinic:BugFixes
Date:   Thu, 27 Feb 2020 06:34:41 +0000
Message-ID: <20200227063444.2143-1-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.34.53]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the bug fixed in patch #2 has been present since the first commit.
the bugs fixed in patch #1 and patch #3 have been present since the
following commits:
patch #1: 352f58b0d9f2 ("net-next/hinic: Set Rxq irq to specific cpu for NUMA")
patch #3: 421e9526288b ("hinic: add rss support")

Luo bin (3):
  hinic: fix a irq affinity bug
  hinic: fix a bug of setting hw_ioctxt
  hinic: fix a bug of rss configuration

 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c | 1 +
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h | 2 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_if.h  | 1 +
 drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h  | 1 +
 drivers/net/ethernet/huawei/hinic/hinic_main.c   | 3 ++-
 drivers/net/ethernet/huawei/hinic/hinic_rx.c     | 5 ++---
 6 files changed, 8 insertions(+), 5 deletions(-)

-- 
2.17.1

