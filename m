Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAAF5603A22
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 08:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiJSGwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 02:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiJSGwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 02:52:35 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DA17A74CFB;
        Tue, 18 Oct 2022 23:52:31 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/2] Netfilter fixes for net
Date:   Wed, 19 Oct 2022 08:52:23 +0200
Message-Id: <20221019065225.1006344-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Missing flowi uid field in nft_fib expression, from Guillaume Nault.
   This is broken since the creation of the fib expression.

2) Relax sanity check to fix bogus EINVAL error when deleting elements
   belonging set intervals. Broken since 6.0-rc.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 1ca695207ed2271ecbf8ee6c641970f621c157cc:

  ip6mr: fix UAF issue in ip6mr_sk_done() when addrconf_init_net() failed (2022-10-18 11:05:55 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to 96df8360dbb435cc69f7c3c8db44bf8b1c24cd7b:

  netfilter: nf_tables: relax NFTA_SET_ELEM_KEY_END set flags requirements (2022-10-19 08:46:48 +0200)

----------------------------------------------------------------
Guillaume Nault (1):
      netfilter: rpfilter/fib: Set ->flowic_uid correctly for user namespaces.

Pablo Neira Ayuso (1):
      netfilter: nf_tables: relax NFTA_SET_ELEM_KEY_END set flags requirements

 net/ipv4/netfilter/ipt_rpfilter.c  | 1 +
 net/ipv4/netfilter/nft_fib_ipv4.c  | 1 +
 net/ipv6/netfilter/ip6t_rpfilter.c | 1 +
 net/ipv6/netfilter/nft_fib_ipv6.c  | 2 ++
 net/netfilter/nf_tables_api.c      | 5 +++--
 5 files changed, 8 insertions(+), 2 deletions(-)
