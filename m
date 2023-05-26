Return-Path: <netdev+bounces-5808-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EF17712D1A
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 21:10:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2998A2819CB
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 19:10:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DADA2911A;
	Fri, 26 May 2023 19:10:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B167C290FD
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 19:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5FA38C4339C;
	Fri, 26 May 2023 19:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685128220;
	bh=BXnAQ2oVXPMDepAB0f17uIFqW6aEa7LrTD6UIDHooK8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Uh+NtWwH8V+CY0yxDCUODccuCJq2vTF97227DiJTJi8mYJmLf46mPbLDXMvCh6sYI
	 MoBiERKiyOSLmZQn9SjDAktbIWypsUgrPjmknbS27tKPg5KKcQzUzAJnnqRe86+kG8
	 alPkkuJQQGDRgErsbJSt7p8WAEF74yTFpRfjkJqKjx0pwBBTUHP43f1Gr/hh0vACLp
	 0/Fmwn8ViIXmj0qFhCywW29o+4hob20p1ZjqwVyayn5R14sxG16bhyCPPULF3GWqcb
	 uhH8LFWijJdB79kdNMU+evvl6jNACxoTuJTfRB2tKC2br1yQgMrAUcOcVuHIHxeA0Q
	 45vQKsCBVixxQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4829BE4D00E;
	Fri, 26 May 2023 19:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] ip: remove double space before 'allmulti' flag
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168512822027.18754.500469334913725007.git-patchwork-notify@kernel.org>
Date: Fri, 26 May 2023 19:10:20 +0000
References: <6f33fb3b3479dc333c7dc3145d2e8bbc184b2c2a.1685122479.git.aclaudi@redhat.com>
In-Reply-To: <6f33fb3b3479dc333c7dc3145d2e8bbc184b2c2a.1685122479.git.aclaudi@redhat.com>
To: Andrea Claudi <aclaudi@redhat.com>
Cc: netdev@vger.kernel.org, stephen@networkplumber.org, dsahern@gmail.com

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Fri, 26 May 2023 19:36:54 +0200 you wrote:
> Current output:
> $ ip -d link show vxlan0
> 79: vxlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether b6:f6:12:c3:2d:52 brd ff:ff:ff:ff:ff:ff promiscuity 0  allmulti 0 minmtu 68 maxmtu 65535
> 
> Resulting output:
> $ ip -d link show vxlan0
> 79: vxlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether b6:f6:12:c3:2d:52 brd ff:ff:ff:ff:ff:ff promiscuity 0 allmulti 0 minmtu 68 maxmtu 65535
> 
> [...]

Here is the summary with links:
  - [iproute2] ip: remove double space before 'allmulti' flag
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=72df7f7e25cb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



