Return-Path: <netdev+bounces-9793-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C376972A9BF
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 09:12:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C1811C211E0
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 07:12:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A84C79C1;
	Sat, 10 Jun 2023 07:12:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372D2A958;
	Sat, 10 Jun 2023 07:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0A355C433D2;
	Sat, 10 Jun 2023 07:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686381136;
	bh=SV22PWx/vlOiTdejfpDBVO98csXRJ2C6VPjBezAOWzI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=kalzse/ySprpbv1069UkP+IVM8InxjJz5Q9SNCg8ITC9GqCb1rRaodzS1STjeVT56
	 JnPRckLNRA2b6zKl2eQCgS84tD5db+Aldx7PUtYoiJf+w+EvVWb+yNmrQPrFWhuVdT
	 iiIDrLd2HfeqeNMsMppyNh8RKaIcWNBzcuIP0I5jInIlWbEJ+rafZL3kfED2f2JIqQ
	 +cD6mtH4nHbyzNkKpx8n+HCj53cSv/4RFrKrtSIeDl4OuM/qgyU4h3RAja+b4ktrio
	 lV0qQ3F3NqM9pWATzncYPlZa7sbq0hGzpmDzUbZzd2qmx/M6ONX9RUA5BLIP0ldURd
	 58H/vuQDRG9qg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EA7DDE1CF31;
	Sat, 10 Jun 2023 07:12:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] mptcp: unify PM interfaces
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168638113595.4960.8012275935135904829.git-patchwork-notify@kernel.org>
Date: Sat, 10 Jun 2023 07:12:15 +0000
References: <20230608-upstream-net-next-20230608-mptcp-unify-pm-interfaces-v1-0-b301717c9ff5@tessares.net>
In-Reply-To: <20230608-upstream-net-next-20230608-mptcp-unify-pm-interfaces-v1-0-b301717c9ff5@tessares.net>
To: Matthieu Baerts <matthieu.baerts@tessares.net>
Cc: mptcp@lists.linux.dev, martineau@kernel.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, geliang.tang@suse.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 08 Jun 2023 15:20:48 +0200 you wrote:
> These patches from Geliang better isolate the two MPTCP path-managers by
> avoiding calling userspace PM functions from the in-kernel PM. Instead,
> new functions declared in pm.c directly dispatch to the right PM.
> 
> In addition to have a clearer code, this also avoids a bit of duplicated
> checks.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] mptcp: export local_address
    https://git.kernel.org/netdev/net-next/c/dc886bce753c
  - [net-next,2/4] mptcp: unify pm get_local_id interfaces
    https://git.kernel.org/netdev/net-next/c/9bbec87ecfe8
  - [net-next,3/4] mptcp: unify pm get_flags_and_ifindex_by_id
    https://git.kernel.org/netdev/net-next/c/f40be0db0b76
  - [net-next,4/4] mptcp: unify pm set_flags interfaces
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



