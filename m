Return-Path: <netdev+bounces-11242-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F0F6F73227B
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 00:10:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E25B1C20AF1
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 22:10:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0D0E17AA8;
	Thu, 15 Jun 2023 22:10:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6922A174FC
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 22:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3357EC433C8;
	Thu, 15 Jun 2023 22:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686867021;
	bh=RZLiGCH1qdhSMndwaQxQgDZRZGsdxP72mh/YBckc+GE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=qbUPrEIeR7rEjexBT3bhE+02gQShNouW6O5TIA6hL+zl2aeFYq4ejKA/eUpTsziWD
	 78saCJANrcB2oMSAVF/qvScR7iIDkoZ5h305SZcEZEp81p8sCnc2GDFalPItZcyGgj
	 HtIJZGAlqhmLBtQUbJ2mhBSy2gdxDG7fn1eliGOdtyPsIKb89neKaJinsiwxauaQsi
	 7ezLQOOKnbkJG0rDp4qsHur4u/Jx86GFJRl2vprbOyOrYqfGEtXHEB6KDBARhQABMK
	 dBlj3Xc6fyKKbDoOxFzLDWakKe1D8RhK5HXOYKdtaV91Ngik1sYbmfJ7aTkR6GIv8N
	 nvTgI84VYC8Vg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0C8B0C3274B;
	Thu, 15 Jun 2023 22:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH v2] net: ethernet: stmicro: stmmac: fix possible memory
 leak in __stmmac_open
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168686702104.9701.257014821594710577.git-patchwork-notify@kernel.org>
Date: Thu, 15 Jun 2023 22:10:21 +0000
References: <20230614091714.15912-1-ansuelsmth@gmail.com>
In-Reply-To: <20230614091714.15912-1-ansuelsmth@gmail.com>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
 joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
 linux@armlinux.org.uk, netdev@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Jose.Abreu@synopsys.com, stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 14 Jun 2023 11:17:14 +0200 you wrote:
> Fix a possible memory leak in __stmmac_open when stmmac_init_phy fails.
> It's also needed to free everything allocated by stmmac_setup_dma_desc
> and not just the dma_conf struct.
> 
> Drop free_dma_desc_resources from __stmmac_open and correctly call
> free_dma_desc_resources on each user of __stmmac_open on error.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: ethernet: stmicro: stmmac: fix possible memory leak in __stmmac_open
    https://git.kernel.org/netdev/net/c/30134b7c47bd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



