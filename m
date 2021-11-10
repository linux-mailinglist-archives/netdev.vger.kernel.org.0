Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574B444C260
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 14:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbhKJNuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 08:50:15 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:14735 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbhKJNuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 08:50:15 -0500
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Hq5h60N2QzZcyw;
        Wed, 10 Nov 2021 21:45:10 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 10 Nov 2021 21:47:24 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 10 Nov 2021 21:47:23 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 0/8] net: hns3: add some fixes for -net
Date:   Wed, 10 Nov 2021 21:42:48 +0800
Message-ID: <20211110134256.25025-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds some fixes for the HNS3 ethernet driver.

Guangbin Huang (4):
  net: hns3: fix failed to add reuse multicast mac addr to hardware when
    mc mac table is full
  net: hns3: fix some mac statistics is always 0 in device version V2
  net: hns3: remove check VF uc mac exist when set by PF
  net: hns3: allow configure ETS bandwidth of all TCs

Jie Wang (2):
  net: hns3: fix ROCE base interrupt vector initialization bug
  net: hns3: fix pfc packet number incorrect after querying pfc
    parameters

Yufeng Mo (2):
  net: hns3: sync rx ring head in echo common pull
  net: hns3: fix kernel crash when unload VF while it is being reset

 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |   7 ++
 .../hisilicon/hns3/hns3pf/hclge_cmd.c         |   1 +
 .../hisilicon/hns3/hns3pf/hclge_cmd.h         |   1 +
 .../hisilicon/hns3/hns3pf/hclge_dcb.c         |  20 ++--
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 106 +++++++-----------
 .../hisilicon/hns3/hns3pf/hclge_main.h        |   8 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.c |  77 ++++++-------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.h |   4 +-
 .../hisilicon/hns3/hns3vf/hclgevf_cmd.c       |  32 ++++++
 .../hisilicon/hns3/hns3vf/hclgevf_cmd.h       |   9 ++
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      |  10 +-
 .../hisilicon/hns3/hns3vf/hclgevf_main.h      |   4 +-
 12 files changed, 147 insertions(+), 132 deletions(-)

-- 
2.33.0

