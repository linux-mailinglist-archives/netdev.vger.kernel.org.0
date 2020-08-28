Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEAA3255361
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 05:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgH1DhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 23:37:06 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:10289 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726803AbgH1DhF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 23:37:05 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9DAB6124859823B713CA;
        Fri, 28 Aug 2020 11:37:03 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Fri, 28 Aug 2020 11:36:55 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
Subject: [PATCH net-next v2 0/3] hinic: add debugfs support
Date:   Fri, 28 Aug 2020 11:37:45 +0800
Message-ID: <20200828033748.26172-1-luobin9@huawei.com>
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
 .../net/ethernet/huawei/hinic/hinic_debugfs.c | 318 ++++++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_debugfs.h | 114 +++++++
 drivers/net/ethernet/huawei/hinic/hinic_dev.h |  20 ++
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  |   1 +
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |   2 +
 .../net/ethernet/huawei/hinic/hinic_hw_io.c   |   2 +
 .../net/ethernet/huawei/hinic/hinic_hw_io.h   |   1 +
 .../net/ethernet/huawei/hinic/hinic_hw_qp.h   |   6 +
 .../net/ethernet/huawei/hinic/hinic_main.c    |  83 ++++-
 10 files changed, 544 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/ethernet/huawei/hinic/hinic_debugfs.c
 create mode 100644 drivers/net/ethernet/huawei/hinic/hinic_debugfs.h

-- 
2.17.1

