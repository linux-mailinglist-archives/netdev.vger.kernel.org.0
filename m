Return-Path: <netdev+bounces-3342-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8747706845
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:38:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E4E428181A
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:38:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A27818B03;
	Wed, 17 May 2023 12:38:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E612211C
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 12:38:11 +0000 (UTC)
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745A6468D;
	Wed, 17 May 2023 05:38:09 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1pzGPo-0004TC-My; Wed, 17 May 2023 14:38:00 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>
Subject: [PATCH net 0/3] Netfilter fixes for net
Date: Wed, 17 May 2023 14:37:53 +0200
Message-Id: <20230517123756.7353-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

This PR has three patches for your *net* tree:

1. Silence warning about unused variable when CONFIG_NF_NAT=n, from Tom Rix.
2. nftables: Fix possible out-of-bounds access, from myself.
3. nftables: fix null deref+UAF during element insertion into rbtree,
   also from myself.

The following changes since commit ab87603b251134441a67385ecc9d3371be17b7a7:

  net: wwan: t7xx: Ensure init is completed before system sleep (2023-05-17 13:02:25 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-23-05-17

for you to fetch changes up to 61ae320a29b0540c16931816299eb86bf2b66c08:

  netfilter: nft_set_rbtree: fix null deref on element insertion (2023-05-17 14:18:28 +0200)

----------------------------------------------------------------
Florian Westphal (2):
      netfilter: nf_tables: fix nft_trans type confusion
      netfilter: nft_set_rbtree: fix null deref on element insertion

Tom Rix (1):
      netfilter: conntrack: define variables exp_nat_nla_policy and any_addr with CONFIG_NF_NAT

 net/netfilter/nf_conntrack_netlink.c |  4 ++++
 net/netfilter/nf_tables_api.c        |  4 +---
 net/netfilter/nft_set_rbtree.c       | 20 +++++++++++++-------
-- 
2.39.3


