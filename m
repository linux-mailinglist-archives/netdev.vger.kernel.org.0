Return-Path: <netdev+bounces-1433-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B8466FDC85
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 13:20:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09E4528140B
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:20:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21C3B8C0A;
	Wed, 10 May 2023 11:20:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726E920B43
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 11:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 27B70C433D2;
	Wed, 10 May 2023 11:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683717620;
	bh=aAiABVe/+jQPNgVvSNDYPi3rJPOkVw4Hn7VlJBkYOp0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ggW78f1jvMlj+g6ucphQ8qBTUbfE388mRy8JKipLthn2MKD7CDUEFZIs+ASIvlRgW
	 X99xQPHqTyvOhlYBx8Y6ktHTP0QNdgYyMYbgn3biguOo3vIrvnbs+W3/42eK4BORRW
	 tUYW/Mz1SB3Q6UpjOBYhoD1FGrT3OnQmO72A1Wwwj0MSm2iBXQGeChs0uqylJfSro2
	 XS4GRNomv5/gz1Knpd19pOKtoxhmBwc5Qyvue7wOTvkMZb7fXDtSx3wZmTHBOc5CCC
	 Y0qmaEwo+ywE5oqnSvFEb7iY20EVhkx7LP9PAbYamGQzKzBL/iXpdJHkfmIq4Jo435
	 Cyj9D+Dun+/pQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0D3A4E26D21;
	Wed, 10 May 2023 11:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v1] net: mscc: ocelot: fix stat counter register values
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168371762005.15306.4629499713441955918.git-patchwork-notify@kernel.org>
Date: Wed, 10 May 2023 11:20:20 +0000
References: <20230510044851.2015263-1-colin.foster@in-advantage.com>
In-Reply-To: <20230510044851.2015263-1-colin.foster@in-advantage.com>
To: Colin Foster <colin.foster@in-advantage.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
 UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
 claudiu.manoil@nxp.com, vladimir.oltean@nxp.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue,  9 May 2023 21:48:51 -0700 you wrote:
> Commit d4c367650704 ("net: mscc: ocelot: keep ocelot_stat_layout by reg
> address, not offset") organized the stats counters for Ocelot chips, namely
> the VSC7512 and VSC7514. A few of the counter offsets were incorrect, and
> were caught by this warning:
> 
> WARNING: CPU: 0 PID: 24 at drivers/net/ethernet/mscc/ocelot_stats.c:909
> ocelot_stats_init+0x1fc/0x2d8
> reg 0x5000078 had address 0x220 but reg 0x5000079 has address 0x214,
> bulking broken!
> 
> [...]

Here is the summary with links:
  - [net,v1] net: mscc: ocelot: fix stat counter register values
    https://git.kernel.org/netdev/net/c/cdc2e28e214f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



