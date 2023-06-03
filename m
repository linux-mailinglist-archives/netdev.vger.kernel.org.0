Return-Path: <netdev+bounces-7627-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 56D4C720E1C
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 08:30:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B79E11C20968
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 06:30:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06B2F8494;
	Sat,  3 Jun 2023 06:30:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D2AAD5C
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 06:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BD5DEC433A0;
	Sat,  3 Jun 2023 06:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685773824;
	bh=l20n6y1TiLpCpNzJruuHjBjRbNVyJ/3PDd+K9umTlmY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=buXX6OOYebi+/wjsT5y4xiG3f+tP2JZzatemn2Cnx/3N1lYl68cJelVtoahiUemgg
	 jd7G3AJ8jObZl5ICUfff2p6AG0vt/odqA6TwpgSpJ04CMZxdT9F+W/ylyjTkB6B8Ra
	 P4iE7Qu8vf6dCc7x1MOAlqsUxryqwVqlJmN3sgb4gISJf6c5N1jID/19NSxUbej2Ji
	 qxrNeU7MoufKZnX7tWp3XQUlHjhEiBpIriZoPxl56X4DhsyphWXeLFg1q9gspmCCwC
	 ASY0GNcHdxWCbmFg5+ETgvbWfqcMsJ8Ur6wTWOsds9AYLUWqnq3jVecmlXlmV5gM21
	 ACN4Bpam07UMQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A627AC395E0;
	Sat,  3 Jun 2023 06:30:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10] tools: ynl-gen: dust off the user space code
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168577382467.1168.8506596151079358044.git-patchwork-notify@kernel.org>
Date: Sat, 03 Jun 2023 06:30:24 +0000
References: <20230602023548.463441-1-kuba@kernel.org>
In-Reply-To: <20230602023548.463441-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  1 Jun 2023 19:35:38 -0700 you wrote:
> Every now and then I wish I finished the user space part of
> the netlink specs, Python scripts kind of stole the show but
> C is useful for selftests and stuff which needs to be fast.
> Recently someone asked me how to access devlink and ethtool
> from C++ which pushed me over the edge.
> 
> Fix things which bit rotted and finish notification handling.
> This series contains code gen changes only. I'll follow up
> with the fixed component, samples and docs as soon as it's
> merged.
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] tools: ynl-gen: add extra headers for user space
    https://git.kernel.org/netdev/net-next/c/91dfaef243cd
  - [net-next,02/10] tools: ynl-gen: fix unused / pad attribute handling
    https://git.kernel.org/netdev/net-next/c/6ad49839ba9b
  - [net-next,03/10] tools: ynl-gen: don't override pure nested struct
    https://git.kernel.org/netdev/net-next/c/67c65ce762ad
  - [net-next,04/10] tools: ynl-gen: loosen type consistency check for events
    https://git.kernel.org/netdev/net-next/c/5605f102378f
  - [net-next,05/10] tools: ynl-gen: add error checking for nested structs
    https://git.kernel.org/netdev/net-next/c/eef9b794eac8
  - [net-next,06/10] tools: ynl-gen: generate enum-to-string helpers
    https://git.kernel.org/netdev/net-next/c/21b6e302789c
  - [net-next,07/10] tools: ynl-gen: move the response reading logic into YNL
    https://git.kernel.org/netdev/net-next/c/dc0956c98f11
  - [net-next,08/10] tools: ynl-gen: generate alloc and free helpers for req
    https://git.kernel.org/netdev/net-next/c/5d58f911c755
  - [net-next,09/10] tools: ynl-gen: switch to family struct
    https://git.kernel.org/netdev/net-next/c/8cb6afb33541
  - [net-next,10/10] tools: ynl-gen: generate static descriptions of notifications
    https://git.kernel.org/netdev/net-next/c/59d814f0f285

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



