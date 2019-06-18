Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA0AA4A385
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 16:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729773AbfFROLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 10:11:09 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:19037 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729042AbfFROLG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 10:11:06 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 894898EEA09397824F9B;
        Tue, 18 Jun 2019 22:11:02 +0800 (CST)
Received: from localhost.localdomain (10.175.34.53) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Tue, 18 Jun 2019 22:10:54 +0800
From:   Xue Chaojing <xuechaojing@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoshaokai@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <xuechaojing@huawei.com>, <chiqijun@huawei.com>,
        <wulike1@huawei.com>
Subject: [PATCH net-next v5 0/3] hinic: add rss support and rss parameters configuration
Date:   Tue, 18 Jun 2019 06:20:50 +0000
Message-ID: <20190618062053.7545-1-xuechaojing@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.34.53]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series add rss support for HINIC driver and implement the ethtool
interface related to rss parameter configuration. user can use ethtool
configure rss parameters or show rss parameters.

Xue Chaojing (3):
  hinic: add rss support
  hinic: move ethtool code into hinic_ethtool
  hinic: add support for rss parameters with ethtool

 drivers/net/ethernet/huawei/hinic/Makefile    |   2 +-
 drivers/net/ethernet/huawei/hinic/hinic_dev.h |  28 ++
 .../net/ethernet/huawei/hinic/hinic_ethtool.c | 458 ++++++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  |  10 +-
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |  36 ++
 .../net/ethernet/huawei/hinic/hinic_hw_wqe.h  |  16 +
 .../net/ethernet/huawei/hinic/hinic_main.c    | 260 +++++-----
 .../net/ethernet/huawei/hinic/hinic_port.c    | 389 +++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_port.h    | 129 +++++
 9 files changed, 1186 insertions(+), 142 deletions(-)
 create mode 100644 drivers/net/ethernet/huawei/hinic/hinic_ethtool.c

-- 
2.17.1

