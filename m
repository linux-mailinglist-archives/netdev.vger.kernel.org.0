Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8825325A8C1
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 11:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgIBJlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 05:41:00 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:10793 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726311AbgIBJk5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 05:40:57 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 43738D050F2B76324935;
        Wed,  2 Sep 2020 17:40:55 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Wed, 2 Sep 2020 17:40:45 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
Subject: [PATCH net 0/3] hinic: BugFixes
Date:   Wed, 2 Sep 2020 17:41:42 +0800
Message-ID: <20200902094145.12216-1-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bugs fixed in this patchset have been present since the following commits:
patch #1: Fixes: 00e57a6d4ad3 ("net-next/hinic: Add Tx operation")
patch #2: Fixes: 5e126e7c4e52 ("hinic: add firmware update support")
patch #3: Fixes: 2eed5a8b614b ("hinic: add set_channels ethtool_ops support")

Luo bin (3):
  hinic: bump up the timeout of SET_FUNC_STATE cmd
  hinic: bump up the timeout of UPDATE_FW cmd
  hinic: fix bug of send pkts while setting channels

 .../net/ethernet/huawei/hinic/hinic_hw_mgmt.c | 20 ++++++++++++++-----
 drivers/net/ethernet/huawei/hinic/hinic_tx.c  |  5 +++++
 2 files changed, 20 insertions(+), 5 deletions(-)

-- 
2.17.1

