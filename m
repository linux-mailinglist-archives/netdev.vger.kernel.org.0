Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 232B24E801F
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 09:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbiCZI6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 04:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbiCZI6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 04:58:15 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6738133655
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 01:56:37 -0700 (PDT)
Received: from kwepemi100002.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KQXr75F0Sz1GD6c;
        Sat, 26 Mar 2022 16:56:23 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi100002.china.huawei.com (7.221.188.188) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 26 Mar 2022 16:56:35 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 26 Mar 2022 16:56:35 +0800
From:   Jie Wang <wangjie125@huawei.com>
To:     <mkubecek@suse.cz>, <davem@davemloft.net>, <kuba@kernel.org>,
        <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <huangguangbin2@huawei.com>,
        <lipeng321@huawei.com>, <shenjian15@huawei.com>,
        <moyufeng@huawei.com>, <linyunsheng@huawei.com>,
        <salil.mehta@huawei.com>, <chenhao288@hisilicon.com>
Subject: [RFCv2 PATCH net-next 0/2] net-next: ethool: add support to get/set tx push by ethtool -G/g
Date:   Sat, 26 Mar 2022 16:51:00 +0800
Message-ID: <20220326085102.14111-1-wangjie125@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These two patches add tx push in ring parms and adapt the set and get APIs 
of ring params

The former discussion please see [1].
[1]:https://lore.kernel.org/netdev/20220315032108.57228-1-wangjie125@huawei.com/

ChangeLog:
V1->V2
extend tx push param in ringparam, suggested by Jakub Kicinski.

Jie Wang (2):
  net-next: ethtool: extend ringparam set/get APIs for tx_push
  net-next: hn3: add tx push support in hns3 ring param process

 .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 30 +++++++++++++++++++
 include/linux/ethtool.h                       |  3 ++
 include/uapi/linux/ethtool_netlink.h          |  1 +
 net/ethtool/netlink.h                         |  2 +-
 net/ethtool/rings.c                           |  9 ++++--
 5 files changed, 42 insertions(+), 3 deletions(-)

-- 
2.33.0

