Return-Path: <netdev+bounces-220-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF00C6F5FE3
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 22:13:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41CD91C20A71
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 20:13:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64AA3BE5F;
	Wed,  3 May 2023 20:13:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56900BE5B
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 20:13:13 +0000 (UTC)
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6F5108A67;
	Wed,  3 May 2023 13:12:32 -0700 (PDT)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com
Subject: [PATCH net 0/1] Netfilter fixes for net
Date: Wed,  3 May 2023 22:11:42 +0200
Message-Id: <20230503201143.12310-1-pablo@netfilter.org>
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

The following patchset contains one Netfilter fix:

1) Restore 'ct state untracked' matching with CONFIG_RETPOLINE=y,
   from Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 6a341729fb31b4c5df9f74f24b4b1c98410c9b87:

  af_packet: Don't send zero-byte data in packet_sendmsg_spkt(). (2023-05-03 09:20:18 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-23-05-03

for you to fetch changes up to f057b63bc11d86a98176de31b437e46789f44d8f:

  netfilter: nf_tables: fix ct untracked match breakage (2023-05-03 13:49:08 +0200)

----------------------------------------------------------------
netfilter pull request 23-05-03

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: nf_tables: fix ct untracked match breakage

 net/netfilter/nft_ct_fast.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

