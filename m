Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 028EB408C28
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240006AbhIMNOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:14:03 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:9036 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbhIMNNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 09:13:50 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4H7Rh16cmSzW2C0;
        Mon, 13 Sep 2021 21:11:29 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 13 Sep 2021 21:12:28 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 13 Sep 2021 21:12:27 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net 0/6]  net: hns3: add some fixes for -net
Date:   Mon, 13 Sep 2021 21:08:19 +0800
Message-ID: <20210913130825.27025-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds some fixes for the HNS3 ethernet driver.

Jiaran Zhang (2):
  net: hns3: fix the exception when query imp info
  net: hns3: fix the timing issue of VF clearing interrupt sources

Yufeng Mo (3):
  net: hns3: pad the short tunnel frame before sending to hardware
  net: hns3: change affinity_mask to numa node range
  net: hns3: disable mac in flr process

Yunsheng Lin (1):
  net: hns3: add option to turn off page pool feature

 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 14 +++++++++++---
 .../hisilicon/hns3/hns3pf/hclge_debugfs.c     |  4 ++++
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 19 +++++++++++--------
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      |  6 +++---
 4 files changed, 29 insertions(+), 14 deletions(-)

-- 
2.33.0

