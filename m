Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCA0051BFD1
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 14:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377911AbiEEMyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 08:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348152AbiEEMyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 08:54:09 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5EB43EDB;
        Thu,  5 May 2022 05:50:30 -0700 (PDT)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KvD794drWzhYp0;
        Thu,  5 May 2022 20:49:57 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500009.china.huawei.com (7.221.188.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 5 May 2022 20:50:27 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 5 May 2022 20:50:27 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 0/5] net: hns3: updates for -next
Date:   Thu, 5 May 2022 20:44:39 +0800
Message-ID: <20220505124444.2233-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes some updates for the HNS3 ethernet driver.

Guangbin Huang (1):
  net: hns3: add query vf ring and vector map relation

Hao Chen (1):
  net: hns3: fix access null pointer issue when set tx-buf-size as 0

Jie Wang (2):
  net: hns3: add byte order conversion for PF to VF mailbox message
  net: hns3: add byte order conversion for VF to PF mailbox message

Yufeng Mo (1):
  net: hns3: remove the affinity settings of vector0

 .../net/ethernet/hisilicon/hns3/hclge_mbx.h   |  60 +++++-
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    |   7 +-
 .../hisilicon/hns3/hns3pf/hclge_main.c        |  27 +--
 .../hisilicon/hns3/hns3pf/hclge_main.h        |   2 -
 .../hisilicon/hns3/hns3pf/hclge_mbx.c         | 193 +++++++++++++-----
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      |  58 +++---
 .../hisilicon/hns3/hns3vf/hclgevf_main.h      |   2 +-
 .../hisilicon/hns3/hns3vf/hclgevf_mbx.c       |  80 +++++---
 8 files changed, 269 insertions(+), 160 deletions(-)

-- 
2.33.0

