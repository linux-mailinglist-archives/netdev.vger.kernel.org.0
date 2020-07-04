Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4EB214245
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 02:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgGDAOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 20:14:06 -0400
Received: from correo.us.es ([193.147.175.20]:56754 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726455AbgGDAOG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 20:14:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B1FE3ED5C2
        for <netdev@vger.kernel.org>; Sat,  4 Jul 2020 02:14:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A491DDA78B
        for <netdev@vger.kernel.org>; Sat,  4 Jul 2020 02:14:04 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 99DB8DA78A; Sat,  4 Jul 2020 02:14:04 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7F49CDA72F;
        Sat,  4 Jul 2020 02:14:02 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 04 Jul 2020 02:14:02 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 5A73942EF532;
        Sat,  4 Jul 2020 02:14:02 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/2] Netfilter fixes for net
Date:   Sat,  4 Jul 2020 02:13:57 +0200
Message-Id: <20200704001359.1304-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Use kvfree() to release vmalloc()'ed areas in ipset, from Eric Dumazet.

2) UAF in nfnetlink_queue from the nf_conntrack_update() path.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thank you.

----------------------------------------------------------------

The following changes since commit 33c568ba49e2b0ff7c3daead5d9427be797a4c43:

  Merge tag 'mac80211-for-net-2020-06-29' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211 (2020-06-29 16:58:30 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to d005fbb855d3b5660d62ee5a6bd2d99c13ff8cf3:

  netfilter: conntrack: refetch conntrack after nf_conntrack_update() (2020-07-03 14:47:03 +0200)

----------------------------------------------------------------
Eric Dumazet (1):
      netfilter: ipset: call ip_set_free() instead of kfree()

Pablo Neira Ayuso (1):
      netfilter: conntrack: refetch conntrack after nf_conntrack_update()

 net/netfilter/ipset/ip_set_bitmap_ip.c    | 2 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c | 2 +-
 net/netfilter/ipset/ip_set_bitmap_port.c  | 2 +-
 net/netfilter/ipset/ip_set_hash_gen.h     | 4 ++--
 net/netfilter/nf_conntrack_core.c         | 2 ++
 5 files changed, 7 insertions(+), 5 deletions(-)
