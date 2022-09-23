Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6A5F5E7175
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 03:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbiIWBlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 21:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbiIWBlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 21:41:08 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3ACD12D6;
        Thu, 22 Sep 2022 18:41:06 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MYZWW516WzlVjT;
        Fri, 23 Sep 2022 09:36:55 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 23 Sep 2022 09:41:04 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 23 Sep 2022 09:41:04 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <jiri@mellanox.com>, <moshe@mellanox.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <idosch@nvidia.com>
CC:     <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>, <lipeng321@huawei.com>,
        <chenhao418@huawei.com>
Subject: [PATCH net-next 0/2] net: hns3: add support setting parameters of congestion control algorithm by devlink param
Date:   Fri, 23 Sep 2022 09:38:16 +0800
Message-ID: <20220923013818.51003-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
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

This series adds support setting parameters of congestion control algorithm
by devlink param for HNS3 driver of PF.

There are several parameters need to be set, but the devlink param string
is limited to 32 characters, it is not enough, so expand the string length
to 256.

Hao Chen (2):
  devlink: expand __DEVLINK_PARAM_MAX_STRING_VALUE to 256
  net: hns3: PF add support setting parameters of congestion control
    algorithm by devlink param

 .../hns3/hns3_common/hclge_comm_cmd.h         |   6 +
 .../hisilicon/hns3/hns3pf/hclge_cmd.h         |  44 +
 .../hisilicon/hns3/hns3pf/hclge_devlink.c     | 788 ++++++++++++++++++
 .../hisilicon/hns3/hns3pf/hclge_devlink.h     |   6 +
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 122 +++
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  61 ++
 include/net/devlink.h                         |   2 +-
 7 files changed, 1028 insertions(+), 1 deletion(-)

-- 
2.33.0

