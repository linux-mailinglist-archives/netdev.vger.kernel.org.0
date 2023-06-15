Return-Path: <netdev+bounces-10991-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CE77730F19
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 08:10:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE7B31C20E54
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 06:10:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42AEE15AB;
	Thu, 15 Jun 2023 06:10:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B12A814
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 06:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B86C3C433CB;
	Thu, 15 Jun 2023 06:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686809420;
	bh=yBsF2yGxy6+m0GRyOTF57Yhzmj3bXyoRjSsZnLT9nDU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=rX946Bf04W9+IZQq6hSADW0tllmhWn0eC3T9uP9K+9sGab6av7979hKhZC6OY3pGK
	 BYsU2Qj3rxEY4Dqj6pbaofS/icFRxC+sYLtO/QpVjFNnyoN/v43QNM3L5ds5mlvJyY
	 iSq2/tOe6xKgn5MNaR7m7P+KCFHAhi0S7mJVDlLQ5s4OdftjE9/lqvvkPHQeGYa7Vk
	 R5JumZm3idS/YkA793guJ3zMS3+FmfBZ48qpAsxBT4nUlMSb5z0OhKGeLMCv5mNpH+
	 m8RIT9yZSs5SVyXQi9WewICfYw/HTOij7Lv+tYeveomqNHnkdEaJ9Np7OWiNCZXZj6
	 N7a7wTjYD009w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9F21BE21EEA;
	Thu, 15 Jun 2023 06:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: felix: fix taprio guard band overflow at 10Mbps
 with jumbo frames
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168680942064.31160.5418454678967580591.git-patchwork-notify@kernel.org>
Date: Thu, 15 Jun 2023 06:10:20 +0000
References: <20230613170907.2413559-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230613170907.2413559-1-vladimir.oltean@nxp.com>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
 UNGLinuxDriver@microchip.com, xiaoliang.yang_1@nxp.com,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 13 Jun 2023 20:09:07 +0300 you wrote:
> The DEV_MAC_MAXLEN_CFG register contains a 16-bit value - up to 65535.
> Plus 2 * VLAN_HLEN (4), that is up to 65543.
> 
> The picos_per_byte variable is the largest when "speed" is lowest -
> SPEED_10 = 10. In that case it is (1000000L * 8) / 10 = 800000.
> 
> Their product - 52434400000 - exceeds 32 bits, which is a problem,
> because apparently, a multiplication between two 32-bit factors is
> evaluated as 32-bit before being assigned to a 64-bit variable.
> In fact it's a problem for any MTU value larger than 5368.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: felix: fix taprio guard band overflow at 10Mbps with jumbo frames
    https://git.kernel.org/netdev/net/c/6ac7a27a8b07

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



