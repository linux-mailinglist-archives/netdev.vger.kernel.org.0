Return-Path: <netdev+bounces-102-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AC586F5274
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 10:00:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C261E1C20AEA
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 08:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13BF363B2;
	Wed,  3 May 2023 08:00:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B158423AF
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 08:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5CF91C433A4;
	Wed,  3 May 2023 08:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683100821;
	bh=hs/2ZMPXNyQHVQBAjvuBziSuly5LxIFID8MWydHsfGQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=XI31lsKOk5daDIkD32JiljILIqbHR2Up9/f0ZN7z4jAEHINFJWdcjD9fKrZCyS5/T
	 gUcKceBjC4wlenJ27bY7tI78JN4p87dwbRCPRRRs3tPYRCzQdT5f8J986YyrWpMizm
	 pDN4OQm/5XdWMcbLFKIkW2j+oZDuyRplRR4EXMnFFTiNCm37vAu1euTPJCXvka7W3N
	 l1fsMVMwUw6AKsXy6Pp6Frg/sWm2aIuoLfaBPqJLeEebeZsg/0gFdkeGdUvXU9DjBV
	 sCYWfc4POEteQ27Go5iFKVzgPxe8o/o5ueNBkdUJrkGZ/dJuhH67UQ+chxNGE0h4pH
	 6kGSQbVFGV2WA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 434C2E5FFC9;
	Wed,  3 May 2023 08:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] netfilter: nf_tables: hit ENOENT on unexisting
 chain/flowtable update with missing attributes
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168310082126.9142.6120600309430037427.git-patchwork-notify@kernel.org>
Date: Wed, 03 May 2023 08:00:21 +0000
References: <20230503063250.13700-2-pablo@netfilter.org>
In-Reply-To: <20230503063250.13700-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed,  3 May 2023 08:32:48 +0200 you wrote:
> If user does not specify hook number and priority, then assume this is
> a chain/flowtable update. Therefore, report ENOENT which provides a
> better hint than EINVAL. Set on extended netlink error report to refer
> to the chain name.
> 
> Fixes: 5b6743fb2c2a ("netfilter: nf_tables: skip flowtable hooknum and priority on device updates")
> Fixes: 5efe72698a97 ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net,1/3] netfilter: nf_tables: hit ENOENT on unexisting chain/flowtable update with missing attributes
    https://git.kernel.org/netdev/net/c/8509f62b0b07
  - [net,2/3] selftests: netfilter: fix libmnl pkg-config usage
    https://git.kernel.org/netdev/net/c/de4773f0235a
  - [net,3/3] netfilter: nf_tables: deactivate anonymous set from preparation phase
    https://git.kernel.org/netdev/net/c/c1592a89942e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



