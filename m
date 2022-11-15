Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F00C8629532
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 11:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238236AbiKOKDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 05:03:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237867AbiKOKDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 05:03:15 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D062B248D6;
        Tue, 15 Nov 2022 02:03:12 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NBMDn6yYszmVvp;
        Tue, 15 Nov 2022 18:02:49 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 18:03:10 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <shuah@kernel.org>, <andrii@kernel.org>,
        <mykolal@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <martin.lau@linux.dev>, Wang Yufen <wangyufen@huawei.com>
Subject: [PATCH v2 0/2] some fixes for selftest/net
Date:   Tue, 15 Nov 2022 18:23:18 +0800
Message-ID: <1668507800-45450-1-git-send-email-wangyufen@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v1: https://lkml.kernel.org/netdev/20221018185311.568a581e@kernel.org/T/

Wang Yufen (2):
  selftests/net: fix missing xdp_dummy
  selftests/net: fix opening object file failed

 tools/testing/selftests/bpf/Makefile               |   7 +-
 tools/testing/selftests/bpf/in_netns.sh            |  23 +
 .../testing/selftests/bpf/progs/nat6to4_egress4.c  | 184 ++++++
 .../testing/selftests/bpf/progs/nat6to4_ingress6.c | 149 +++++
 tools/testing/selftests/bpf/test_udpgro_frglist.sh | 110 ++++
 tools/testing/selftests/bpf/udpgso_bench_rx.c      | 409 ++++++++++++
 tools/testing/selftests/bpf/udpgso_bench_tx.c      | 712 +++++++++++++++++++++
 tools/testing/selftests/net/Makefile               |   2 -
 tools/testing/selftests/net/bpf/Makefile           |  14 -
 tools/testing/selftests/net/bpf/nat6to4.c          | 285 ---------
 tools/testing/selftests/net/udpgro.sh              |   6 +-
 tools/testing/selftests/net/udpgro_bench.sh        |   6 +-
 tools/testing/selftests/net/udpgro_frglist.sh      | 101 ---
 tools/testing/selftests/net/udpgro_fwd.sh          |   3 +-
 tools/testing/selftests/net/veth.sh                |   9 +-
 15 files changed, 1607 insertions(+), 413 deletions(-)
 create mode 100755 tools/testing/selftests/bpf/in_netns.sh
 create mode 100644 tools/testing/selftests/bpf/progs/nat6to4_egress4.c
 create mode 100644 tools/testing/selftests/bpf/progs/nat6to4_ingress6.c
 create mode 100755 tools/testing/selftests/bpf/test_udpgro_frglist.sh
 create mode 100644 tools/testing/selftests/bpf/udpgso_bench_rx.c
 create mode 100644 tools/testing/selftests/bpf/udpgso_bench_tx.c
 delete mode 100644 tools/testing/selftests/net/bpf/Makefile
 delete mode 100644 tools/testing/selftests/net/bpf/nat6to4.c
 delete mode 100755 tools/testing/selftests/net/udpgro_frglist.sh

-- 
1.8.3.1

