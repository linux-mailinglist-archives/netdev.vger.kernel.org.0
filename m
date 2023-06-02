Return-Path: <netdev+bounces-7310-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5781C71F986
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 07:01:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11C4C281A04
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 05:01:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B836538B;
	Fri,  2 Jun 2023 05:00:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BC41851
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 05:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CF78BC4339E;
	Fri,  2 Jun 2023 05:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685682020;
	bh=JTCE64If1fsSrBNk2/QGIK3u3HOrs4NtSPmknwIUOZU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=THhE1AjtUY/xZ7tDFhYtHZdx+NG23UoQSTxGupi5g1vEOS3UciEbeMglXqt0k5ULP
	 ky6lc1BCCXPgo/HX2Ao751ZitBh7E/AK5gnEC2D37EORGhdFrafEmVJX0EwQZQk9YM
	 KAdL3lZ19lNQ3dFarxAplLAoXqaviA1hfZCThQBYNM9cEosuNhhrRR7tfrdTV4dXzb
	 hQoPeOnv79EPsvLxsHZv+cWp9sVuv94CY1aueBYwRxaZo2oAcQfKWKjDpA+jJuP2eg
	 g/eRnSOuNUtGheuIKDh0+axU85OMGiuSbIjp8pCHw3+d3GqKAK3/m8h9t2VFiGv89Z
	 +F0OFzAWTAKLg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ADC2DE4D01A;
	Fri,  2 Jun 2023 05:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next v2] devlink: bring port new reply back
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168568202070.24823.7056866201631700412.git-patchwork-notify@kernel.org>
Date: Fri, 02 Jun 2023 05:00:20 +0000
References: <20230531142025.2605001-1-jiri@resnulli.us>
In-Reply-To: <20230531142025.2605001-1-jiri@resnulli.us>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 davem@davemloft.net, edumazet@google.com, leon@kernel.org, saeedm@nvidia.com,
 moshe@nvidia.com, tariqt@nvidia.com, simon.horman@corigine.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 31 May 2023 16:20:25 +0200 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> In the offending fixes commit I mistakenly removed the reply message of
> the port new command. I was under impression it is a new port
> notification, partly due to the "notify" in the name of the helper
> function. Bring the code sending reply with new port message back, this
> time putting it directly to devlink_nl_cmd_port_new_doit()
> 
> [...]

Here is the summary with links:
  - [net-next,v2] devlink: bring port new reply back
    https://git.kernel.org/netdev/net-next/c/5ff9424ea03a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



