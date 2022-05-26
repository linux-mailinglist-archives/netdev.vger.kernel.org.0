Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1A9453552A
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 22:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349038AbiEZUyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 16:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349152AbiEZUyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 16:54:21 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DAE2FE8B8C;
        Thu, 26 May 2022 13:54:15 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: [PATCH net 0/2] Netfilter fixes for net
Date:   Thu, 26 May 2022 22:54:09 +0200
Message-Id: <20220526205411.315136-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Fix UAF when creating non-stateful expression in set.

2) Set limit cost when cloning expression accordingly, from Phil Sutter.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 6c465408a7709cf180cde7569e141191b67a175c:

  dt-bindings: net: adin: Fix adi,phy-output-clock description syntax (2022-05-25 22:03:45 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to 558254b0b602b8605d7246a10cfeb584b1fcabfc:

  netfilter: nft_limit: Clone packet limits' cost value (2022-05-26 22:50:34 +0200)

----------------------------------------------------------------
Pablo Neira Ayuso (1):
      netfilter: nf_tables: disallow non-stateful expression in sets earlier

Phil Sutter (1):
      netfilter: nft_limit: Clone packet limits' cost value

 net/netfilter/nf_tables_api.c | 19 ++++++++++---------
 net/netfilter/nft_limit.c     |  2 ++
 2 files changed, 12 insertions(+), 9 deletions(-)
