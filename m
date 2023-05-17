Return-Path: <netdev+bounces-3333-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C3507067A6
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:11:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 834161C20C08
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:10:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 975B03111F;
	Wed, 17 May 2023 12:10:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785AD2C752
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 12:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3058EC433A0;
	Wed, 17 May 2023 12:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684325422;
	bh=R0Q7BVGisysDudrFB+dP4girMOSGzrIFWV+mI23tx2k=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=nmKMQ17HxrAv6r0gnvM1kSfzFBYOevPezdAro8VS2sZT0u7CmWccNzMvMTaOF8BCZ
	 7t2M2RJcWNFU6qlOnYpIX8egt+0oYoO81s0qkh16tsJWuD0hxi4jcVBLtljMQqXDOK
	 6Jxqfj9ATf0J+HncV81PIUYUDHBbz8jYxNDrNjhWTkejSozRpVWDh8RZsXsdXtmoaH
	 r6lHlIOVeX7a1ylY/mKyaXPrkdsG0Sv7t2c6zwtDkdWOjdwwd7uAthAHNwAs5KfPzk
	 hL6oboKPNuMtXuj7V92G5RLcoCn9HxEMmzQDk091lmZLPAnt9qYtVpB0Tjk994o0vv
	 DpkAJEmqkBehA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0FD26E21EF6;
	Wed, 17 May 2023 12:10:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: pcs: xpcs: fix C73 AN not getting enabled
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168432542205.5953.12070722335976435657.git-patchwork-notify@kernel.org>
Date: Wed, 17 May 2023 12:10:22 +0000
References: <20230516154410.4012337-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230516154410.4012337-1-vladimir.oltean@nxp.com>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: netdev@vger.kernel.org, Jose.Abreu@synopsys.com, andrew@lunn.ch,
 hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 16 May 2023 18:44:10 +0300 you wrote:
> The XPCS expects clause 73 (copper backplane) autoneg to follow the
> ethtool autoneg bit. It actually did that until the blamed
> commit inaptly replaced state->an_enabled (coming from ethtool) with
> phylink_autoneg_inband() (coming from the device tree or struct
> phylink_config), as part of an unrelated phylink_pcs API conversion.
> 
> Russell King suggests that state->an_enabled from the original code was
> just a proxy for the ethtool Autoneg bit, and that the correct way of
> restoring the functionality is to check for this bit in the advertising
> mask.
> 
> [...]

Here is the summary with links:
  - [net] net: pcs: xpcs: fix C73 AN not getting enabled
    https://git.kernel.org/netdev/net/c/c46e78ba9a7a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



