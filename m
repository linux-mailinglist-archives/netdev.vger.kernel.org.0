Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38AE365FA82
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 04:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjAFDz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 22:55:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjAFDz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 22:55:27 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F6986B5A0;
        Thu,  5 Jan 2023 19:55:26 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Np8b75lscznV84;
        Fri,  6 Jan 2023 11:53:55 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 6 Jan 2023 11:55:23 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <martin.lau@linux.dev>,
        <song@kernel.org>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>,
        <jolsa@kernel.org>
Subject: [PATCH bpf-next 0/2] bpf: Add ipip6 and ip6ip decap support for bpf_skb_adjust_room()
Date:   Fri, 6 Jan 2023 11:55:19 +0800
Message-ID: <cover.1672976410.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ipip6 and ip6ip decap support for bpf_skb_adjust_room().
Main use case is for using cls_bpf on ingress hook to decapsulate
IPv4 over IPv6 and IPv6 over IPv4 tunnel packets.

And add ipip6 and ip6ip decap testcases to verify that
bpf_skb_adjust_room() correctly decapsulate ipip6 and ip6ip
tunnel packets.

Ziyang Xuan (2):
  bpf: Add ipip6 and ip6ip decap support for bpf_skb_adjust_room()
  selftests/bpf: add ipip6 and ip6ip decap to test_tc_tunnel

 net/core/filter.c                             | 34 +++++++++-
 .../selftests/bpf/progs/test_tc_tunnel.c      | 64 +++++++++++++++++++
 tools/testing/selftests/bpf/test_tc_tunnel.sh | 15 +++--
 3 files changed, 105 insertions(+), 8 deletions(-)

-- 
2.25.1

