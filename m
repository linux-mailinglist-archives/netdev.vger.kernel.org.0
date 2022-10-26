Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F16B460DE95
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 12:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbiJZKHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 06:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiJZKHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 06:07:48 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA5A34DFC;
        Wed, 26 Oct 2022 03:07:44 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4My4HP3Tq1zHv2h;
        Wed, 26 Oct 2022 18:07:29 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 26 Oct 2022 18:07:42 +0800
Received: from localhost.localdomain (10.175.112.70) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 26 Oct 2022 18:07:41 +0800
From:   Xu Jia <xujia39@huawei.com>
To:     <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH openEuler-1.0-LTS v2 0/4] CVE-2022-3567
Date:   Wed, 26 Oct 2022 18:28:15 +0800
Message-ID: <1666780099-9989-1-git-send-email-xujia39@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

*** BLURB HERE ***

Eric Dumazet (1):
  ipv6: annotate some data-races around sk->sk_prot

Kuniyuki Iwashima (1):
  ipv6: Fix data races around sk->sk_prot.

Paolo Abeni (2):
  ipv6: provide and use ipv6 specific version for {recv, send}msg
  inet: factor out inet_send_prepare()

 include/net/inet_common.h |  1 +
 net/core/sock.c           | 26 +++++++++++++---------
 net/ipv4/af_inet.c        | 44 ++++++++++++++++++++++++-------------
 net/ipv6/af_inet6.c       | 55 ++++++++++++++++++++++++++++++++++++++++-------
 net/ipv6/ipv6_sockglue.c  |  6 ++++--
 5 files changed, 97 insertions(+), 35 deletions(-)

-- 
1.8.3.1

