Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 137C66ADB50
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 11:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbjCGKEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 05:04:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbjCGKEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 05:04:32 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0B3FB3CE37;
        Tue,  7 Mar 2023 02:04:31 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/3] Netfilter fixes for net
Date:   Tue,  7 Mar 2023 11:04:21 +0100
Message-Id: <20230307100424.2037-1-pablo@netfilter.org>
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

1) Restore ctnetlink zero mark in events and dump, from Ivan Delalande.

2) Fix deadlock due to missing disabled bh in tproxy, from Florian Westphal.

3) Safer maximum chain load in conntrack, from Eric Dumazet.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 528125268588a18a2f257002af051b62b14bb282:

  Merge branch 'nfp-ipsec-csum' (2023-03-03 08:28:44 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to c77737b736ceb50fdf150434347dbd81ec76dbb1:

  netfilter: conntrack: adopt safer max chain length (2023-03-07 10:58:06 +0100)

----------------------------------------------------------------
Eric Dumazet (1):
      netfilter: conntrack: adopt safer max chain length

Florian Westphal (1):
      netfilter: tproxy: fix deadlock due to missing BH disable

Ivan Delalande (1):
      netfilter: ctnetlink: revert to dumping mark regardless of event type

 include/net/netfilter/nf_tproxy.h    |  7 +++++++
 net/ipv4/netfilter/nf_tproxy_ipv4.c  |  2 +-
 net/ipv6/netfilter/nf_tproxy_ipv6.c  |  2 +-
 net/netfilter/nf_conntrack_core.c    |  4 ++--
 net/netfilter/nf_conntrack_netlink.c | 14 +++++++-------
 5 files changed, 18 insertions(+), 11 deletions(-)
