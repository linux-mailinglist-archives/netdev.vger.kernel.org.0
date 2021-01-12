Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFEAA2F3F85
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394523AbhALWWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 17:22:46 -0500
Received: from correo.us.es ([193.147.175.20]:49888 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404782AbhALWV0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 17:21:26 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 73E7ED28C4
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 23:19:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 65899DA72F
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 23:19:58 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5B486DA73D; Tue, 12 Jan 2021 23:19:58 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 157E2DA72F;
        Tue, 12 Jan 2021 23:19:56 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 12 Jan 2021 23:19:56 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.lan (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id CA16942EF528;
        Tue, 12 Jan 2021 23:19:55 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/3] Netfilter fixes for net
Date:   Tue, 12 Jan 2021 23:20:30 +0100
Message-Id: <20210112222033.9732-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Pass conntrack -f to specify family in netfilter conntrack helper
   selftests, from Chen Yi.

2) Honor hashsize modparam from nf_conntrack_buckets sysctl,
   from Jesper D. Brouer.

3) Fix memleak in nf_nat_init() error path, from Dinghao Liu.

Chen Yi (1):
  selftests: netfilter: Pass family parameter "-f" to conntrack tool

Dinghao Liu (1):
  netfilter: nf_nat: Fix memleak in nf_nat_init

Jesper Dangaard Brouer (1):
  netfilter: conntrack: fix reading nf_conntrack_buckets

 net/netfilter/nf_conntrack_standalone.c              |  3 +++
 net/netfilter/nf_nat_core.c                          |  1 +
 .../selftests/netfilter/nft_conntrack_helper.sh      | 12 +++++++++---
 3 files changed, 13 insertions(+), 3 deletions(-)

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

----------------------------------------------------------------

The following changes since commit c49243e8898233de18edfaaa5b7b261ea457f221:

  Merge branch 'net-fix-issues-around-register_netdevice-failures' (2021-01-08 19:27:44 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 869f4fdaf4ca7bb6e0d05caf6fa1108dddc346a7:

  netfilter: nf_nat: Fix memleak in nf_nat_init (2021-01-11 00:34:11 +0100)

----------------------------------------------------------------
Chen Yi (1):
      selftests: netfilter: Pass family parameter "-f" to conntrack tool

Dinghao Liu (1):
      netfilter: nf_nat: Fix memleak in nf_nat_init

Jesper Dangaard Brouer (1):
      netfilter: conntrack: fix reading nf_conntrack_buckets

 net/netfilter/nf_conntrack_standalone.c                   |  3 +++
 net/netfilter/nf_nat_core.c                               |  1 +
 tools/testing/selftests/netfilter/nft_conntrack_helper.sh | 12 +++++++++---
 3 files changed, 13 insertions(+), 3 deletions(-)
