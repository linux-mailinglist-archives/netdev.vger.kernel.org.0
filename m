Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E009C1BEA28
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 23:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgD2VsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 17:48:21 -0400
Received: from correo.us.es ([193.147.175.20]:60650 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbgD2VsV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 17:48:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6AA8A12BFEC
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 23:48:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5BECFBAAB1
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 23:48:19 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 515C3615D1; Wed, 29 Apr 2020 23:48:19 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 64A45BAC2F;
        Wed, 29 Apr 2020 23:48:17 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 Apr 2020 23:48:17 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 39A2E42EF9E0;
        Wed, 29 Apr 2020 23:48:17 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/2] Netfilter fixes for net
Date:   Wed, 29 Apr 2020 23:48:09 +0200
Message-Id: <20200429214811.19941-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following patchset contains Netfilter fixes for net:

1) Do not update the UDP checksum when it's zero, from Guillaume Nault.

2) Fix return of local variable in nf_osf, from Arnd Bergmann.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thank you.

----------------------------------------------------------------

The following changes since commit 52a90612fa6108d20cffd3cf6a2c228e2f3619f7:

  net: remove obsolete comment (2020-04-25 20:49:32 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to c165d57b552aaca607fa5daf3fb524a6efe3c5a3:

  netfilter: nf_osf: avoid passing pointer to local var (2020-04-29 21:17:57 +0200)

----------------------------------------------------------------
Arnd Bergmann (1):
      netfilter: nf_osf: avoid passing pointer to local var

Guillaume Nault (1):
      netfilter: nat: never update the UDP checksum when it's 0

 net/netfilter/nf_nat_proto.c  |  4 +---
 net/netfilter/nfnetlink_osf.c | 12 +++++++-----
 2 files changed, 8 insertions(+), 8 deletions(-)
