Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0DF63D560
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 13:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234100AbiK3MTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 07:19:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiK3MTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 07:19:40 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A061521E29;
        Wed, 30 Nov 2022 04:19:39 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/4] Netfilter fixes for net
Date:   Wed, 30 Nov 2022 13:19:30 +0100
Message-Id: <20221130121934.1125-1-pablo@netfilter.org>
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

The following patchset contains Netfilter fixes for net:

1) Check for interval validity in all concatenation fields in
   nft_set_pipapo, from Stefano Brivio.

2) Missing preemption disabled in conntrack and flowtable stat
   updates, from Xin Long.

3) Fix compilation warning when CONFIG_NF_CONNTRACK_MARK=n.

Except for 3) which was a bug introduced in a recent fix in 6.1-rc.
Anything else, broken for several releases.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit f2fc2280faabafc8df83ee007699d21f7a6301fe:

  Merge branch 'wwan-iosm-fixes' (2022-11-28 11:31:59 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to 1feeae071507ad65cf9f462a1bdd543a4bf89e71:

  netfilter: ctnetlink: fix compilation warning after data race fixes in ct mark (2022-11-30 13:08:49 +0100)

----------------------------------------------------------------
Pablo Neira Ayuso (1):
      netfilter: ctnetlink: fix compilation warning after data race fixes in ct mark

Stefano Brivio (1):
      netfilter: nft_set_pipapo: Actually validate intervals in fields after the first one

Xin Long (2):
      netfilter: flowtable_offload: fix using __this_cpu_add in preemptible
      netfilter: conntrack: fix using __this_cpu_add in preemptible

 net/netfilter/nf_conntrack_core.c     |  6 +++---
 net/netfilter/nf_conntrack_netlink.c  | 19 ++++++++++---------
 net/netfilter/nf_flow_table_offload.c |  6 +++---
 net/netfilter/nft_set_pipapo.c        |  5 +++--
 4 files changed, 19 insertions(+), 17 deletions(-)
