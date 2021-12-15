Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 509B44766AC
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 00:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbhLOXtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 18:49:22 -0500
Received: from mail.netfilter.org ([217.70.188.207]:56596 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbhLOXtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 18:49:22 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id E4349607E0;
        Thu, 16 Dec 2021 00:46:51 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH nf-next 0/7] Netfilter updates for net-next
Date:   Thu, 16 Dec 2021 00:49:04 +0100
Message-Id: <20211215234911.170741-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter updates for net-next, mostly
rather small housekeeping patches:

1) Remove unused variable in IPVS, from GuoYong Zheng.

2) Use memset_after in conntrack, from Kees Cook.

3) Remove leftover function in nfnetlink_queue, from Florian Westphal.

4) Remove redundant test on bool in conntrack, from Bernard Zhao.

5) egress support for nft_fwd, from Lukas Wunner.

6) Make pppoe work for br_netfilter, from Florian Westphal.

7) Remove unused variable in conntrack resize routine, from luo penghao.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks.

----------------------------------------------------------------

The following changes since commit 196073f9c44be0b4758ead11e51bc2875f98df29:

  net: ixp4xx_hss: drop kfree for memory allocated with devm_kzalloc (2021-11-30 12:40:22 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 284ca7647c67683b32f4f8c0dec6cc38cb2cb9f8:

  netfilter: conntrack: Remove useless assignment statements (2021-12-16 00:17:40 +0100)

----------------------------------------------------------------
Bernard Zhao (1):
      netfilter: ctnetlink: remove useless type conversion to bool

Florian Westphal (2):
      netfilter: nf_queue: remove leftover synchronize_rcu
      netfilter: bridge: add support for pppoe filtering

GuoYong Zheng (1):
      ipvs: remove unused variable for ip_vs_new_dest

Kees Cook (1):
      netfilter: conntrack: Use memset_startat() to zero struct nf_conn

Pablo Neira Ayuso (1):
      netfilter: nft_fwd_netdev: Support egress hook

luo penghao (1):
      netfilter: conntrack: Remove useless assignment statements

 net/bridge/br_netfilter_hooks.c      | 7 +++----
 net/netfilter/ipvs/ip_vs_ctl.c       | 7 ++-----
 net/netfilter/nf_conntrack_core.c    | 5 +----
 net/netfilter/nf_conntrack_netlink.c | 2 +-
 net/netfilter/nfnetlink_queue.c      | 6 ------
 net/netfilter/nft_fwd_netdev.c       | 7 +++++--
 6 files changed, 12 insertions(+), 22 deletions(-)
