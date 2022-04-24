Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F35F50D1CD
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 15:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbiDXNGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 09:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231800AbiDXNGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 09:06:15 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA8617B9B4;
        Sun, 24 Apr 2022 06:03:13 -0700 (PDT)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KmSwY5jCcz1JBQw;
        Sun, 24 Apr 2022 21:02:21 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sun, 24 Apr 2022 21:03:11 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sun, 24 Apr 2022 21:03:11 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 0/6] net: hns3: add some fixes for -net
Date:   Sun, 24 Apr 2022 20:57:19 +0800
Message-ID: <20220424125725.43232-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds some fixes for the HNS3 ethernet driver.

Hao Chen (1):
  net: hns3: align the debugfs output to the left

Jian Shen (3):
  net: hns3: clear inited state and stop client after failed to register
    netdev
  net: hns3: add validity check for message data length
  net: hns3: add return value for mailbox handling in PF

Jie Wang (1):
  net: hns3: modify the return code of hclge_get_ring_chain_from_mbx

Peng Li (1):
  net: hns3: fix error log of tx/rx tqps stats

 .../hns3/hns3_common/hclge_comm_tqp_stats.c   |  4 +-
 .../ethernet/hisilicon/hns3/hns3_debugfs.c    | 84 +++++++++----------
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  9 ++
 .../hisilicon/hns3/hns3pf/hclge_mbx.c         | 31 ++++---
 4 files changed, 73 insertions(+), 55 deletions(-)

-- 
2.33.0

