Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19AD45BB7D0
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 12:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiIQKjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 06:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiIQKjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 06:39:31 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA031C1B;
        Sat, 17 Sep 2022 03:39:29 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MV6nt42SzzHnYN;
        Sat, 17 Sep 2022 18:37:22 +0800 (CST)
Received: from kwepemm600013.china.huawei.com (7.193.23.68) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 17 Sep 2022 18:39:27 +0800
Received: from localhost.localdomain (10.67.165.2) by
 kwepemm600013.china.huawei.com (7.193.23.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 17 Sep 2022 18:39:27 +0800
From:   Haoyue Xu <xuhaoyue1@hisilicon.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <michal.simek@xilinx.com>
CC:     <huangdaode@huawei.com>, <liyangyang20@huawei.com>,
        <xuhaoyue1@hisilicon.com>, <huangjunxian6@hisilicon.com>,
        <linuxarm@huawei.com>, <liangwenpeng@huawei.com>
Subject: [PATCH net-next 0/7] net: ll_temac: Cleanup for clearing static warnings
Date:   Sat, 17 Sep 2022 18:38:36 +0800
Message-ID: <20220917103843.526877-1-xuhaoyue1@hisilicon.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.2]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600013.china.huawei.com (7.193.23.68)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most static warnings are detected by Checkpatch.pl, mainly about:
(1) #1: About the comments.
(2) #2: About function name in a string.
(3) #3: About the open parenthesis.
(4) #4: About the else branch.
(6) #6: About trailing statements.
(7) #5,#7: About blank lines and spaces.

Haoyue Xu (1):
  net: ll_temac: Cleanup for function name in a string

huangjunxian (6):
  net: ll_temac: fix the format of block comments
  net: ll_temac: axienet: align with open parenthesis
  net: ll_temac: delete unnecessary else branch
  net: ll_temac: fix the missing spaces around '='
  net: ll_temac: move trailing statements to next line
  net: ll_temac: axienet: delete unnecessary blank lines and spaces

 drivers/net/ethernet/xilinx/ll_temac.h        | 181 +++++++++---------
 drivers/net/ethernet/xilinx/ll_temac_main.c   |  65 ++++---
 drivers/net/ethernet/xilinx/ll_temac_mdio.c   |   6 +-
 drivers/net/ethernet/xilinx/xilinx_axienet.h  |   2 +-
 .../net/ethernet/xilinx/xilinx_axienet_main.c |   6 +-
 .../net/ethernet/xilinx/xilinx_axienet_mdio.c |   2 +-
 6 files changed, 139 insertions(+), 123 deletions(-)

-- 
2.30.0

