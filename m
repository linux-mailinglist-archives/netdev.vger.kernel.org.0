Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6677A3989E8
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhFBMqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:46:22 -0400
Received: from mail.netfilter.org ([217.70.188.207]:41562 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhFBMqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 08:46:18 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id EEFEA64156;
        Wed,  2 Jun 2021 14:43:26 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/2] Netfilter fixes for net
Date:   Wed,  2 Jun 2021 14:44:28 +0200
Message-Id: <20210602124430.10863-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Do not allow to add conntrack helper extension for confirmed
   conntracks in the nf_tables ct expectation support.

2) Fix bogus EBUSY in nfnetlink_cthelper when NFCTH_PRIV_DATA_LEN
   is passed on userspace helper updates.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thank you!

----------------------------------------------------------------

The following changes since commit b000372627ce9dbbe641dafbf40db0718276ab77:

  MAINTAINERS: nfc mailing lists are subscribers-only (2021-06-01 17:09:28 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 8971ee8b087750a23f3cd4dc55bff2d0303fd267:

  netfilter: nfnetlink_cthelper: hit EBUSY on updates if size mismatches (2021-06-02 12:43:50 +0200)

----------------------------------------------------------------
Pablo Neira Ayuso (2):
      netfilter: nft_ct: skip expectations for confirmed conntrack
      netfilter: nfnetlink_cthelper: hit EBUSY on updates if size mismatches

 net/netfilter/nfnetlink_cthelper.c | 8 ++++++--
 net/netfilter/nft_ct.c             | 2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)
