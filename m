Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F11C8589FD7
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 19:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238006AbiHDR0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 13:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232682AbiHDR0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 13:26:54 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CDB96301
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 10:26:53 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oJecU-0007DF-1g; Thu, 04 Aug 2022 19:26:50 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net 0/3] netfilter followup fixes for net
Date:   Thu,  4 Aug 2022 19:26:26 +0200
Message-Id: <20220804172629.29748-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Regressions, since 5.19:
Fix crash when packet tracing is enabled via 'meta nftrace set 1' rule.
Also comes with a test case.

Regressions, this cycle:
Fix Kconfig dependency for the flowtable /proc interface, we want this
to be off by default.

Florian Westphal (2):
  netfilter: nf_tables: fix crash when nf_trace is enabled
  selftests: netfilter: add test case for nf trace infrastructure

Pablo Neira Ayuso (1):
  netfilter: flowtable: fix incorrect Kconfig dependencies

 net/netfilter/Kconfig                         |  3 +-
 net/netfilter/nf_tables_core.c                | 21 +++--
 .../selftests/netfilter/nft_trans_stress.sh   | 81 +++++++++++++++++--
 3 files changed, 87 insertions(+), 18 deletions(-)

-- 
2.35.1

