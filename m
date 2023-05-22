Return-Path: <netdev+bounces-4205-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17B9970BA2D
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:30:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E15291C209B2
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 10:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 856DEBA30;
	Mon, 22 May 2023 10:30:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856CABE49
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 10:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 23054C4339B;
	Mon, 22 May 2023 10:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684751420;
	bh=60oETmtEMoW6Y3POJu4Uf47bRMpQb5WkzvMbPw9FTOA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Tmi8rr9ioEvQ5wYuf3DS8NxN31wDqdkZ/sLLcR7jMc6PoS+6K5wlDKdYiTSoJ35ZA
	 bhMHYaSpiR1NlFcB6/QrBD5y6iikS93xr4GRFo4F4XAsWmOVAMCU1bnxbbSWRjAeOl
	 xnY5+qCEgsof39qmnAYYKB2ElFk5G16wUKFVtFGCFp3W4Al7tf4fWaeBLXKBjtOp7+
	 lNNEIz30lq/Rtsrz1S/6mbl4bCYM5pKW6H0mo+LOl2jp/+0mOb9tECoYyoL2DBGqcC
	 RKE6NTZngCnFxeaMCsKib5beTqMhUmUTDJDmGo6ASh9760nwNsqgcK8yn2ZSive5M6
	 ALZZcMvQia1ZQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0A64CC395F8;
	Mon, 22 May 2023 10:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: add helpers for comparing phy IDs
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168475142003.15930.1904911471020251655.git-patchwork-notify@kernel.org>
Date: Mon, 22 May 2023 10:30:20 +0000
References: <E1pzzm3-006BZJ-Bi@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1pzzm3-006BZJ-Bi@rmk-PC.armlinux.org.uk>
To: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 19 May 2023 14:03:59 +0100 you wrote:
> There are several places which open code comparing PHY IDs. Provide a
> couple of helpers to assist with this, using a slightly simpler test
> than the original:
> 
> - phy_id_compare() compares two arbitary PHY IDs and a mask of the
>   significant bits in the ID.
> - phydev_id_compare() compares the bound phydev with the specified
>   PHY ID, using the bound driver's mask.
> 
> [...]

Here is the summary with links:
  - [net-next] net: phy: add helpers for comparing phy IDs
    https://git.kernel.org/netdev/net-next/c/4b159f5048b9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



