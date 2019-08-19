Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11F9794D60
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 20:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbfHSS7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 14:59:39 -0400
Received: from correo.us.es ([193.147.175.20]:37874 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728332AbfHSS7g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 14:59:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 02802F2623
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 20:50:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E974EB8005
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 20:50:09 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DF345B8001; Mon, 19 Aug 2019 20:50:09 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E1174B7FF2;
        Mon, 19 Aug 2019 20:50:07 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 19 Aug 2019 20:50:07 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.209.241])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 699574265A32;
        Mon, 19 Aug 2019 20:50:07 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/5] Netfilter fixes for net
Date:   Mon, 19 Aug 2019 20:49:06 +0200
Message-Id: <20190819184911.15263-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Remove IP MASQUERADING record in MAINTAINERS file,
   from Denis Efremov.

2) Counter arguments are swapped in ebtables, from
   Todd Seidelmann.

3) Missing netlink attribute validation in flow_offload
   extension.

4) Incorrect alignment in xt_nfacct that breaks 32-bits
   userspace / 64-bits kernels, from Juliana Rodrigueiro.

5) Missing include guard in nf_conntrack_h323_types.h,
   from Masahiro Yamada.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit cfef46d692efd852a0da6803f920cc756eea2855:

  ravb: Fix use-after-free ravb_tstamp_skb (2019-08-18 14:19:14 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 38a429c898ddd210cc35463b096389f97c3c5a73:

  netfilter: add include guard to nf_conntrack_h323_types.h (2019-08-19 13:59:57 +0200)

----------------------------------------------------------------
Denis Efremov (1):
      MAINTAINERS: Remove IP MASQUERADING record

Juliana Rodrigueiro (1):
      netfilter: xt_nfacct: Fix alignment mismatch in xt_nfacct_match_info

Masahiro Yamada (1):
      netfilter: add include guard to nf_conntrack_h323_types.h

Pablo Neira Ayuso (1):
      netfilter: nft_flow_offload: missing netlink attribute policy

Todd Seidelmann (1):
      netfilter: ebtables: Fix argument order to ADD_COUNTER

 MAINTAINERS                                       |  5 ----
 include/linux/netfilter/nf_conntrack_h323_types.h |  5 ++++
 include/uapi/linux/netfilter/xt_nfacct.h          |  5 ++++
 net/bridge/netfilter/ebtables.c                   |  8 ++---
 net/netfilter/nft_flow_offload.c                  |  6 ++++
 net/netfilter/xt_nfacct.c                         | 36 ++++++++++++++++-------
 6 files changed, 45 insertions(+), 20 deletions(-)

