Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD8626596AA
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 10:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234544AbiL3JTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 04:19:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiL3JTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 04:19:42 -0500
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E031A390;
        Fri, 30 Dec 2022 01:19:41 -0800 (PST)
Received: from localhost.localdomain (1.general.phlin.us.vpn [10.172.66.38])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 1BE12423E7;
        Fri, 30 Dec 2022 09:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1672391978;
        bh=GSCj7zjT5rlcq0rdRinTPgv9Yzo1SARUc7j5oXoZuJ0=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=gADaQm0Z9TpXcW23pm3RykxuziV4j8tsAUNVUNqbFRxcFXnu/mBOXfpMCdUzxJiky
         WvPhKdVZHJCEbWkbomk8/sX6ovGB25hzcn1bnNMVwyz8XbKeWeRWbAmzK6S0Zshh/U
         5h9CABsLITxbHW9fN2ZqpvZ3GbsVGcfdc9sKOuhwOzfDetNhHBAMTTcjHOgAuYpBvI
         tGX0Dcu8m2UPifirmo7Bc/bln28CoO8CroIuCMPc1XTbMwaF0t4cPhRadlNgz5HD8r
         F5DMxS8TPryCZdrtt7V/7JfTI1/oUqg5VU2KPdW+988rvifPSE8YpgOJhmdQt9WgOc
         xN6lh34FhMNUA==
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     po-hsu.lin@canonical.com, dsahern@kernel.org, prestwoj@gmail.com,
        shuah@kernel.org, pabeni@redhat.com, kuba@kernel.org,
        edumazet@google.com, davem@davemloft.net
Subject: [PATCH 0/2] selftests: net: fix for arp_ndisc_evict_nocarrier test
Date:   Fri, 30 Dec 2022 17:18:27 +0800
Message-Id: <20221230091829.217007-1-po-hsu.lin@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset will fix a false-positive issue caused by the command in
cleanup_v6() of the arp_ndisc_evict_nocarrier test.

Also, it will make the test to return a non-zero value for any failure
reported in the test for us to avoid false-negative results.

Po-Hsu Lin (2):
  selftests: net: fix cleanup_v6() for arp_ndisc_evict_nocarrier
  selftests: net: return non-zero for failures reported in
    arp_ndisc_evict_nocarrier

 tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

-- 
2.7.4

