Return-Path: <netdev+bounces-2591-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FF597028FB
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:40:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20535280CBC
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:40:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EAD7C14C;
	Mon, 15 May 2023 09:40:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE606BE7E
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 09:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 918FEC433D2;
	Mon, 15 May 2023 09:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684143621;
	bh=4jH5OU7W/JIfySLbtZpxmW62V9I8M359dR6ls9SoO9c=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=AjaXWyduGqKaCAnALumNfa6n8bapiSRL3suswoheyML4bCoYXmxiRJV2S78lL4+Zu
	 +xtdMWuUsCkR0s0268aBfs3H2r3wqWvDwBwq3EDSzrBTW0oF1IJbY74gMJkbNbvVmx
	 8bTKEiwzQDARWN11hp84EZ/YEMsozzj4Yoc5uqWZcz/xWtifqLmrfoBYp2W4SdbATf
	 aB70UCG/kkVUpCcjQoWEeUGVGofOcTY0/P6ztDcBIhgq9cqKUE4nmg/AseD99e6Ne5
	 NVn/Q9bM39RVq1WruWiaR6Ha8zsciQ21kxOIXbDuGAsNehIZa8l+MyFeoCnpvNqU3J
	 LpEeJLIvXtv8w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 76733E5421D;
	Mon, 15 May 2023 09:40:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phylink: fix ksettings_set() ethtool call
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168414362148.3400.7170310738920650117.git-patchwork-notify@kernel.org>
Date: Mon, 15 May 2023 09:40:21 +0000
References: <E1pxwP3-003e2k-2P@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1pxwP3-003e2k-2P@rmk-PC.armlinux.org.uk>
To: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 ioana.ciornei@nxp.com, netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Sat, 13 May 2023 22:03:45 +0100 you wrote:
> While testing a Fiberstore SFP-10G-T module (which uses 10GBASE-R with
> rate adaption) in a Clearfog platform (which can't do that) it was
> found that the PHYs advertisement was not limited according to the
> hosts capabilities when using ethtool to change it.
> 
> Fix this by ensuring that we mask the advertisement with the computed
> support mask as the very first thing we do.
> 
> [...]

Here is the summary with links:
  - [net] net: phylink: fix ksettings_set() ethtool call
    https://git.kernel.org/netdev/net/c/df0acdc59b09

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



