Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F508669E6B
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 17:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjAMQnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 11:43:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjAMQme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 11:42:34 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F282182B88;
        Fri, 13 Jan 2023 08:41:11 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/3] Netfilter fixes for net
Date:   Fri, 13 Jan 2023 17:41:03 +0100
Message-Id: <20230113164106.311491-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Resend Cc'ing netdev, previous PR did not CC netdev accidentally. ]

Hi,

The following patchset contains Netfilter fixes for net:

1) Increase timeout to 120 seconds for netfilter selftests to fix
   nftables transaction tests, from Florian Westphal.

2) Fix overflow in bitmap_ip_create() due to integer arithmetics
   in a 64-bit bitmask, from Gavrilov Ilia.

3) Fix incorrect arithmetics in nft_payload with double-tagged
   vlan matching.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 8fed75653a670a4d3be0ab9949aed5e2968a03ef:

  Merge tag 'mlx5-fixes-2023-01-09' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux (2023-01-11 12:55:09 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to 696e1a48b1a1b01edad542a1ef293665864a4dd0:

  netfilter: nft_payload: incorrect arithmetics when fetching VLAN header bits (2023-01-11 19:18:04 +0100)

----------------------------------------------------------------
Florian Westphal (1):
      selftests: netfilter: fix transaction test script timeout handling

Gavrilov Ilia (1):
      netfilter: ipset: Fix overflow before widen in the bitmap_ip_create() function.

Pablo Neira Ayuso (1):
      netfilter: nft_payload: incorrect arithmetics when fetching VLAN header bits

 net/netfilter/ipset/ip_set_bitmap_ip.c                |  4 ++--
 net/netfilter/nft_payload.c                           |  2 +-
 tools/testing/selftests/netfilter/nft_trans_stress.sh | 16 +++++++++-------
 tools/testing/selftests/netfilter/settings            |  1 +
 4 files changed, 13 insertions(+), 10 deletions(-)
 create mode 100644 tools/testing/selftests/netfilter/settings
