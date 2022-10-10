Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBB25F0B25
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 13:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbiI3L4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 07:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiI3Lz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 07:55:59 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6934F125798;
        Fri, 30 Sep 2022 04:55:57 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Mf7qk3flRzWh1R;
        Fri, 30 Sep 2022 19:51:46 +0800 (CST)
Received: from dggpemm500013.china.huawei.com (7.185.36.172) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 30 Sep 2022 19:55:55 +0800
Received: from huawei.com (10.67.174.245) by dggpemm500013.china.huawei.com
 (7.185.36.172) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 30 Sep
 2022 19:55:55 +0800
From:   Chen Zhongjin <chenzhongjin@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <rds-devel@oss.oracle.com>
CC:     <santosh.shilimkar@oracle.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <chenzhongjin@huawei.com>
Subject: [PATCH -next 0/2] net/rds: Minor cleanup for unused variables
Date:   Mon, 10 Oct 2022 11:09:02 +0800
Message-ID: <20221010030904.2883557-1-chenzhongjin@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.245]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500013.china.huawei.com (7.185.36.172)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_DATE_IN_FUTURE_96_Q autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cleanup unused variables reported by Clang [-Wunused-but-set-variable]

Chen Zhongjin (2):
  net/rds: Remove unused variable 'total_copied'
  net/rds: Remove unused variable 'total_payload_len'

 net/rds/message.c | 2 --
 net/rds/send.c    | 3 +--
 2 files changed, 1 insertion(+), 4 deletions(-)

-- 
2.33.0

