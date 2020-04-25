Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83DBC1B8505
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 11:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgDYJEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 05:04:36 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:37490 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725837AbgDYJEg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Apr 2020 05:04:36 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 07F3F696E72F3DBC0483;
        Sat, 25 Apr 2020 17:04:32 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Sat, 25 Apr 2020 17:04:25 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <luobin9@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: [PATCH net-next v1 0/3] hinic: add SR-IOV support
Date:   Sat, 25 Apr 2020 01:21:08 +0000
Message-ID: <20200425012111.4297-1-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

patch #1 adds mailbox channel support and vf can
communicate with pf or hw through it.
patch #2 adds support for enabling vf and tx/rx
capabilities based on vf.
patch #3 adds support for vf's basic configurations.

Luo bin (3):
  hinic: add mailbox function support
  hinic: add sriov feature support
  hinic: add net_device_ops associated with vf

 drivers/net/ethernet/huawei/hinic/Makefile    |    2 +-
 drivers/net/ethernet/huawei/hinic/hinic_dev.h |    3 +
 .../net/ethernet/huawei/hinic/hinic_hw_cmdq.c |   18 +-
 .../net/ethernet/huawei/hinic/hinic_hw_cmdq.h |    2 +-
 .../net/ethernet/huawei/hinic/hinic_hw_csr.h  |    2 +-
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  |  148 +-
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |   48 +
 .../net/ethernet/huawei/hinic/hinic_hw_eqs.c  |   98 +-
 .../net/ethernet/huawei/hinic/hinic_hw_eqs.h  |    7 +-
 .../net/ethernet/huawei/hinic/hinic_hw_if.c   |   46 +-
 .../net/ethernet/huawei/hinic/hinic_hw_if.h   |   18 +
 .../net/ethernet/huawei/hinic/hinic_hw_io.c   |   49 +
 .../net/ethernet/huawei/hinic/hinic_hw_io.h   |   23 +-
 .../net/ethernet/huawei/hinic/hinic_hw_mbox.c | 1213 +++++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_hw_mbox.h |  154 +++
 .../net/ethernet/huawei/hinic/hinic_hw_mgmt.c |   17 +-
 .../net/ethernet/huawei/hinic/hinic_hw_mgmt.h |   12 +-
 .../net/ethernet/huawei/hinic/hinic_hw_qp.c   |    7 +-
 .../net/ethernet/huawei/hinic/hinic_hw_qp.h   |    4 +-
 .../net/ethernet/huawei/hinic/hinic_hw_wq.c   |    9 +-
 .../net/ethernet/huawei/hinic/hinic_hw_wq.h   |    6 +-
 .../net/ethernet/huawei/hinic/hinic_main.c    |  120 +-
 .../net/ethernet/huawei/hinic/hinic_port.c    |   76 +-
 .../net/ethernet/huawei/hinic/hinic_port.h    |    4 +-
 drivers/net/ethernet/huawei/hinic/hinic_rx.c  |   15 +-
 .../net/ethernet/huawei/hinic/hinic_sriov.c   | 1016 ++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_sriov.h   |  102 ++
 drivers/net/ethernet/huawei/hinic/hinic_tx.c  |   17 +-
 28 files changed, 3033 insertions(+), 203 deletions(-)
 create mode 100644 drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
 create mode 100644 drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.h
 create mode 100644 drivers/net/ethernet/huawei/hinic/hinic_sriov.c
 create mode 100644 drivers/net/ethernet/huawei/hinic/hinic_sriov.h

-- 
2.17.1

