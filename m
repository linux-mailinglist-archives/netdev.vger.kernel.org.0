Return-Path: <netdev+bounces-3794-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C880708E12
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 05:00:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DF361C21073
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 03:00:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B0FB397;
	Fri, 19 May 2023 03:00:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30ECC375
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 03:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BAACEC4339B;
	Fri, 19 May 2023 03:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684465221;
	bh=JFpKamKjIzeF4ww1XmkGXtOGIuYIE/hDY2KM1EAqO3k=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Z3PXnTQyI4qkXN5Qwv5AaGJ4+CAbKR/sk2yynRsAlEH4zx53ns2MBU9OReZkZS3oJ
	 EYPDxGflgXlnx6p9/XY3fMbeN9mu5XbN4R54B0tDFrG1pbjVtwwvd6W4Jna0UzNtBz
	 VF8k0IseVxowH5Cs7TksOGFOlfESRMHSockRFm/jnA4h1pVh+JZ0TY9ECjcdP5U3xk
	 eOB4t4ahyE4sv291GbIMRduOXFg95OUYYtQcDz2wq/6XPAqq71bkx677bjBK6v8XUQ
	 Oz6wgxfqcxVY2XlKbT8XPGB/2PnFFzIYY9J2vMl0OvJhaixkuLl1SulsqrydQe/4mA
	 rYiIkRlhSu0AA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9FEE0E21EE0;
	Fri, 19 May 2023 03:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] net: sfp: add support for control of rate
 selection
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168446522165.19635.8763105923097917557.git-patchwork-notify@kernel.org>
Date: Fri, 19 May 2023 03:00:21 +0000
References: <ZGSuTY8GqjM+sqta@shell.armlinux.org.uk>
In-Reply-To: <ZGSuTY8GqjM+sqta@shell.armlinux.org.uk>
To: Russell King (Oracle) <linux@armlinux.org.uk>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org,
 pabeni@redhat.com, daniel@makrotopia.org, kabel@kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 17 May 2023 11:37:01 +0100 you wrote:
> Hi,
> 
> This series introduces control of the rate selection SFP pins (or
> their soft state in the I2C diagnostics EEPROM). Several SNIA documents
> (referenced in the commits) describe the various different modes for
> these, and we implement them all for maximum compatibility, but as
> we know, SFP modules tend to do their own thing, so that may not be
> sufficient.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] net: sfp: add helper to modify signal states
    https://git.kernel.org/netdev/net-next/c/418c1214741c
  - [net-next,2/7] net: sfp: move rtnl lock to cover reading state
    https://git.kernel.org/netdev/net-next/c/d47e5a430dfd
  - [net-next,3/7] net: sfp: swap order of rtnl and st_mutex locks
    https://git.kernel.org/netdev/net-next/c/a9fe964e7aae
  - [net-next,4/7] net: sfp: move sm_mutex into sfp_check_state()
    https://git.kernel.org/netdev/net-next/c/97a492050aa5
  - [net-next,5/7] net: sfp: change st_mutex locking
    https://git.kernel.org/netdev/net-next/c/1974fd3bf0f0
  - [net-next,6/7] net: sfp: add support for setting signalling rate
    https://git.kernel.org/netdev/net-next/c/dc18582211b3
  - [net-next,7/7] net: sfp: add support for rate selection
    https://git.kernel.org/netdev/net-next/c/fc082b39d0a2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



