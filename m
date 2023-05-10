Return-Path: <netdev+bounces-1360-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 419176FD983
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 10:34:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6244B281419
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 08:34:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A540366;
	Wed, 10 May 2023 08:34:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB07364
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 08:34:51 +0000 (UTC)
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC25E30DA;
	Wed, 10 May 2023 01:34:20 -0700 (PDT)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com
Subject: [PATCH net 0/7] Netfilter updates for net
Date: Wed, 10 May 2023 10:33:06 +0200
Message-Id: <20230510083313.152961-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

The following patchset contains Netfilter fixes for net:

1) Fix UAF when releasing netnamespace, from Florian Westphal.

2) Fix possible BUG_ON when nf_conntrack is enabled with enable_hooks,
   from Florian Westphal.

3) Fixes for nft_flowtable.sh selftest, from Boris Sukholitko.

4) Extend nft_flowtable.sh selftest to cover integration with
   ingress/egress hooks, from Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-23-05-10

Thanks.

----------------------------------------------------------------

The following changes since commit 582dbb2cc1a0a7427840f5b1e3c65608e511b061:

  net: phy: bcm7xx: Correct read from expansion register (2023-05-09 20:25:52 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-23-05-10

for you to fetch changes up to 3acf8f6c14d0e42b889738d63b6d9cb63348fc94:

  selftests: nft_flowtable.sh: check ingress/egress chain too (2023-05-10 09:31:07 +0200)

----------------------------------------------------------------
netfilter pull request 23-05-10

----------------------------------------------------------------
Boris Sukholitko (4):
      selftests: nft_flowtable.sh: use /proc for pid checking
      selftests: nft_flowtable.sh: no need for ps -x option
      selftests: nft_flowtable.sh: wait for specific nc pids
      selftests: nft_flowtable.sh: monitor result file sizes

Florian Westphal (3):
      netfilter: nf_tables: always release netdev hooks from notifier
      netfilter: conntrack: fix possible bug_on with enable_hooks=1
      selftests: nft_flowtable.sh: check ingress/egress chain too

 net/netfilter/core.c                               |   6 +-
 net/netfilter/nf_conntrack_standalone.c            |   3 +-
 net/netfilter/nft_chain_filter.c                   |   9 +-
 tools/testing/selftests/netfilter/nft_flowtable.sh | 145 ++++++++++++++++++++-
 4 files changed, 151 insertions(+), 12 deletions(-)

