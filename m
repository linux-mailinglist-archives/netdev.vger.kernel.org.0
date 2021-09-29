Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D744341C1BC
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 11:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbhI2Jly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 05:41:54 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:24122 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232113AbhI2Jlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 05:41:51 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HKBCD4vgLz1DHFR;
        Wed, 29 Sep 2021 17:38:48 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 17:40:07 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 17:40:06 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net 0/8] net: hns3: add some fixes for -net
Date:   Wed, 29 Sep 2021 17:35:48 +0800
Message-ID: <20210929093556.9146-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds some fixes for the HNS3 ethernet driver.

Guangbin Huang (3):
  net: hns3: PF enable promisc for VF when mac table is overflow
  net: hns3: fix always enable rx vlan filter problem after selftest
  net: hns3: disable firmware compatible features when uninstall PF

Jian Shen (5):
  net: hns3: do not allow call hns3_nic_net_open repeatedly
  net: hns3: remove tc enable checking
  net: hns3: don't rollback when destroy mqprio fail
  net: hns3: fix mixed flag HCLGE_FLAG_MQPRIO_ENABLE and
    HCLGE_FLAG_DCB_ENABLE
  net: hns3: fix show wrong state when add existing uc mac address

 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  1 -
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 16 ++++-----
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    |  6 ++--
 .../hisilicon/hns3/hns3pf/hclge_cmd.c         | 21 +++++++-----
 .../hisilicon/hns3/hns3pf/hclge_dcb.c         | 29 ++++++++--------
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 27 ++++++++-------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 33 +++----------------
 7 files changed, 60 insertions(+), 73 deletions(-)

-- 
2.33.0

