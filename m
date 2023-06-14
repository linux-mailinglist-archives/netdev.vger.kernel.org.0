Return-Path: <netdev+bounces-10675-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7987E72FBCF
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:00:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 66DCB1C20C25
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:00:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5BBD6ABB;
	Wed, 14 Jun 2023 11:00:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591C9138C
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 11:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CBF3AC433C0;
	Wed, 14 Jun 2023 11:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686740420;
	bh=l/cjNPFg+Zb+R5vDWYSB7QtO6p0VKurt4uvAGJYfozQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=cglbrK6Ke5di8QN+coutnMUMKV9suM0GwQjU21S8in2XkaAMIdqWb5006TVME5h2x
	 NuyrYYDcGPovTFvesGxipiE76VhWYzOJOVo/wiORFNmCQIx3ZC79qJyERL+OMar7vh
	 PqOxEr+mYXBdUlaP254kxy7tXxS1gkO/wb55YNf/BNNT+w6gsjqIzpv+0NVxFpz/Ge
	 zaKSSAEn31pEyW/UoBdiqxt+vMzQZd5Y8l3IYFa02Rz40l97SyRRrxezNcQ58lbRx+
	 /lOAHjXLZucAdAqBKrNuQDE5v10o2RxR9NK5PRrSEUFjoClcfBooctBBG/7MlZLARM
	 1h5GcDWKalDzw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AB5F2C64458;
	Wed, 14 Jun 2023 11:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftests: forwarding: hw_stats_l3: Set addrgenmode in a
 separate step
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168674042069.7767.9194264598448863487.git-patchwork-notify@kernel.org>
Date: Wed, 14 Jun 2023 11:00:20 +0000
References: <f3b05d85b2bc0c3d6168fe8f7207c6c8365703db.1686580046.git.petrm@nvidia.com>
In-Reply-To: <f3b05d85b2bc0c3d6168fe8f7207c6c8365703db.1686580046.git.petrm@nvidia.com>
To: Petr Machata <petrm@nvidia.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, netdev@vger.kernel.org, shuah@kernel.org,
 danieller@nvidia.com, idosch@nvidia.com, mlxsw@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 12 Jun 2023 16:34:58 +0200 you wrote:
> From: Danielle Ratson <danieller@nvidia.com>
> 
> Setting the IPv6 address generation mode of a net device during its
> creation never worked, but after commit b0ad3c179059 ("rtnetlink: call
> validate_linkmsg in rtnl_create_link") it explicitly fails [1]. The
> failure is caused by the fact that validate_linkmsg() is called before
> the net device is registered, when it still does not have an 'inet6_dev'.
> 
> [...]

Here is the summary with links:
  - [net] selftests: forwarding: hw_stats_l3: Set addrgenmode in a separate step
    https://git.kernel.org/netdev/net/c/bef68e201e53

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



