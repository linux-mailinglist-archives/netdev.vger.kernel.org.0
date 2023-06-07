Return-Path: <netdev+bounces-8681-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FE477252BE
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 06:21:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C0D481C20CBE
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 04:21:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE96F1115;
	Wed,  7 Jun 2023 04:20:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08D510E1
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 04:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8F67DC4339E;
	Wed,  7 Jun 2023 04:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686111624;
	bh=/okTpzrYZ3axlnAeFoiKd20SlCZ5YE115q+7Nvfz4zs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=PnhZPtJEyE4eDnuoFeSYL/lL49E0fEu25DarK+y8k57tFYROY3pBsKGE72VOOuJS9
	 F3Xj74RxARffte8073Z/IPtmjRyPEM5W3BPr6Ct4iSWdaADSgbUhRFjxcAJJm5Jpxf
	 n+niCfwtOz3DbBwK2TgJk1smYUNYLpwoePXLl2gy+l7B9x/CixM/0XGsUbgzyjDzst
	 TJJP1O/DusgdcnpQfvm5K/Y+/0Y8AjiwnjZx79MZhkJi30NP6dN1Oib+6dUWrorecp
	 bfyKyCM71OD4gThfizhR07NtGM/GTFp9D3Xkdrt4CmsG2jO48ZU1aX/CerEKxp0SW7
	 1oOMMA8BghROA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 79C2AE87231;
	Wed,  7 Jun 2023 04:20:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] Move KSZ9477 errata handling to PHY driver
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168611162449.32150.16757073360050768075.git-patchwork-notify@kernel.org>
Date: Wed, 07 Jun 2023 04:20:24 +0000
References: <20230605153943.1060444-1-robert.hancock@calian.com>
In-Reply-To: <20230605153943.1060444-1-robert.hancock@calian.com>
To: Robert Hancock <robert.hancock@calian.com>
Cc: woojung.huh@microchip.com, UNGLinuxDriver@microchip.com, andrew@lunn.ch,
 f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 hkallweit1@gmail.com, linux@armlinux.org.uk, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  5 Jun 2023 09:39:41 -0600 you wrote:
> Patches to move handling for KSZ9477 PHY errata register fixes from
> the DSA switch driver into the corresponding PHY driver, for more
> proper layering and ordering.
> 
> Changed since v1: Rebased on top of correct net-next tree.
> 
> Robert Hancock (2):
>   net: phy: micrel: Move KSZ9477 errata fixes to PHY driver
>   net: dsa: microchip: remove KSZ9477 PHY errata handling
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] net: phy: micrel: Move KSZ9477 errata fixes to PHY driver
    https://git.kernel.org/netdev/net-next/c/26dd2974c5b5
  - [net-next,v2,2/2] net: dsa: microchip: remove KSZ9477 PHY errata handling
    https://git.kernel.org/netdev/net-next/c/6068e6d7ba50

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



