Return-Path: <netdev+bounces-8639-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B9B472505F
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 00:59:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70BF7280FF8
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 22:58:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9BE231F03;
	Tue,  6 Jun 2023 22:58:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00527E4
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 22:58:57 +0000 (UTC)
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 506551717;
	Tue,  6 Jun 2023 15:58:56 -0700 (PDT)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 0/5] Netfilter fixes for net
Date: Wed,  7 Jun 2023 00:58:46 +0200
Message-Id: <20230606225851.67394-1-pablo@netfilter.org>
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

1) Missing nul-check in basechain hook netlink dump path, from Gavrilov Ilia.

2) Fix bitwise register tracking, from Jeremy Sowden.

3) Null pointer dereference when accessing conntrack helper,
   from Tijs Van Buggenhout.

4) Add schedule point to ipset's call_ad, from Kuniyuki Iwashima.

5) Incorrect boundary check when building chain blob.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-23-06-07

Thanks.

----------------------------------------------------------------

The following changes since commit 9025944fddfed5966c8f102f1fe921ab3aee2c12:

  net: fec: add dma_wmb to ensure correct descriptor values (2023-05-19 09:17:53 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-23-06-07

for you to fetch changes up to 08e42a0d3ad30f276f9597b591f975971a1b0fcf:

  netfilter: nf_tables: out-of-bound check in chain blob (2023-06-07 00:43:44 +0200)

----------------------------------------------------------------
netfilter pull request 23-06-07

----------------------------------------------------------------
Gavrilov Ilia (1):
      netfilter: nf_tables: Add null check for nla_nest_start_noflag() in nft_dump_basechain_hook()

Jeremy Sowden (1):
      netfilter: nft_bitwise: fix register tracking

Kuniyuki Iwashima (1):
      netfilter: ipset: Add schedule point in call_ad().

Pablo Neira Ayuso (1):
      netfilter: nf_tables: out-of-bound check in chain blob

Tijs Van Buggenhout (1):
      netfilter: conntrack: fix NULL pointer dereference in nf_confirm_cthelper

 net/netfilter/ipset/ip_set_core.c | 8 ++++++++
 net/netfilter/nf_conntrack_core.c | 3 +++
 net/netfilter/nf_tables_api.c     | 4 +++-
 net/netfilter/nft_bitwise.c       | 2 +-
 4 files changed, 15 insertions(+), 2 deletions(-)

