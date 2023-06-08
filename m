Return-Path: <netdev+bounces-9340-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AF7BD728913
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 21:57:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53DBD28179B
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 19:57:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35FB02D246;
	Thu,  8 Jun 2023 19:57:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DF21F187
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 19:57:16 +0000 (UTC)
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 923231FDE;
	Thu,  8 Jun 2023 12:57:15 -0700 (PDT)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com
Subject: [PATCH net 0/3] Netfilter fixes for net
Date: Thu,  8 Jun 2023 21:57:03 +0200
Message-Id: <20230608195706.4429-1-pablo@netfilter.org>
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

1) Add commit and abort set operation to pipapo set abort path.

2) Bail out immediately in case of ENOMEM in nfnetlink batch.

3) Incorrect error path handling when creating a new rule leads to
   dangling pointer in set transaction list.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-23-06-08

Thanks.

----------------------------------------------------------------

The following changes since commit ab39b113e74751958aac1b125a14ee42bd7d3efd:

  Merge tag 'for-net-2023-06-05' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth (2023-06-06 21:36:57 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-23-06-08

for you to fetch changes up to 1240eb93f0616b21c675416516ff3d74798fdc97:

  netfilter: nf_tables: incorrect error path handling with NFT_MSG_NEWRULE (2023-06-08 21:49:26 +0200)

----------------------------------------------------------------
netfilter pull request 23-06-08

----------------------------------------------------------------
Pablo Neira Ayuso (3):
      netfilter: nf_tables: integrate pipapo into commit protocol
      netfilter: nfnetlink: skip error delivery on batch in case of ENOMEM
      netfilter: nf_tables: incorrect error path handling with NFT_MSG_NEWRULE

 include/net/netfilter/nf_tables.h |  4 ++-
 net/netfilter/nf_tables_api.c     | 59 ++++++++++++++++++++++++++++++++++++++-
 net/netfilter/nfnetlink.c         |  3 +-
 net/netfilter/nft_set_pipapo.c    | 55 ++++++++++++++++++++++++++----------
 4 files changed, 103 insertions(+), 18 deletions(-)

