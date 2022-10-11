Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8808F5FAF74
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 11:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiJKJhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 05:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiJKJgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 05:36:54 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F0582854;
        Tue, 11 Oct 2022 02:36:52 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MmrG36gHvz1CDyr;
        Tue, 11 Oct 2022 17:34:19 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 11 Oct 2022 17:36:50 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <bpf@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <lina.wang@mediatek.com>, <deso@posteo.net>
Subject: [net 0/2] some fixes for selftest/net
Date:   Tue, 11 Oct 2022 17:57:45 +0800
Message-ID: <1665482267-30706-1-git-send-email-wangyufen@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wang Yufen (2):
  selftests/net: fix opening object file failed
  selftests/net: fix missing xdp_dummy

 tools/testing/selftests/bpf/progs/nat6to4.c   | 285 ++++++++++++++++++++++++++
 tools/testing/selftests/net/Makefile          |   2 -
 tools/testing/selftests/net/bpf/Makefile      |  14 --
 tools/testing/selftests/net/bpf/nat6to4.c     | 285 --------------------------
 tools/testing/selftests/net/udpgro.sh         |   4 +-
 tools/testing/selftests/net/udpgro_bench.sh   |   4 +-
 tools/testing/selftests/net/udpgro_frglist.sh |  12 +-
 tools/testing/selftests/net/udpgro_fwd.sh     |   2 +-
 tools/testing/selftests/net/veth.sh           |   8 +-
 9 files changed, 300 insertions(+), 316 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/nat6to4.c
 delete mode 100644 tools/testing/selftests/net/bpf/Makefile
 delete mode 100644 tools/testing/selftests/net/bpf/nat6to4.c

-- 
1.8.3.1

