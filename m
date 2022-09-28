Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26105ED385
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 05:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbiI1Dbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 23:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232348AbiI1DbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 23:31:23 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29885D10D
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:31:02 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Mchk62bcGzWgsb;
        Wed, 28 Sep 2022 11:26:54 +0800 (CST)
Received: from huawei.com (10.175.101.6) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 28 Sep
 2022 11:30:59 +0800
From:   Liu Jian <liujian56@huawei.com>
To:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     <liujian56@huawei.com>
Subject: [PATCH net-next v2 0/2] Add helper functions to parse netlink msg of ip_tunnel
Date:   Wed, 28 Sep 2022 11:39:15 +0800
Message-ID: <20220928033917.281937-1-liujian56@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add helper functions to parse netlink msg of ip_tunnel

v1->v2: Move the implementation of the helper function to ip_tunnel_core.c

Liu Jian (2):
  net: Add helper function to parse netlink msg of ip_tunnel_encap
  net: Add helper function to parse netlink msg of ip_tunnel_parm

 include/net/ip_tunnels.h  |  6 ++++
 net/ipv4/ip_tunnel_core.c | 67 +++++++++++++++++++++++++++++++++++++++
 net/ipv4/ipip.c           | 62 ++----------------------------------
 net/ipv6/ip6_tunnel.c     | 37 ++-------------------
 net/ipv6/sit.c            | 65 ++-----------------------------------
 5 files changed, 81 insertions(+), 156 deletions(-)

-- 
2.17.1

