Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69D81B2648
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 14:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbgDUMkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 08:40:04 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2857 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728745AbgDUMkC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 08:40:02 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 80C2F258C8F39C28579D;
        Tue, 21 Apr 2020 20:39:59 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Tue, 21 Apr 2020 20:39:51 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <luobin9@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: [PATCH net-next 0/3] hinic: add SR-IOV support
Date:   Tue, 21 Apr 2020 04:56:32 +0000
Message-ID: <20200421045635.8128-1-luobin9@huawei.com>
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
 .../net/ethernet/huawei/hinic/hinic_hw_cmdq.c |    5 -
 .../net/ethernet/huawei/hinic/hinic_hw_csr.h  |    2 +-
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  |  141 +-
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |   48 +
 .../net/ethernet/huawei/hinic/hinic_hw_eqs.c  |   98 +-
 .../net/ethernet/huawei/hinic/hinic_hw_eqs.h  |    7 +-
 .../net/ethernet/huawei/hinic/hinic_hw_if.c   |   46 +-
 .../net/ethernet/huawei/hinic/hinic_hw_if.h   |   18 +
 .../net/ethernet/huawei/hinic/hinic_hw_io.c   |    1 +
 .../net/ethernet/huawei/hinic/hinic_hw_io.h   |    6 +-
 .../net/ethernet/huawei/hinic/hinic_hw_mbox.c | 1217 +++++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_hw_mbox.h |  154 +++
 .../net/ethernet/huawei/hinic/hinic_hw_mgmt.c |   13 +-
 .../net/ethernet/huawei/hinic/hinic_hw_mgmt.h |   10 +-
 .../net/ethernet/huawei/hinic/hinic_main.c    |  100 +-
 .../net/ethernet/huawei/hinic/hinic_port.c    |   75 +-
 .../net/ethernet/huawei/hinic/hinic_port.h    |    4 +-
 drivers/net/ethernet/huawei/hinic/hinic_rx.c  |   15 +-
 .../net/ethernet/huawei/hinic/hinic_sriov.c   | 1007 ++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_sriov.h   |  102 ++
 drivers/net/ethernet/huawei/hinic/hinic_tx.c  |   17 +-
 23 files changed, 2909 insertions(+), 182 deletions(-)
 create mode 100644 drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
 create mode 100644 drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.h
 create mode 100644 drivers/net/ethernet/huawei/hinic/hinic_sriov.c
 create mode 100644 drivers/net/ethernet/huawei/hinic/hinic_sriov.h

-- 
2.17.1

