Return-Path: <netdev+bounces-10084-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 005A172C1C5
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 13:00:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2EC9D2810C9
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:00:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62FCA13AEA;
	Mon, 12 Jun 2023 11:00:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAFC8828
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 11:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 531CEC4339E;
	Mon, 12 Jun 2023 11:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686567624;
	bh=r0X2TAr+gPr7pslkAM2tRZzvN32ycrAosMvOE3Fh/DI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=c8M/fqBxiGljMN2u9oJUllZd7ax8GxPDKJuMgPiK/Tid96cTXXhd4SNyk6vzuctK8
	 ZbQsmfp1IM2htXrAxlVvoQcGurwd+l8S8ArW6NNvou9Ip9KD4HORnzo/eAeZ54q2MK
	 p7lX/hXfubLljOerOSMvjJ8HMrXpomCpo7B3M0swjhNk7tXBLpdLeMLolq7jG+Wd+I
	 mSOiUZe/4ResLmQVm3Q2UnFB5OzT1BqMb5R6Dju1CK42baJDEADVfW9KSprKEe/ZMs
	 AfxAHJoz/PyHl7osgEZinoXdzlMZGDllZ4cgBqf/bLGyipH14YvpvkOxIR98EyDy1U
	 Otpqfx2qwp+Cg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2EA2EE29F37;
	Mon, 12 Jun 2023 11:00:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5] net: phy: add driver for MediaTek SoC built-in
 GE PHYs
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168656762418.2644.6683801463437104353.git-patchwork-notify@kernel.org>
Date: Mon, 12 Jun 2023 11:00:24 +0000
References: <ZIULuiQrdgV9cZbJ@makrotopia.org>
In-Reply-To: <ZIULuiQrdgV9cZbJ@makrotopia.org>
To: Daniel Golle <daniel@makrotopia.org>
Cc: netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 angelogioacchino.delregno@collabora.com, matthias.bgg@gmail.com,
 SkyLake.Huang@mediatek.com, dqfext@gmail.com, pabeni@redhat.com,
 kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
 linux@armlinux.org.uk, hkallweit1@gmail.com, andrew@lunn.ch

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Sun, 11 Jun 2023 00:48:10 +0100 you wrote:
> Some of MediaTek's Filogic SoCs come with built-in gigabit Ethernet
> PHYs which require calibration data from the SoC's efuse.
> Despite the similar design the driver doesn't share any code with the
> existing mediatek-ge.c.
> Add support for such PHYs by introducing a new driver with basic
> support for MediaTek SoCs MT7981 and MT7988 built-in 1GE PHYs.
> 
> [...]

Here is the summary with links:
  - [net-next,v5] net: phy: add driver for MediaTek SoC built-in GE PHYs
    https://git.kernel.org/netdev/net-next/c/98c485eaf509

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



