Return-Path: <netdev+bounces-8689-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BA18072531E
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 07:00:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2628C1C20BA5
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 05:00:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F7ADED9;
	Wed,  7 Jun 2023 05:00:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9BF7C
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 05:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 29606C433EF;
	Wed,  7 Jun 2023 05:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686114022;
	bh=35GoLuq0jnw4Y6qI56ro58x+k/+rR5iCO9IAcUOyr/E=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=fPCeESEnWOfht6fCCJeq44BP02Gg4A0GIvjgsOcnH1ZZdHgaw1eP4E1vvX3oclk9i
	 aOqeO1goEUYxcXUABjsyCA8mHkXIpACp2DWFPo/gsvrajMYlxI7Uh5Nwjw1LZpR3gL
	 S1JvUZCp4D9iudyh94GV37ZbFhKeW7jqT9goa1OKSLMP34/ZT/8Hxjfu/6Frk5aJ0+
	 bqQ2mjApXABMuvH/YZc+xO91/rLXC3AqtdZ/ZPbdwrmO7CBcNA1bLKK8O8qOwtckV6
	 dnTJ5TfLXuc4tnxkh5fhdAlmeDF8vmuAlyOJM6W7iDXS3PCsuap2Hzob62aKj7fo1w
	 RGKzBXfVcE3SQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0951CE4D016;
	Wed,  7 Jun 2023 05:00:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/5] netfilter: nf_tables: Add null check for
 nla_nest_start_noflag() in nft_dump_basechain_hook()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168611402203.26969.13691085401087491636.git-patchwork-notify@kernel.org>
Date: Wed, 07 Jun 2023 05:00:22 +0000
References: <20230606225851.67394-2-pablo@netfilter.org>
In-Reply-To: <20230606225851.67394-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed,  7 Jun 2023 00:58:47 +0200 you wrote:
> From: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
> 
> The nla_nest_start_noflag() function may fail and return NULL;
> the return value needs to be checked.
> 
> Found by InfoTeCS on behalf of Linux Verification Center
> (linuxtesting.org) with SVACE.
> 
> [...]

Here is the summary with links:
  - [net,1/5] netfilter: nf_tables: Add null check for nla_nest_start_noflag() in nft_dump_basechain_hook()
    https://git.kernel.org/netdev/net/c/bd058763a624
  - [net,2/5] netfilter: nft_bitwise: fix register tracking
    https://git.kernel.org/netdev/net/c/14e8b2939037
  - [net,3/5] netfilter: conntrack: fix NULL pointer dereference in nf_confirm_cthelper
    https://git.kernel.org/netdev/net/c/e1f543dc660b
  - [net,4/5] netfilter: ipset: Add schedule point in call_ad().
    https://git.kernel.org/netdev/net/c/24e227896bbf
  - [net,5/5] netfilter: nf_tables: out-of-bound check in chain blob
    https://git.kernel.org/netdev/net/c/08e42a0d3ad3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



