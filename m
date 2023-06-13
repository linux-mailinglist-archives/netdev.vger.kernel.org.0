Return-Path: <netdev+bounces-10268-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2A5272D54A
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 02:00:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24B592810F2
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 00:00:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1562F4404;
	Tue, 13 Jun 2023 00:00:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6F34401
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 00:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24E87C433D2;
	Tue, 13 Jun 2023 00:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686614424;
	bh=kliTCodd6wYpHfGlKYtf/FCCXeowUCACVsZ/qFZvUmM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=LT7JGewdeY18HwKhJom7lXUFLTWQxxqwW87Ev4oAnyxqhaYnx9TYTC1tK6KIG+esQ
	 nRMp4Tg/N2R19V7SS5UHWQ9xrayEgl2PUJrBuD83HX6s1YDYddhsFCxnwfUrzjmezN
	 JE0RjjwjuNBcsl0a7IODy0M+9AAWVPKky5bVxB8pb4e0GWaCWQLCLjowBX9ju7knGl
	 uW44kSnjfImSneXD14HpMaZXs3URq60ihBgDy5eRwF38GSntvD637RPKO4fP0DhSY2
	 0hQd6kkRMqGbfe0zwr/cy1D6Vu/VjbDfEVBj5aEXNltzJh/53AXSW5oOj8wE2b9qdU
	 RbrlIFQoL/k3Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0103EE29F37;
	Tue, 13 Jun 2023 00:00:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2] fixes for Q-USGMII speeds and autoneg
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168661442399.10094.15517056785323276063.git-patchwork-notify@kernel.org>
Date: Tue, 13 Jun 2023 00:00:23 +0000
References: <20230609080305.546028-1-maxime.chevallier@bootlin.com>
In-Reply-To: <20230609080305.546028-1-maxime.chevallier@bootlin.com>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 thomas.petazzoni@bootlin.com, andrew@lunn.ch, f.fainelli@gmail.com,
 hkallweit1@gmail.com, linux@armlinux.org.uk,
 linux-arm-kernel@lists.infradead.org, Horatiu.Vultur@microchip.com,
 Allan.Nielsen@microchip.com, UNGLinuxDriver@microchip.com,
 vladimir.oltean@nxp.com, simon.horman@corigine.com

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  9 Jun 2023 10:03:03 +0200 you wrote:
> This is the second version of a small changeset for QUSGMII support,
> fixing inconsistencies in reported max speed and control word parsing.
> 
> As reported here [1], there are some inconsistencies for the Q-USGMII
> mode speeds and configuration. The first patch in this fixup series
> makes so that we correctly report the max speed of 1Gbps for this mode.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] net: phylink: report correct max speed for QUSGMII
    https://git.kernel.org/netdev/net/c/b9dc1046edfe
  - [net,v2,2/2] net: phylink: use a dedicated helper to parse usgmii control word
    https://git.kernel.org/netdev/net/c/923454c0368b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



