Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07931E515C
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 00:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbgE0Wkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 18:40:43 -0400
Received: from correo.us.es ([193.147.175.20]:33430 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgE0Wkn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 18:40:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9707BEB46C
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 00:40:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 89B31DA712
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 00:40:42 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7DB9EDA716; Thu, 28 May 2020 00:40:42 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D9CC8DA705;
        Thu, 28 May 2020 00:40:38 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 28 May 2020 00:40:38 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id AAE0A42EF4E0;
        Thu, 28 May 2020 00:40:38 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 0/3] Netfilter fixes for net
Date:   Thu, 28 May 2020 00:40:15 +0200
Message-Id: <20200527224018.3610-1-pablo@netfilter.org>
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

1) Uninitialized when used in __nf_conntrack_update(), from
   Nathan Chancellor.

2) Comparison of unsigned expression in nf_confirm_cthelper().

3) Remove 'const' type qualifier with no effect.

This batch is addressing fallout from the previous pull request.

Please, pull this updates from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thank you.

----------------------------------------------------------------

The following changes since commit a4976a3ef844c510ae9120290b23e9f3f47d6bce:

  crypto: chelsio/chtls: properly set tp->lsndtime (2020-05-26 23:24:00 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 4946ea5c1237036155c3b3a24f049fd5f849f8f6:

  netfilter: nf_conntrack_pptp: fix compilation warning with W=1 build (2020-05-27 13:39:08 +0200)

----------------------------------------------------------------
Nathan Chancellor (1):
      netfilter: conntrack: Pass value of ctinfo to __nf_conntrack_update

Pablo Neira Ayuso (2):
      netfilter: conntrack: comparison of unsigned in cthelper confirmation
      netfilter: nf_conntrack_pptp: fix compilation warning with W=1 build

 include/linux/netfilter/nf_conntrack_pptp.h | 2 +-
 net/netfilter/nf_conntrack_core.c           | 8 ++++----
 net/netfilter/nf_conntrack_pptp.c           | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)
