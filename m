Return-Path: <netdev+bounces-4882-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 135FA70EF67
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:30:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BEA13281050
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 07:30:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06CFF846A;
	Wed, 24 May 2023 07:30:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DAD8468
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 07:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4E1BAC4339C;
	Wed, 24 May 2023 07:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684913421;
	bh=gZSvAZq3Fj5hYYvvyBKbzEyQiCgNkSjrWV4vdIOj9es=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=UjzVeB4cgr5K6VfVP2oo+5iyV+TVCytpUBnvedjeyqBb/wy7MuggTFh/fuHnXSKgU
	 zrrq1lBgO9qt7k9yYwi7vG18Vt9hh/7rcCHuYeYBXMWsGXezKWz8ufwanUIFqmkZEL
	 +q6OBY81k/4fb364IxweQYLQwQsPJwGumrEN8hNCNEA4T/ootCM8fhBWFwBza2Wfzl
	 QXSEdneT/O2GS/m92mYd8go1SJzDyx2g7mlaprN2NvN4CuED8i0nMMeU6djBs8h0RQ
	 2LGEL/Vg54T+lX8ZwT01duOeC0Hz473+tNEl9h+HdklUze7Rlpdf25bM4d1xnIVAWT
	 8H/QKV3Kq/wNQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2CA48E450AF;
	Wed, 24 May 2023 07:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: avoid kernel warning dump when stopping an
 errored PHY
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168491342116.25320.7763841866419843305.git-patchwork-notify@kernel.org>
Date: Wed, 24 May 2023 07:30:21 +0000
References: <E1q17vE-007Baz-8c@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1q17vE-007Baz-8c@rmk-PC.armlinux.org.uk>
To: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 22 May 2023 16:58:08 +0100 you wrote:
> When taking a network interface down (or removing a SFP module) after
> the PHY has encountered an error, phy_stop() complains incorrectly
> that it was called from HALTED state.
> 
> The reason this is incorrect is that the network driver will have
> called phy_start() when the interface was brought up, and the fact
> that the PHY has a problem bears no relationship to the administrative
> state of the interface. Taking the interface administratively down
> (which calls phy_stop()) is always the right thing to do after a
> successful phy_start() call, whether or not the PHY has encountered
> an error.
> 
> [...]

Here is the summary with links:
  - [net-next] net: phy: avoid kernel warning dump when stopping an errored PHY
    https://git.kernel.org/netdev/net-next/c/59088b5a946e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



