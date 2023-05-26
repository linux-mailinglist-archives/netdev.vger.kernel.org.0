Return-Path: <netdev+bounces-5500-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BCFA711E88
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 05:50:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 042C31C20F57
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 03:50:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 274611C26;
	Fri, 26 May 2023 03:50:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60451C05
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 46507C433EF;
	Fri, 26 May 2023 03:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685073020;
	bh=0JQYR3KY4/UySW8HZx0XWagK2hfHSsLhq1SkSBOwPEU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=lTC+e74waFGhfw0VTGaPRnCX4/mwncB6DywVWw2TdqdGv+p7YTbCvcB1GudLojI8f
	 5WB8XN5BkwhH3ub0/k2viiEkrm70f0iQlRxGycEbWqsdDSU8OycGiE2VzwystLe4TH
	 c5GTX6H6a0zY1uSTS158jBy7t4sUMQM7bIxAsxyYtRM4ubRL+4cByyDt3TvLK1y9bq
	 LGL4l8TWdTR287iB9JA44MwBu1iH8HgGnzNVy2NjMdCQD3qQY2o+ynWQKGwEcAWQfu
	 0iPTmERUHcBXHMXlsEwgdqg6UvYZPjePVSNAQFc2FsEw/uni9kvcedXKYtCk6jEYtl
	 wcxyHOeFY3uNw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 206F0E22B06;
	Fri, 26 May 2023 03:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] Immutable branch between LEDs and netdev due for the v6.5
 merge window
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168507302012.13773.5420356511225827719.git-patchwork-notify@kernel.org>
Date: Fri, 26 May 2023 03:50:20 +0000
References: <20230525111521.GA411262@google.com>
In-Reply-To: <20230525111521.GA411262@google.com>
To: Lee Jones <lee@kernel.org>
Cc: andrew@lunn.ch, ansuelsmth@gmail.com, pavel@ucw.cz,
 linux-leds@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
 edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 25 May 2023 12:15:21 +0100 you wrote:
> > Christian Marangi and I will be continuing the work of offloading LED
> > blinking to Ethernet MAC and PHY LED controllers. The next set of
> > patches is again cross subsystem, LEDs and netdev. It also requires
> > some patches you have in for-leds-next:
> >
> > a286befc24e8 leds: trigger: netdev: Use mutex instead of spinlocks
> > 509412749002 leds: trigger: netdev: Convert device attr to macro
> > 0fd93ac85826 leds: trigger: netdev: Rename add namespace to netdev trigger enum modes
> > eb31ca4531a0 leds: trigger: netdev: Drop NETDEV_LED_MODE_LINKUP from mode
> > 3fc498cf54b4 leds: trigger: netdev: Recheck NETDEV_LED_MODE_LINKUP on dev rename
> >
> > I'm assuming the new series will get nerged via netdev, with your
> > Acked-by. Could you create a stable branch with these patches which
> > can be pulled into netdev?
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] Immutable branch between LEDs and netdev due for the v6.5 merge window
    https://git.kernel.org/netdev/net-next/c/78dbc2468de4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



