Return-Path: <netdev+bounces-6335-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3783F715CE7
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:20:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7330281104
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:20:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F27817AA1;
	Tue, 30 May 2023 11:20:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFAC0174F9
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7B04FC433D2;
	Tue, 30 May 2023 11:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685445619;
	bh=aOaFVcr8/o0lTJtVyqj1EWzFm8u4H3IIJTB/lbJDPQM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=NUA8KU3St44f88s1JThSo1by6NX//5GXtrolJ2M9nIdfKgumEKcXesymifXxAigIJ
	 ZKJgZQW/D2rgGYg+vpQdwdZVdfBu69d244/3FBTYi3isjmvV9m9Xco1F61oSQl5J4p
	 9JWMkiv26SZ4aPvGlQOBYfuGvZDE35D6PSqkWva9y5LdlkiQvNH/Mt4lMdpgBaSifE
	 4ofP09Ff2+zXCDMszd9vH29lB3Ftrr8vNANtRckqg7HopMu7mP0cAKipyfeVzCYDqU
	 n7bubEpdDuFNPqWqjHpM0/WCMqml1dDY5SOwI2wQiE60ccRoNhjmj0K9ytH7l+M6/s
	 rsVQoPnNbcvzQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5D551E52BF5;
	Tue, 30 May 2023 11:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: check for PCI read error in probe
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168544561937.20232.12382191599328367087.git-patchwork-notify@kernel.org>
Date: Tue, 30 May 2023 11:20:19 +0000
References: <75b54d23-fefe-2bf4-7e80-c9d3bc91af11@gmail.com>
In-Reply-To: <75b54d23-fefe-2bf4-7e80-c9d3bc91af11@gmail.com>
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
 edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 28 May 2023 19:35:12 +0200 you wrote:
> Check whether first PCI read returns 0xffffffff. Currently, if this is
> the case, the user sees the following misleading message:
> unknown chip XID fcf, contact r8169 maintainers (see MAINTAINERS file)
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] r8169: check for PCI read error in probe
    https://git.kernel.org/netdev/net-next/c/bc590b475492

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



