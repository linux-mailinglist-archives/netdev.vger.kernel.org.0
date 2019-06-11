Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8038341A32
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 04:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408315AbfFLCC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 22:02:59 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:18134 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406409AbfFLCC7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jun 2019 22:02:59 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3ED3A3A692478715E748;
        Wed, 12 Jun 2019 10:02:56 +0800 (CST)
Received: from localhost.localdomain (10.175.34.53) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Wed, 12 Jun 2019 10:02:42 +0800
From:   Xue Chaojing <xuechaojing@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoshaokai@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <xuechaojing@huawei.com>, <chiqijun@huawei.com>,
        <wulike1@huawei.com>
Subject: [PATCH net-next v2 0/2] hinic: add rss support and rss paramters configuration
Date:   Tue, 11 Jun 2019 18:12:32 +0000
Message-ID: <20190611181234.4843-1-xuechaojing@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.34.53]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series add rss support for HINIC driver and implemente the ethtool
interface related to rss parameter configuration. user can use ethtool
configure rss parameters or show rss parameters.

Xue Chaojing (2):
  hinic: add rss support
  hinic: add support for rss parameters with ethtool

 drivers/net/ethernet/huawei/hinic/Makefile    |   2 +-
 drivers/net/ethernet/huawei/hinic/hinic_dev.h |  28 +
 .../net/ethernet/huawei/hinic/hinic_ethtool.c | 508 ++++++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  |  10 +-
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |  36 ++
 .../net/ethernet/huawei/hinic/hinic_hw_wqe.h  |  16 +
 .../net/ethernet/huawei/hinic/hinic_main.c    | 265 +++++----
 .../net/ethernet/huawei/hinic/hinic_port.c    | 379 +++++++++++++
 .../net/ethernet/huawei/hinic/hinic_port.h    | 129 +++++
 9 files changed, 1231 insertions(+), 142 deletions(-)
 create mode 100644 drivers/net/ethernet/huawei/hinic/hinic_ethtool.c

-- 
2.17.1

