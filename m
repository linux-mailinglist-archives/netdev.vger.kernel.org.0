Return-Path: <netdev+bounces-8682-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F30FF7252C2
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 06:21:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 603EC1C209C4
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 04:21:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01CFC3FE3;
	Wed,  7 Jun 2023 04:20:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C303A10E2
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 04:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 83EABC4339C;
	Wed,  7 Jun 2023 04:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686111624;
	bh=U/JDhN5RmNc3v7b6FKeO9UswG816ymXj7PTzLxtM0k4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=l15I6Lz7HxMIzq8RdEbwG1hpFOBpQHWDm0HNQ5+ytN3UW+e6k/EM+T1EJ8pwi10Yh
	 qZtEQI5Pn1XmTaWx1muqPpBDVSmNEOL43NLw/3DwE3JHMLiiETp9d36HCP/bpt9v1X
	 gxCjxMEAWwskSzaZUACSy8yDouRLuPqnhabxMLuqc/WZhnppCBhdX6CCra55Hb1o9Y
	 JeL0u0bBSF/abhYupE2oFKHRaKY2TzuGDMpUeL2aCDRcIfIji3Hq+pQgpLUaCIY5qx
	 fz//YEN31uxYr/ekTMQlLrF8/UPMDcy6mzH+TJA4wOWzY+dSY1I8n8h0outS+oMcwi
	 S7M5zbcs6YYCw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 70715E8723C;
	Wed,  7 Jun 2023 04:20:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] ipv4: Remove RT_CONN_FLAGS() calls in
 flowi4_init_output().
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168611162445.32150.17616094899145793582.git-patchwork-notify@kernel.org>
Date: Wed, 07 Jun 2023 04:20:24 +0000
References: <cover.1685999117.git.gnault@redhat.com>
In-Reply-To: <cover.1685999117.git.gnault@redhat.com>
To: Guillaume Nault <gnault@redhat.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, netdev@vger.kernel.org, dsahern@kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 5 Jun 2023 23:55:19 +0200 you wrote:
> Remove a few RT_CONN_FLAGS() calls used inside flowi4_init_output().
> These users can be easily converted to set the scope properly, instead
> of overloading the tos parameter with scope information as done by
> RT_CONN_FLAGS().
> 
> The objective is to eventually remove RT_CONN_FLAGS() entirely, which
> will then allow to also remove RTO_ONLINK and to finally convert
> ->flowi4_tos to dscp_t.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] ipv4: Set correct scope in inet_csk_route_*().
    https://git.kernel.org/netdev/net-next/c/4b095281caca
  - [net-next,2/2] tcp: Set route scope properly in cookie_v4_check().
    https://git.kernel.org/netdev/net-next/c/6f8a76f80221

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



