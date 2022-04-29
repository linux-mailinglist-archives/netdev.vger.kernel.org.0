Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D7551454F
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 11:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356530AbiD2J0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 05:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356484AbiD2J0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 05:26:14 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82ED3C4038
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 02:22:55 -0700 (PDT)
Received: from kwepemi500006.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KqRpk09fMzhYsB;
        Fri, 29 Apr 2022 17:22:38 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500006.china.huawei.com (7.221.188.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 29 Apr 2022 17:22:53 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 29 Apr 2022 17:22:53 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <mkubecek@suse.cz>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH ethtool-next v3 0/2] Add support to get/set tx push by ethtool -G/g
Date:   Fri, 29 Apr 2022 17:17:02 +0800
Message-ID: <20220429091704.21258-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

These two patches first update uapi headers by using the import shell, then
add support to get/set tx push by ethtool -G/g.

Changelog:
v2->v3
1.Revise the min_argc value of tx-push.
link:https://lore.kernel.org/netdev/20220421084646.15458-1-huangguangbin2@huawei.com/

v1->v2
1.Update uapi headers by using the import shell scripts.
link:https://lore.kernel.org/netdev/20220419125030.3230-1-huangguangbin2@huawei.com/

Jie Wang (2):
  update UAPI header copies
  ethtool: add support to get/set tx push by ethtool -G/g

 ethtool.8.in                 |  4 ++
 ethtool.c                    |  1 +
 netlink/rings.c              |  7 +++
 uapi/linux/ethtool_netlink.h |  9 ++++
 uapi/linux/if_link.h         | 97 ++++++++++++++++++++++++++++++++++++
 uapi/linux/net_tstamp.h      | 17 ++++++-
 uapi/linux/netlink.h         |  1 +
 uapi/linux/rtnetlink.h       | 16 ++++++
 8 files changed, 151 insertions(+), 1 deletion(-)

-- 
2.33.0

