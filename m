Return-Path: <netdev+bounces-9419-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BA0C7728E19
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 04:40:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 12FB91C20EA2
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 02:40:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBEF210F8;
	Fri,  9 Jun 2023 02:40:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4374B7E5
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 02:40:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 97963C4339B;
	Fri,  9 Jun 2023 02:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686278423;
	bh=ktOKcgJcF42n3ju25sxNzNdwoMPdtvE4MEbMAQ1sHZc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=BRu2EluiE4XIsmXnqAhO+yMK6YmnTPrfUSpZGiVZBxWvMsPPg3/DQTGk76phbtv24
	 Ze9SlcZP06+/tZ+xk+mhvq93UeQjRUWFGZ7CDegayayKbea5Aa+PURTeXpiNLTKq/P
	 xr2Vx8crx+6LjxGXCTKmCXK1W3dM1Qqa+muGic5wyf1DkGORvZ3fuf+hO1e3++2MTJ
	 S+i4UzSDacI9yoyww31ZrDW5qSNm85bwhu+Y9F6ehmVmDt2FCghgDsTEUkM3+ihPnS
	 /WbAZF1tP2uSqpeNxoKndK6tpLkQnCfDHuc7fCd2axvct4s7822ghB2XpNM2ylUei4
	 /nHk3wA5hPJZQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7AD11E87232;
	Fri,  9 Jun 2023 02:40:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] ethtool: ioctl: improve error checking for
 set_wol
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168627842349.12774.1205929814216417059.git-patchwork-notify@kernel.org>
Date: Fri, 09 Jun 2023 02:40:23 +0000
References: <1686179653-29750-1-git-send-email-justin.chen@broadcom.com>
In-Reply-To: <1686179653-29750-1-git-send-email-justin.chen@broadcom.com>
To: Justin Chen <justin.chen@broadcom.com>
Cc: netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
 florian.fainelli@broadcom.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, andrew@lunn.ch,
 d-tatianin@yandex-team.ru, idosch@nvidia.com, marco@mebeim.net,
 wsa+renesas@sang-engineering.com, jiri@resnulli.us, gal@nvidia.com,
 mailhol.vincent@wanadoo.fr, kuniyu@amazon.com, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  7 Jun 2023 16:14:11 -0700 you wrote:
> The netlink version of set_wol checks for not supported wolopts and avoids
> setting wol when the correct wolopt is already set. If we do the same with
> the ioctl version then we can remove these checks from the driver layer.
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Justin Chen <justin.chen@broadcom.com>
> 
> [...]

Here is the summary with links:
  - [v2,net-next] ethtool: ioctl: improve error checking for set_wol
    https://git.kernel.org/netdev/net-next/c/55b24334c0f2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



