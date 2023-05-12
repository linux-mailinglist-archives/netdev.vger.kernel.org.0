Return-Path: <netdev+bounces-2061-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E60F700215
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 10:01:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A751281870
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 08:01:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86804BE48;
	Fri, 12 May 2023 08:00:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E384F8F7E
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 08:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 93C20C4339B;
	Fri, 12 May 2023 08:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683878423;
	bh=Exc4HJM9LFCNVGQsBgUnW7C21ErAjJmwAceOC32DxcM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=X/1ZU7TNtZQ6LrYvhczfFiGotusRDAROcbRx4SDo1DAIuOxBgug1qLFV7bp97VUqf
	 S2vdy8gGS2BhqWTsLDE9vuGv0MjwDzPUTTCEfXJYIF0nlh3O3/2L+PjPLVGChMyV/5
	 0eJY4O34K2zzab8xd2Yr6oHLlAke7oEwdcFd0/XmMUkyNe+ZCqXaY0GsskX3CHlSzQ
	 iNgnbbe1BtKaQn3qMZ48UInN7HmCkNZsXk0NRPmGSPBoy8xux0ojnAgXVV8iGR+toj
	 1EVzxAdv01UdgHgKmYglZ1mdDhS/9zvoSURtESb9rxQtNagnvLQvMKVyEILvstM+F6
	 /FPXqctTwr2Sg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7F03CE450BB;
	Fri, 12 May 2023 08:00:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v2] octeontx2-pf: mcs: Offload extended packet
 number(XPN) feature
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168387842351.16770.13756798429308104106.git-patchwork-notify@kernel.org>
Date: Fri, 12 May 2023 08:00:23 +0000
References: <1683785832-13047-1-git-send-email-sbhatta@marvell.com>
In-Reply-To: <1683785832-13047-1-git-send-email-sbhatta@marvell.com>
To: Subbaraya Sundeep <sbhatta@marvell.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, gakula@marvell.com, naveenm@marvell.com,
 hkelam@marvell.com, lcherian@marvell.com, sgoutham@marvell.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 11 May 2023 11:47:12 +0530 you wrote:
> The macsec hardware block supports XPN cipher suites also.
> Hence added changes to offload XPN feature. Changes include
> configuring SecY policy to XPN cipher suite, Salt and SSCI values.
> 64 bit packet number is passed instead of 32 bit packet number.
> 
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] octeontx2-pf: mcs: Offload extended packet number(XPN) feature
    https://git.kernel.org/netdev/net-next/c/48c0db05a1bf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



