Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64436465FA9
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 09:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345742AbhLBIoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 03:44:07 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:28147 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbhLBIoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 03:44:06 -0500
Received: from kwepemi500010.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4J4TqX2pwLz1DJcQ;
        Thu,  2 Dec 2021 16:38:00 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500010.china.huawei.com (7.221.188.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 2 Dec 2021 16:40:42 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 2 Dec 2021 16:40:42 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 0/9] net: hns3: some cleanups for -next
Date:   Thu, 2 Dec 2021 16:35:54 +0800
Message-ID: <20211202083603.25176-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To improve code readability and simplicity, this series add 9 cleanup
patches for the HNS3 ethernet driver.

Jian Shen (3):
  net: hns3: split function hclge_init_vlan_config()
  net: hns3: split function hclge_get_fd_rule_info()
  net: hns3: split function hclge_update_port_base_vlan_cfg()

Jie Wang (3):
  net: hns3: refactor function hclge_configure()
  net: hns3: refactor function hclge_set_channels()
  net: hns3: refactor function hns3_get_vector_ring_chain()

Peng Li (2):
  net: hns3: extract macro to simplify ring stats update code
  net: hns3: refactor function hns3_fill_skb_desc to simplify code

Yufeng Mo (1):
  net: hns3: split function hns3_nic_net_xmit()

 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 430 ++++++++----------
 .../net/ethernet/hisilicon/hns3/hns3_enet.h   |   7 +
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 317 +++++++------
 3 files changed, 390 insertions(+), 364 deletions(-)

-- 
2.33.0

