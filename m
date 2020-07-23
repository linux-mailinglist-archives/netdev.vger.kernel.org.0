Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66BAF22B183
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 16:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbgGWOkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 10:40:45 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8263 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727108AbgGWOkp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 10:40:45 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 1308033FFAF8697FDF49;
        Thu, 23 Jul 2020 22:40:42 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Thu, 23 Jul 2020 22:40:33 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
Subject: [PATCH net-next v3 0/2] hinic: add some error messages for debug
Date:   Thu, 23 Jul 2020 22:40:36 +0800
Message-ID: <20200723144038.10430-1-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

patch #1: support to handle hw abnormal event
patch #2: improve the error messages when functions return failure and
	  dump relevant registers in some exception handling processes

Luo bin (2):
  hinic: add support to handle hw abnormal event
  hinic: add log in exception handling processes

 drivers/net/ethernet/huawei/hinic/hinic_dev.h |   4 +
 .../net/ethernet/huawei/hinic/hinic_devlink.c | 299 +++++++++++++++++-
 .../net/ethernet/huawei/hinic/hinic_devlink.h |   8 +-
 .../net/ethernet/huawei/hinic/hinic_ethtool.c |  20 ++
 .../ethernet/huawei/hinic/hinic_hw_api_cmd.c  |  27 +-
 .../ethernet/huawei/hinic/hinic_hw_api_cmd.h  |   4 +
 .../net/ethernet/huawei/hinic/hinic_hw_cmdq.c |   2 +
 .../net/ethernet/huawei/hinic/hinic_hw_cmdq.h |   2 +
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  | 160 +++++++++-
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  | 148 ++++++++-
 .../net/ethernet/huawei/hinic/hinic_hw_eqs.c  |  39 +++
 .../net/ethernet/huawei/hinic/hinic_hw_eqs.h  |   6 +-
 .../net/ethernet/huawei/hinic/hinic_hw_if.c   |  23 ++
 .../net/ethernet/huawei/hinic/hinic_hw_if.h   |  10 +-
 .../net/ethernet/huawei/hinic/hinic_hw_mbox.c |   2 +
 .../net/ethernet/huawei/hinic/hinic_hw_mgmt.c |  11 +
 .../net/ethernet/huawei/hinic/hinic_hw_mgmt.h |   4 +
 .../net/ethernet/huawei/hinic/hinic_main.c    |  87 +++--
 .../net/ethernet/huawei/hinic/hinic_port.c    |  62 ++--
 .../net/ethernet/huawei/hinic/hinic_port.h    |  25 ++
 .../net/ethernet/huawei/hinic/hinic_sriov.c   |   6 +-
 21 files changed, 868 insertions(+), 81 deletions(-)

-- 
2.17.1

