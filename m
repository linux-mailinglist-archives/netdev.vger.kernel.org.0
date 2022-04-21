Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED61B509B41
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 10:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387017AbiDUIzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 04:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387011AbiDUIzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 04:55:22 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20EAF20BDB
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 01:52:33 -0700 (PDT)
Received: from kwepemi100026.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KkWSl4pF3zFqWd;
        Thu, 21 Apr 2022 16:49:59 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100026.china.huawei.com (7.221.188.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 21 Apr 2022 16:52:31 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 21 Apr 2022 16:52:30 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <mkubecek@suse.cz>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH ethtool-next v2 0/2] Add support to get/set tx push by ethtool -G/g
Date:   Thu, 21 Apr 2022 16:46:44 +0800
Message-ID: <20220421084646.15458-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

These two patches first update uapi headers by using the import shell, then
add support to get/set tx push by ethtool -G/g.

ChangeLog:
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

