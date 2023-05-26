Return-Path: <netdev+bounces-5611-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CC89071240C
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:50:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 877D31C20FFC
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:50:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4817E154BD;
	Fri, 26 May 2023 09:50:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40541549F
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AF721C4339B;
	Fri, 26 May 2023 09:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685094620;
	bh=88LQQZrhhsHUg1wC0lIpgl6EBsaUIZ0AIlews0dLdPQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=kCg80OwB3r2lQtKfShnn+H2YHuJAzlycwJ+lfWFoCQHCmdzroYvWBzKYGiZDCMycx
	 C2NpBDdTRtTdOzVFeXkFeNuIcMmYwnITPm/m7/8CSpK8ndi3NI+Qj+VqAPJkqcfxfJ
	 UIgUZsoaJ/u7MtAoAqfeoHxA2uARDwFa/Xp7KWHL+OHNQS/PmTuUvoKL6zk5GdshRw
	 OM3ubX6WmypEyZXw6hcie6EPJSK0S1UTP3FtU/E4Nfei88o1g3wIL11apb2AivK5kC
	 mLDEwd0O2WGno1CiZIqnwt1oKjMqit7RC0+pylC0G2Rwx304AMgbWTVkz+hhY6yi0B
	 Xt5//Nvp6waDw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9A298E22B06;
	Fri, 26 May 2023 09:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: dsa: mv88e6xxx: prepare for phylink_pcs
 conversion
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168509462062.3538.16276825202860254542.git-patchwork-notify@kernel.org>
Date: Fri, 26 May 2023 09:50:20 +0000
References: <ZG86ocZm4YmsWIJN@shell.armlinux.org.uk>
In-Reply-To: <ZG86ocZm4YmsWIJN@shell.armlinux.org.uk>
To: Russell King (Oracle) <linux@armlinux.org.uk>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
 edumazet@google.com, f.fainelli@gmail.com, kuba@kernel.org,
 netdev@vger.kernel.org, pabeni@redhat.com, olteanv@gmail.com

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 25 May 2023 11:38:25 +0100 you wrote:
> Hi,
> 
> These two patches provide some preparation for converting the mv88e6xxx
> DSA driver to use phylink_pcs rather than bolting the serdes bits into
> the MAC calls.
> 
> In order to correctly drive mv88e6xxx hardware when the PCS code is
> split, we need to force the link down while changing the configuration
> of a port. This is provided for via the mac_prepare() and mac_finish()
> methods, but DSA does not forward these on to DSA drivers.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: dsa: add support for mac_prepare() and mac_finish() calls
    https://git.kernel.org/netdev/net-next/c/dd805cf3e80e
  - [net-next,2/2] net: dsa: mv88e6xxx: move link forcing to mac_prepare/mac_finish
    https://git.kernel.org/netdev/net-next/c/267d7692f6cd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



