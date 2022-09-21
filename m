Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 073505BFBB4
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 11:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbiIUJxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 05:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiIUJwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 05:52:54 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77CDFE3B;
        Wed, 21 Sep 2022 02:50:13 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oawMs-0006Pf-Ig; Wed, 21 Sep 2022 11:50:10 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     <netfilter-devel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 0/4] netfilter patches for net-next
Date:   Wed, 21 Sep 2022 11:49:56 +0200
Message-Id: <20220921095000.29569-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

The following set contains netfilter changes for the *net-next* tree.

Remove GPL license copypastry in uapi files, those have SPDX tags.
From Christophe Jaillet.

Remove unused variable in rpfilter, from Guillaume Nault.

Rework gc resched delay computation in conntrack, from Antoine Tenart.

Please consider pulling these changes from
  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git


----------------------------------------------------------------
The following changes since commit c29b068215906d33f75378d44526edc37ad08276:

  liquidio: CN23XX: delete repeated words, add missing words and fix typo in comment (2022-09-20 16:50:21 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git master

for you to fetch changes up to 72f5c89804636b5b4c8599354a92d6df8cff42cc:

  netfilter: rpfilter: Remove unused variable 'ret'. (2022-09-21 10:44:56 +0200)

----------------------------------------------------------------
Antoine Tenart (2):
      netfilter: conntrack: fix the gc rescheduling delay
      netfilter: conntrack: revisit the gc initial rescheduling bias

Christophe JAILLET (1):
      headers: Remove some left-over license text in include/uapi/linux/netfilter/

Guillaume Nault (1):
      netfilter: rpfilter: Remove unused variable 'ret'.

 include/uapi/linux/netfilter/ipset/ip_set.h |  4 ----
 include/uapi/linux/netfilter/xt_AUDIT.h     |  4 ----
 include/uapi/linux/netfilter/xt_connmark.h  | 13 ++++---------
 include/uapi/linux/netfilter/xt_osf.h       | 14 --------------
 net/ipv4/netfilter/ipt_rpfilter.c           |  1 -
 net/netfilter/nf_conntrack_core.c           | 18 +++++++++++++-----
 6 files changed, 17 insertions(+), 37 deletions(-)
