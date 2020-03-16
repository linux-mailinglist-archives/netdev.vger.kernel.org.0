Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E49831866AD
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 09:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730135AbgCPIkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 04:40:33 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:60422 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730048AbgCPIkd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 04:40:33 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4D83AD535B3E8090DE8B;
        Mon, 16 Mar 2020 16:40:29 +0800 (CST)
Received: from localhost.localdomain (10.175.34.53) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Mon, 16 Mar 2020 16:40:20 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aviad.krawczyk@huawei.com>, <luoxianjun@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <yin.yinshi@huawei.com>
Subject: [PATCH net 0/6] hinic: BugFixes
Date:   Mon, 16 Mar 2020 00:56:24 +0000
Message-ID: <20200316005630.9817-1-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.34.53]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a number of bugs which have been present since the first commit.

The bugs fixed in these patchs are hardly exposed unless given
very specific conditions.

Luo bin (6):
  hinic: fix process of long length skb without frags
  hinic: fix a bug of waitting for IO stopped
  hinic: fix the bug of clearing event queue
  hinic: fix out-of-order excution in arm cpu
  hinic: fix wrong para of wait_for_completion_timeout
  hinic: fix wrong value of MIN_SKB_LEN

 .../net/ethernet/huawei/hinic/hinic_ethtool.c |  1 +
 .../net/ethernet/huawei/hinic/hinic_hw_cmdq.c |  5 +-
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  | 51 +------------------
 .../net/ethernet/huawei/hinic/hinic_hw_eqs.c  | 27 +++++++---
 .../net/ethernet/huawei/hinic/hinic_hw_mgmt.c |  5 +-
 .../net/ethernet/huawei/hinic/hinic_main.c    |  1 +
 drivers/net/ethernet/huawei/hinic/hinic_rx.c  |  3 ++
 drivers/net/ethernet/huawei/hinic/hinic_tx.c  | 15 ++++--
 drivers/net/ethernet/huawei/hinic/hinic_tx.h  |  2 +-
 9 files changed, 46 insertions(+), 64 deletions(-)

-- 
2.17.1

