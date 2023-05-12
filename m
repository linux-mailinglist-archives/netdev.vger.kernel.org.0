Return-Path: <netdev+bounces-1996-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38C7A6FFE49
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 03:10:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D875B2817B9
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 01:10:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7FBF803;
	Fri, 12 May 2023 01:10:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FFF7FA
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 01:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9B7AAC433D2;
	Fri, 12 May 2023 01:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683853821;
	bh=stiD+U2jyW1uL/14k6UIezceLWAqCfoDXitDqW3982w=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=b9pZE/8WFUDMfT+MHFqvxZNKg0Nd9BvdG1ot9IXHDbu57PigSRO6YvAnE301oTTmF
	 ug+EFCSK+0sU148GzdET/op617/lusBg0ecHa7+iBroyBTUTdxMTVGZ7vwtgFKZfWD
	 S4OBfegp1DH5rbljEvX9hN2Pywcjhgy1Nha/YwyNYwxK87oHEJckSOky7p2aoTbKaX
	 /70WAbq5uCJfnayiTlksN6qfG5OofdeyAYh0N2sB/JrIsbZusLIUnFd2gfPUeTmQ8Z
	 JbGMHAn6GKNd3nTgI4aJVuvlFHJqakxzlzTlErB91KzPHUjxorinKjyl9Y3GAXM41G
	 0+LnOhFWTl2Ng==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7F8C4E4D011;
	Fri, 12 May 2023 01:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net] devlink: change per-devlink netdev notifier to static one
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168385382151.13567.18274839895258735630.git-patchwork-notify@kernel.org>
Date: Fri, 12 May 2023 01:10:21 +0000
References: <20230510144621.932017-1-jiri@resnulli.us>
In-Reply-To: <20230510144621.932017-1-jiri@resnulli.us>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 davem@davemloft.net, edumazet@google.com, jacob.e.keller@intel.com,
 saeedm@nvidia.com, moshe@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 10 May 2023 16:46:21 +0200 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> The commit 565b4824c39f ("devlink: change port event netdev notifier
> from per-net to global") changed original per-net notifier to be
> per-devlink instance. That fixed the issue of non-receiving events
> of netdev uninit if that moved to a different namespace.
> That worked fine in -net tree.
> 
> [...]

Here is the summary with links:
  - [net] devlink: change per-devlink netdev notifier to static one
    https://git.kernel.org/netdev/net/c/e93c9378e33f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



