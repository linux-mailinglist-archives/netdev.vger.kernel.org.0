Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA856B2C40
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 18:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbjCIRrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 12:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjCIRrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 12:47:01 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 85A90FAFBB;
        Thu,  9 Mar 2023 09:47:00 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/4] Netfilter fixes for net
Date:   Thu,  9 Mar 2023 18:46:51 +0100
Message-Id: <20230309174655.69816-1-pablo@netfilter.org>
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

1) nft_parse_register_load() gets an incorrect datatype size
   as input, from Jeremy Sowden.

2) incorrect maximum netlink attribute in nft_redir, also
   from Jeremy.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 37d9df224d1eec1b434fe9ffa40104c756478c29:

  ynl: re-license uniformly under GPL-2.0 OR BSD-3-Clause (2023-03-07 13:44:30 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to 493924519b1fe3faab13ee621a43b0d0939abab1:

  netfilter: nft_redir: correct value of inet type `.maxattrs` (2023-03-08 12:26:42 +0100)

----------------------------------------------------------------
Jeremy Sowden (4):
      netfilter: nft_nat: correct length for loading protocol registers
      netfilter: nft_masq: correct length for loading protocol registers
      netfilter: nft_redir: correct length for loading protocol registers
      netfilter: nft_redir: correct value of inet type `.maxattrs`

 net/netfilter/nft_masq.c  | 2 +-
 net/netfilter/nft_nat.c   | 2 +-
 net/netfilter/nft_redir.c | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)
