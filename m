Return-Path: <netdev+bounces-4206-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A790670BA31
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:31:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7CF701C20A0A
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 10:31:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 695956FA8;
	Mon, 22 May 2023 10:30:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF3DBE53
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 10:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 40954C4339E;
	Mon, 22 May 2023 10:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684751420;
	bh=d27+fBsuyG6rEoeclEswSKUa7VdryGCowSQjfTr9FNE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=udjtZ3Q450JwHEmPK4mKqYLH/+/YDvBtp+4pUIzB20KvWxxe9PQFgNdxLhZZMRy4i
	 bI/IAhQHkIE3NI+C9fTjcwg8EeeJYkt9CThO4Ilj9lL5eeN78vbzVD+QQ34VfaBvZU
	 L52DSqre9Q/0A01gmGvs5TEEtdb7qam2idlihpp0/VSWwWCEQeLsPDh9jJrp+6bKuf
	 1kHi4YtWeosj+zVWUE/WRxy0Rlk0L5LNp3JBfEw7XahwA93Y6KS5QcguUoUKOqEVZ1
	 PLLddHtrWbxp11rHmoz6DQt7VJvGX/VzNHZUDeUwFa0OpfFncSp2pPOHUVD+O753zH
	 d7ceIY4uLBLxA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1EEC9E22B08;
	Mon, 22 May 2023 10:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: altera: tse: remove mac_an_restart() function
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168475142012.15930.6981756076766367675.git-patchwork-notify@kernel.org>
Date: Mon, 22 May 2023 10:30:20 +0000
References: <E1pzxQ0-0062IU-Ql@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1pzxQ0-0062IU-Ql@rmk-PC.armlinux.org.uk>
To: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc: joyce.ooi@intel.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, maxime.chevallier@bootlin.com,
 netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 19 May 2023 11:33:04 +0100 you wrote:
> The mac_an_restart() method will only be called if the driver sets
> legacy_pre_march2020, which the altera tse driver does not do.
> Therefore, providing a stub is unnecessary.
> 
> Fixes: fef2998203e1 ("net: altera: tse: convert to phylink")
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> 
> [...]

Here is the summary with links:
  - [net-next] net: altera: tse: remove mac_an_restart() function
    https://git.kernel.org/netdev/net-next/c/8b6b7c1190c3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



