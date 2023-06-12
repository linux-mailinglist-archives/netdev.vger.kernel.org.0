Return-Path: <netdev+bounces-10079-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FB4C72BF4D
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 12:40:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DCF4F28118B
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:40:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35B9A8828;
	Mon, 12 Jun 2023 10:40:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA15911C88
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 10:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7B38FC433D2;
	Mon, 12 Jun 2023 10:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686566421;
	bh=zX9bW2D1TtEl8cAsnrbAGyQz3if4o07gNDoAC1zWuAg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=p7vstxzbs+zZEF/v99GgSBvEpC8s29j4ttINE9GIO6Td/s/Lq5lGG7hvyHFmli7m1
	 UcYrb3JtxsEJXFA8RoQfMXeE7OnKqY5Nv1MkCPLh0fnjzl/vUul44gQ6IZvoHsRxyJ
	 XzGjCM7cIWTWyRHLsmRhA602JJ75oV59JhcbidujtxR7r/Zczq2Jk2EZTPtxqTwpSU
	 EkUx7kFfMHf+WvdpZJ6MwcvfX4UwXlbpyK0H7fAlNtE6iIn3Un6BUV6JlWTpjtTF9n
	 es3XkdcWACo2LcxrI/Gc5VHdFHqnAnxSXWJzcYMR2C3bz1KMDfJIdKnvxcP5Vveo3o
	 Zm2dQ4xh9jROA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 571F4C395EC;
	Mon, 12 Jun 2023 10:40:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: support extack in dump and simplify ethtool
 uAPI
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168656642135.24269.3640135425703841273.git-patchwork-notify@kernel.org>
Date: Mon, 12 Jun 2023 10:40:21 +0000
References: <20230609215331.1606292-1-kuba@kernel.org>
In-Reply-To: <20230609215331.1606292-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, dsahern@gmail.com, mkubecek@suse.cz

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri,  9 Jun 2023 14:53:29 -0700 you wrote:
> Ethtool currently requires header nest to be always present even if
> it doesn't have to carry any attr for a given request. This inflicts
> unnecessary pain on the users.
> 
> What makes it worse is that extack was not working in dump's ->start()
> callback. Address both of those issues.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] netlink: support extack in dump ->start()
    https://git.kernel.org/netdev/net-next/c/5ab8c41cef30
  - [net-next,2/2] net: ethtool: don't require empty header nests
    https://git.kernel.org/netdev/net-next/c/500e1340d1d2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



