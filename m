Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E8E494E4D
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 13:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244068AbiATMwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 07:52:19 -0500
Received: from mail.netfilter.org ([217.70.188.207]:38718 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243858AbiATMwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 07:52:18 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 037BF6002B;
        Thu, 20 Jan 2022 13:49:18 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/5] Netfilter fixes for net
Date:   Thu, 20 Jan 2022 13:52:07 +0100
Message-Id: <20220120125212.991271-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Incorrect helper module alias in netbios_ns, from Florian Westphal.

2) Remove unused variable in nf_tables.

3) Uninitialized last expression in nf_tables register tracking.

4) Memleak in nft_connlimit after moving stateful data out of the
   expression data area.

5) Bogus invalid stats update when NF_REPEAT is returned, from Florian.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 7d6019b602de660bfc6a542a68630006ace83b90:

  Revert "net: vertexcom: default to disabled on kbuild" (2022-01-10 21:11:07 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 830af2eba40327abec64325a5b08b1e85c37a2e0:

  netfilter: conntrack: don't increment invalid counter on NF_REPEAT (2022-01-16 00:55:27 +0100)

----------------------------------------------------------------
Florian Westphal (2):
      netfilter: nf_conntrack_netbios_ns: fix helper module alias
      netfilter: conntrack: don't increment invalid counter on NF_REPEAT

Pablo Neira Ayuso (3):
      netfilter: nf_tables: remove unused variable
      netfilter: nf_tables: set last expression in register tracking area
      netfilter: nft_connlimit: memleak if nf_ct_netns_get() fails

 net/netfilter/nf_conntrack_core.c       |  8 +++++---
 net/netfilter/nf_conntrack_netbios_ns.c |  5 +++--
 net/netfilter/nf_tables_api.c           |  4 +---
 net/netfilter/nft_connlimit.c           | 11 ++++++++++-
 4 files changed, 19 insertions(+), 9 deletions(-)
