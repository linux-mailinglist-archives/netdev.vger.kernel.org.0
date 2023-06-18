Return-Path: <netdev+bounces-11779-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40083734709
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 18:40:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0966281057
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 16:40:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC5E75226;
	Sun, 18 Jun 2023 16:40:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526101C39
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 16:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1AEB5C433C9;
	Sun, 18 Jun 2023 16:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687106419;
	bh=U1FSySq+U9b79O+B14ckaEI0+IvWsB1Uht1VxzfW+eU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=skPz7VgyukHw5Fs+nrvMbc32K/62P+R5opplJbwyuCawW1Coxn7+di/5o3zRVCImV
	 gQOQD5gYkOZ2FJHbD9haBiIEVvSbob98HnYVk0zKHl2sCrCbv4JYL8QIGjMOLx3etq
	 /Bk8aD4HJfPfgEXRpLvUYGTg3A6gKwTh6cPKqHlyQ2fKNCfZshV0/0UOrMXl0LLq5l
	 9jpJyhYjI0vE9/1KNXZTF0QDo8silSTi7bH/rCHpayTdbgTPFanuDofOd0pVJZLQwr
	 PDT6SFcOX0xUcEkp5+YsfWdzoqSkWnyZfHKkRmDuB5Ec9sHJwP84M8MvvEEuFo+lx2
	 ZbdT52ISGBcvw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 00461C395C7;
	Sun, 18 Jun 2023 16:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: Manual remove LEDs to ensure correct ordering
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168710641899.5271.11988489535830400301.git-patchwork-notify@kernel.org>
Date: Sun, 18 Jun 2023 16:40:18 +0000
References: <20230617155500.4005881-1-andrew@lunn.ch>
In-Reply-To: <20230617155500.4005881-1-andrew@lunn.ch>
To: Andrew Lunn <andrew@lunn.ch>
Cc: netdev@vger.kernel.org, hkallweit1@gmail.com, ansuelsmth@gmail.com,
 rmk+kernel@armlinux.org.uk, stable@vger.kernel.org, f.fainelli@gmail.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Sat, 17 Jun 2023 17:55:00 +0200 you wrote:
> If the core is left to remove the LEDs via devm_, it is performed too
> late, after the PHY driver is removed from the PHY. This results in
> dereferencing a NULL pointer when the LED core tries to turn the LED
> off before destroying the LED.
> 
> Manually unregister the LEDs at a safe point in phy_remove.
> 
> [...]

Here is the summary with links:
  - [net] net: phy: Manual remove LEDs to ensure correct ordering
    https://git.kernel.org/netdev/net/c/c938ab4da0eb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



