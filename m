Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC06682DEC
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 14:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbjAaNcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 08:32:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbjAaNcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 08:32:03 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 719B34DBF3;
        Tue, 31 Jan 2023 05:32:02 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/2] Netfilter fixes for net
Date:   Tue, 31 Jan 2023 14:31:56 +0100
Message-Id: <20230131133158.4052-1-pablo@netfilter.org>
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

The following patchset contains two Netfilter fixes for net:

1) Release bridge info once packet escapes the br_netfilter path,
   from Florian Westphal.

2) Revert incorrect fix for the SCTP connection tracking chunk
   iterator, also from Florian.

First path fixes a long standing issue, the second path addresses
a mistake in the previous pull request for net.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 9b3fc325c2a7e9e17e22b008357cb0ceb810d9b2:

  Merge tag 'ieee802154-for-net-2023-01-30' of git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan (2023-01-30 21:11:11 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to bd0e06f0def75ba26572a94e5350324474a55562:

  Revert "netfilter: conntrack: fix bug in for_each_sctp_chunk" (2023-01-31 14:02:48 +0100)

----------------------------------------------------------------
Florian Westphal (2):
      netfilter: br_netfilter: disable sabotage_in hook after first suppression
      Revert "netfilter: conntrack: fix bug in for_each_sctp_chunk"

 net/bridge/br_netfilter_hooks.c         | 1 +
 net/netfilter/nf_conntrack_proto_sctp.c | 5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)
