Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6309F5136B9
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 16:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236017AbiD1OY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 10:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbiD1OY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 10:24:27 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD702B42D8;
        Thu, 28 Apr 2022 07:21:12 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/3] Netfilter fixes for net
Date:   Thu, 28 Apr 2022 16:21:06 +0200
Message-Id: <20220428142109.38726-1-pablo@netfilter.org>
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

Hi,

This patchset contains Netfilter fixes for net:

1) Fix incorrect TCP connection tracking window reset for non-syn
   packets, from Florian Westphal.

2) Incorrect dependency on CONFIG_NFT_FLOW_OFFLOAD, from Volodymyr Mytnyk.

3) Fix nft_socket from the output path, from Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks!

----------------------------------------------------------------

The following changes since commit a1bde8c92d27d178a988bfd13d229c170b8135aa:

  Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net -queue (2022-04-27 10:58:39 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to 743b83f15d4069ea57c3e40996bf4a1077e0cdc1:

  netfilter: nft_socket: only do sk lookups when indev is available (2022-04-28 16:15:23 +0200)

----------------------------------------------------------------
Florian Westphal (2):
      netfilter: nf_conntrack_tcp: re-init for syn packets only
      netfilter: nft_socket: only do sk lookups when indev is available

Volodymyr Mytnyk (1):
      netfilter: conntrack: fix udp offload timeout sysctl

 net/netfilter/nf_conntrack_proto_tcp.c  | 21 ++++---------
 net/netfilter/nf_conntrack_standalone.c |  2 +-
 net/netfilter/nft_socket.c              | 52 ++++++++++++++++++++++++---------
 3 files changed, 45 insertions(+), 30 deletions(-)
