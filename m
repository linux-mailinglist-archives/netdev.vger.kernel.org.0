Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73DDB552DB8
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347440AbiFUI4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346484AbiFUI41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:56:27 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 09C8F26109;
        Tue, 21 Jun 2022 01:56:27 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/5] Netfilter fixes for net
Date:   Tue, 21 Jun 2022 10:56:13 +0200
Message-Id: <20220621085618.3975-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Use get_random_u32() instead of prandom_u32_state() in nft_meta
   and nft_numgen, from Florian Westphal.

2) Incorrect list head in nfnetlink_cttimeout in recent update coming
   from previous development cycle. Also from Florian.

3) Incorrect path to pktgen scripts for nft_concat_range.sh selftest.
   From Jie2x Zhou.

4) Two fixes for the for nft_fwd and nft_dup egress support, from Florian.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit f5826c8c9d57210a17031af5527056eefdc2b7eb:

  net/mlx4_en: Fix wrong return value on ioctl EEPROM query failure (2022-06-07 20:49:58 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to fcd53c51d03709bc429822086f1e9b3e88904284:

  netfilter: nf_dup_netdev: add and use recursion counter (2022-06-21 10:50:41 +0200)

----------------------------------------------------------------
Florian Westphal (4):
      netfilter: use get_random_u32 instead of prandom
      netfilter: cttimeout: fix slab-out-of-bounds read typo in cttimeout_net_exit
      netfilter: nf_dup_netdev: do not push mac header a second time
      netfilter: nf_dup_netdev: add and use recursion counter

Jie2x Zhou (1):
      selftests: netfilter: correct PKTGEN_SCRIPT_PATHS in nft_concat_range.sh

 net/netfilter/nf_dup_netdev.c                      | 25 ++++++++++++++++++----
 net/netfilter/nfnetlink_cttimeout.c                |  2 +-
 net/netfilter/nft_meta.c                           | 13 ++---------
 net/netfilter/nft_numgen.c                         | 12 +++--------
 .../selftests/netfilter/nft_concat_range.sh        |  2 +-
 5 files changed, 28 insertions(+), 26 deletions(-)
