Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B693A20C7F6
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 14:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgF1MhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 08:37:23 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:40068 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726351AbgF1MhW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Jun 2020 08:37:22 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6757AE2EE1235DAD643E;
        Sun, 28 Jun 2020 20:37:21 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Sun, 28 Jun 2020 20:37:10 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
Subject: [PATCH net-next v4 0/5] hinic: add some ethtool ops support
Date:   Sun, 28 Jun 2020 20:36:19 +0800
Message-ID: <20200628123624.600-1-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

patch #1: support to set and get pause params with
          "ethtool -A/a" cmd
patch #2: support to set and get irq coalesce params with
          "ethtool -C/c" cmd
patch #3: support to do self test with "ethtool -t" cmd
patch #4: support to identify physical device with "ethtool -p" cmd
patch #5: support to get eeprom information with "ethtool -m" cmd

Luo bin (5):
  hinic: add support to set and get pause params
  hinic: add support to set and get irq coalesce
  hinic: add self test support
  hinic: add support to identify physical device
  hinic: add support to get eeprom information

 drivers/net/ethernet/huawei/hinic/hinic_dev.h |  14 +
 .../net/ethernet/huawei/hinic/hinic_ethtool.c | 600 +++++++++++++++++-
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  |  66 ++
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |  31 +
 .../net/ethernet/huawei/hinic/hinic_hw_io.h   |  10 +
 .../net/ethernet/huawei/hinic/hinic_hw_mgmt.h |   7 +-
 .../net/ethernet/huawei/hinic/hinic_main.c    | 128 +++-
 .../net/ethernet/huawei/hinic/hinic_port.c    | 194 ++++++
 .../net/ethernet/huawei/hinic/hinic_port.h    |  94 +++
 drivers/net/ethernet/huawei/hinic/hinic_rx.c  |  58 +-
 .../net/ethernet/huawei/hinic/hinic_sriov.c   |   4 +-
 drivers/net/ethernet/huawei/hinic/hinic_tx.c  |  80 +++
 drivers/net/ethernet/huawei/hinic/hinic_tx.h  |   2 +
 13 files changed, 1273 insertions(+), 15 deletions(-)

-- 
2.17.1

