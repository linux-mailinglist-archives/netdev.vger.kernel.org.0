Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD3046A76BB
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 23:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjCAWUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 17:20:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjCAWUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 17:20:32 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 66F1D521EF;
        Wed,  1 Mar 2023 14:20:29 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/3] Netfilter fixes for net
Date:   Wed,  1 Mar 2023 23:20:18 +0100
Message-Id: <20230301222021.154670-1-pablo@netfilter.org>
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

1) Fix bogus error report in selftests/netfilter/nft_nat.sh,
   from Hangbin Liu.

2) Initialize last and quota expressions from template when
   expr_ops::clone is called, otherwise, states are not restored
   accordingly when loading a dynamic set with elements using
   these two expressions.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 8f9850dd8d23c1290cb642ce9548a440da5771ec:

  net: phy: unlock on error in phy_probe() (2023-02-28 12:40:12 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to aabef97a35160461e9c576848ded737558d89055:

  netfilter: nft_quota: copy content when cloning expression (2023-03-01 17:23:23 +0100)

----------------------------------------------------------------
Hangbin Liu (1):
      selftests: nft_nat: ensuring the listening side is up before starting the client

Pablo Neira Ayuso (2):
      netfilter: nft_last: copy content when cloning expression
      netfilter: nft_quota: copy content when cloning expression

 net/netfilter/nft_last.c                     | 4 ++++
 net/netfilter/nft_quota.c                    | 6 +++++-
 tools/testing/selftests/netfilter/nft_nat.sh | 2 ++
 3 files changed, 11 insertions(+), 1 deletion(-)
