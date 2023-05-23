Return-Path: <netdev+bounces-4472-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D39C270D11A
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 04:20:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A52C91C20C12
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 02:20:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C6214C83;
	Tue, 23 May 2023 02:20:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1141860
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 419A6C4339C;
	Tue, 23 May 2023 02:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684808422;
	bh=UUre+IaE2lrZgUIuRvoK9TwWe9vmImwL/pZk5UXVJ7k=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=GFGFxj21ijC7KKf9RvDMKoOeO+xK1hjB4MApzevVTb9Bo/brK7zhEKBHp6nUgmZGy
	 7yZv+OFPATmrJyDca74xD4YrQg4GN0rcSP614S+vEU/yKEcHYDm0tWJcQZinMe9rzI
	 pV1XbAXSVfggcwJZjHzCzqz2vY7O1tO8oBZORMo8GfN9ujW4P3SfAhx9ThFuX7An3H
	 EROiylckHsTEKq64m7XE6ds5MICxoog+XrkrzziA0phngj2VYRFfoJLQdOy1qZji1X
	 dcFrn7DEKloTrL0RpWIUeZ+x0XII1YoYI59mzX2rxToLCU9DlWUxVEdq7wnrqICmxd
	 B5MjRryHn5nIQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 24D2DE22B08;
	Tue, 23 May 2023 02:20:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sfp: add support for a couple of copper
 multi-rate modules
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168480842214.16910.7813242262702580830.git-patchwork-notify@kernel.org>
Date: Tue, 23 May 2023 02:20:22 +0000
References: <E1q0JfS-006Dqc-8t@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1q0JfS-006Dqc-8t@rmk-PC.armlinux.org.uk>
To: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, josua@solid-run.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 20 May 2023 11:18:30 +0100 you wrote:
> Add support for the Fiberstore SFP-10G-T and Walsun HXSX-ATRC-1
> modules. Internally, the PCB silkscreen has what seems to be a part
> number of WT_502. Fiberstore use v2.2 whereas Walsun use v2.6.
> 
> These modules contain a Marvell AQrate AQR113C PHY, accessible through
> I2C 0x51 using the "rollball" protocol. In both cases, the PHY is
> programmed to use 10GBASE-R with pause-mode rate adaption.
> 
> [...]

Here is the summary with links:
  - [net-next] net: sfp: add support for a couple of copper multi-rate modules
    https://git.kernel.org/netdev/net-next/c/5859a99b5225

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



