Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 275B7653C3B
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 07:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234942AbiLVGnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 01:43:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiLVGnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 01:43:47 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE3CD83
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 22:43:46 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Nd0zf3nPJzJpSX;
        Thu, 22 Dec 2022 14:39:58 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 22 Dec 2022 14:43:44 +0800
From:   Hao Lan <lanhao@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <huangguangbin2@huawei.com>,
        <wangjie125@huawei.com>, <shenjian15@huawei.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH net 0/3] net: hns3: fix some bug for hns3
Date:   Thu, 22 Dec 2022 14:43:40 +0800
Message-ID: <20221222064343.61537-1-lanhao@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some bugfixes for the HNS3 ethernet driver. patch#1 fix miss
checking for rx packet. patch#2 fixes VF promisc mode not update
when mac table full bug, and patch#3 fixes a nterrupts not
initialization in VF FLR bug.

Jian Shen (2):
  net: hns3: fix miss L3E checking for rx packet
  net: hns3: fix VF promisc mode not update when mac table full

Jie Wang (1):
  net: hns3: add interrupts re-initialization while doing VF FLR

 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 10 +--
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 75 +++++++++++--------
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      |  3 +-
 3 files changed, 49 insertions(+), 39 deletions(-)

-- 
2.30.0

