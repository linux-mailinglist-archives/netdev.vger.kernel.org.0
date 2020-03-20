Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48BBC18CF76
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 14:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725446AbgCTNvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 09:51:42 -0400
Received: from correo.us.es ([193.147.175.20]:41498 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726838AbgCTNvm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 09:51:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2B451172C8A
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 14:51:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1ACEBDA3A3
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 14:51:08 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 107B6DA3A9; Fri, 20 Mar 2020 14:51:08 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C3EFFDA788;
        Fri, 20 Mar 2020 14:51:05 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 20 Mar 2020 14:51:05 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9FE3242EE393;
        Fri, 20 Mar 2020 14:51:05 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/4] Netfilter fixes for net
Date:   Fri, 20 Mar 2020 14:51:30 +0100
Message-Id: <20200320135134.436907-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Refetch IP header pointer after pskb_may_pull() in flowtable,
   from Haishuang Yan.

2) Fix memleak in flowtable offload in nf_flow_table_free(),
   from Paul Blakey.

3) Set control.addr_type mask in flowtable offload, from Edward Cree.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thank you.

----------------------------------------------------------------

The following changes since commit 3c025b6317272ee8493ee20fa5035c087626af48:

  Merge branch 'wireguard-fixes' (2020-03-18 18:51:43 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 15ff197237e76c4dab06b7b518afaa4ebb1c43e0:

  netfilter: flowtable: populate addr_type mask (2020-03-19 21:20:04 +0100)

----------------------------------------------------------------
Edward Cree (1):
      netfilter: flowtable: populate addr_type mask

Haishuang Yan (2):
      netfilter: flowtable: reload ip{v6}h in nf_flow_nat_ip{v6}
      netfilter: flowtable: reload ip{v6}h in nf_flow_tuple_ip{v6}

Paul Blakey (1):
      netfilter: flowtable: Fix flushing of offloaded flows on free

 net/netfilter/nf_flow_table_core.c    |  3 +++
 net/netfilter/nf_flow_table_ip.c      | 14 ++++++++++----
 net/netfilter/nf_flow_table_offload.c |  1 +
 3 files changed, 14 insertions(+), 4 deletions(-)
