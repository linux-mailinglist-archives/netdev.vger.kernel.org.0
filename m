Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A788431DF61
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 20:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbhBQTEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 14:04:38 -0500
Received: from correo.us.es ([193.147.175.20]:40438 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229752AbhBQTE1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 14:04:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 67E9DC5170
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 20:03:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 58CCADA78F
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 20:03:44 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4DBC8DA78C; Wed, 17 Feb 2021 20:03:44 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0267ADA78A;
        Wed, 17 Feb 2021 20:03:42 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 17 Feb 2021 20:03:42 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id CB70542DC700;
        Wed, 17 Feb 2021 20:03:41 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 0/3] Netfilter updates for net-next
Date:   Wed, 17 Feb 2021 20:03:29 +0100
Message-Id: <20210217190332.21722-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter updates for net-next:

1) Add two helper functions to release one table and hooks from
   the netns and netlink event path.

2) Add table ownership infrastructure, this new infrastructure allows
   users to bind a table (and its content) to a process through the
   netlink socket.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks!

----------------------------------------------------------------

The following changes since commit c4762993129f48f5f5e233f09c246696815ef263:

  Merge branch 'skbuff-introduce-skbuff_heads-bulking-and-reusing' (2021-02-13 14:32:04 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 6001a930ce0378b62210d4f83583fc88a903d89d:

  netfilter: nftables: introduce table ownership (2021-02-15 18:17:15 +0100)

----------------------------------------------------------------
Pablo Neira Ayuso (3):
      netfilter: nftables: add helper function to release one table
      netfilter: nftables: add helper function to release hooks of one single table
      netfilter: nftables: introduce table ownership

 include/net/netfilter/nf_tables.h        |   6 +
 include/uapi/linux/netfilter/nf_tables.h |   5 +
 net/netfilter/nf_tables_api.c            | 245 ++++++++++++++++++++-----------
 3 files changed, 174 insertions(+), 82 deletions(-)
