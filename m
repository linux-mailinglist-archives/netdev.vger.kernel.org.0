Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31048486CC5
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 22:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244618AbiAFVvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 16:51:49 -0500
Received: from mail.netfilter.org ([217.70.188.207]:36142 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244453AbiAFVvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 16:51:49 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4D65964287;
        Thu,  6 Jan 2022 22:49:01 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/4] Netfilter fixes for net
Date:   Thu,  6 Jan 2022 22:51:35 +0100
Message-Id: <20220106215139.170824-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Refcount leak in ipt_CLUSTERIP rule loading path, from Xin Xiong.

2) Use socat in netfilter selftests, from Hangbin Liu.

3) Skip layer checksum 4 update for IP fragments.

4) Missing allocation of pcpu scratch maps on clone in
   nft_set_pipapo, from Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 1d5a474240407c38ca8c7484a656ee39f585399c:

  sfc: The RX page_ring is optional (2022-01-04 18:14:21 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 23c54263efd7cb605e2f7af72717a2a951999217:

  netfilter: nft_set_pipapo: allocate pcpu scratch maps on clone (2022-01-06 10:43:24 +0100)

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: nft_set_pipapo: allocate pcpu scratch maps on clone

Hangbin Liu (1):
      selftests: netfilter: switch to socat for tests using -q option

Pablo Neira Ayuso (1):
      netfilter: nft_payload: do not update layer 4 checksum when mangling fragments

Xin Xiong (1):
      netfilter: ipt_CLUSTERIP: fix refcount leak in clusterip_tg_check()

 net/ipv4/netfilter/ipt_CLUSTERIP.c                      |  5 ++++-
 net/netfilter/nft_payload.c                             |  3 +++
 net/netfilter/nft_set_pipapo.c                          |  8 ++++++++
 tools/testing/selftests/netfilter/ipip-conntrack-mtu.sh |  9 +++++----
 tools/testing/selftests/netfilter/nf_nat_edemux.sh      | 10 +++++-----
 5 files changed, 25 insertions(+), 10 deletions(-)
