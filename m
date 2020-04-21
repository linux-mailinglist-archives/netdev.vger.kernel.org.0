Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3394C1B23FA
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 12:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbgDUKiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 06:38:16 -0400
Received: from correo.us.es ([193.147.175.20]:50996 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728285AbgDUKiJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 06:38:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A6DBAFB443
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 12:38:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 99F26BAC2F
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 12:38:05 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8FB0B20294; Tue, 21 Apr 2020 12:38:05 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B37DEFC553;
        Tue, 21 Apr 2020 12:38:03 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 21 Apr 2020 12:38:03 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8477142EF42B;
        Tue, 21 Apr 2020 12:38:03 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/2] Netfilter fixes for net
Date:   Tue, 21 Apr 2020 12:37:57 +0200
Message-Id: <20200421103759.959074-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) flow_block_cb memleak in nf_flow_table_offload_del_cb(), from Roi Dayan.

2) Fix error path handling in nf_nat_inet_register_fn(), from Hillf Danton.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thank you.

----------------------------------------------------------------

The following changes since commit 82f35276c64ff720de11fba31fd6369b45647a2e:

  Merge tag 'wireless-drivers-2020-04-14' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers (2020-04-14 13:07:19 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to b4faef1739dd1f3b3981b8bf173a2266ea86b1eb:

  netfilter: nat: fix error handling upon registering inet hook (2020-04-19 14:59:31 +0200)

----------------------------------------------------------------
Hillf Danton (1):
      netfilter: nat: fix error handling upon registering inet hook

Roi Dayan (1):
      netfilter: flowtable: Free block_cb when being deleted

 net/netfilter/nf_flow_table_core.c | 6 ++++--
 net/netfilter/nf_nat_proto.c       | 4 ++--
 2 files changed, 6 insertions(+), 4 deletions(-)
