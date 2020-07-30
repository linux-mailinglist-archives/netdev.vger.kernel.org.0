Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC348232EC4
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 10:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729064AbgG3IhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 04:37:20 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50780 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726819AbgG3IhQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 04:37:16 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 4FDB4758B7B5377C1197;
        Thu, 30 Jul 2020 16:37:13 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Thu, 30 Jul 2020 16:37:03 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
Subject: [PATCH net-next v1 0/2] hinic: mailbox channel enhancement
Date:   Thu, 30 Jul 2020 16:37:14 +0800
Message-ID: <20200730083716.4613-1-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add support to generate mailbox random id for VF to ensure that
the mailbox message from VF is valid and PF should check whether
the cmd from VF is supported before passing it to hw.

Luo bin (2):
  hinic: add generating mailbox random index support
  hinic: add check for mailbox msg from VF

 .../net/ethernet/huawei/hinic/hinic_hw_cmdq.h |   8 +
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |  13 +
 .../net/ethernet/huawei/hinic/hinic_hw_mbox.c | 309 +++++++++++++++++-
 .../net/ethernet/huawei/hinic/hinic_hw_mbox.h |  22 ++
 .../net/ethernet/huawei/hinic/hinic_hw_mgmt.h |   2 +
 .../net/ethernet/huawei/hinic/hinic_sriov.c   |  69 +++-
 6 files changed, 421 insertions(+), 2 deletions(-)

-- 
2.17.1

