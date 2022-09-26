Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1035EA90D
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 16:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235353AbiIZOwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 10:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235004AbiIZOvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 10:51:50 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9D312D06
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 06:18:22 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Mbjqy2txRzHtrD;
        Mon, 26 Sep 2022 21:13:34 +0800 (CST)
Received: from huawei.com (10.175.101.6) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 26 Sep
 2022 21:18:20 +0800
From:   Liu Jian <liujian56@huawei.com>
To:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     <liujian56@huawei.com>
Subject: [PATCH net-next 0/2] Add helper functions to parse netlink msg of ip_tunnel
Date:   Mon, 26 Sep 2022 21:19:42 +0800
Message-ID: <20220926131944.137094-1-liujian56@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add helper functions to parse netlinkmsg of ip_tunnel

Liu Jian (2):
  net: Add helper function to parse netlink msg of ip_tunnel_encap
  net: Add helper function to parse netlink msg of ip_tunnel_parm

 include/net/ip_tunnels.h | 66 ++++++++++++++++++++++++++++++++++++++++
 net/ipv4/ipip.c          | 62 ++-----------------------------------
 net/ipv6/ip6_tunnel.c    | 37 ++--------------------
 net/ipv6/sit.c           | 65 ++-------------------------------------
 4 files changed, 74 insertions(+), 156 deletions(-)

-- 
2.17.1

