Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 742662563CA
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 02:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgH2Aym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 20:54:42 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:42856 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726851AbgH2Ayk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 20:54:40 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 08435FE9F4B6E8E61A5D;
        Sat, 29 Aug 2020 08:54:38 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Sat, 29 Aug 2020 08:54:29 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
Subject: [PATCH net-next v3 0/3] hinic: add debugfs support
Date:   Sat, 29 Aug 2020 08:55:17 +0800
Message-ID: <20200829005520.27364-1-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add debugfs node for querying sq/rq info and function table

Luo bin (3):
  hinic: add support to query sq info
  hinic: add support to query rq info
  hinic: add support to query function table

 drivers/net/ethernet/huawei/hinic/Makefile    |   3 +-
 .../net/ethernet/huawei/hinic/hinic_debugfs.c | 315 ++++++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_debugfs.h | 114 +++++++
 drivers/net/ethernet/huawei/hinic/hinic_dev.h |  20 ++
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  |   1 +
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |   2 +
 .../net/ethernet/huawei/hinic/hinic_hw_io.c   |   2 +
 .../net/ethernet/huawei/hinic/hinic_hw_io.h   |   1 +
 .../net/ethernet/huawei/hinic/hinic_hw_qp.h   |   6 +
 .../net/ethernet/huawei/hinic/hinic_main.c    |  83 ++++-
 10 files changed, 541 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/ethernet/huawei/hinic/hinic_debugfs.c
 create mode 100644 drivers/net/ethernet/huawei/hinic/hinic_debugfs.h

-- 
2.17.1

