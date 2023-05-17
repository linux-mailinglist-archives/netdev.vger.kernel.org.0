Return-Path: <netdev+bounces-3231-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F18C4706260
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 10:11:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D215D1C20DDE
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 08:11:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5E55156C8;
	Wed, 17 May 2023 08:10:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF96B15496
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 08:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 62AA2C433D2;
	Wed, 17 May 2023 08:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684311021;
	bh=FX0IyN2kD0uunZUCHkcmKQ3HbQPDxZX6KA9KVA0Ly/o=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=kA9j7juroroeC6tN0+A9SYWSlYxyiGMNWm532MMO1qnvsJXcwPXtCv5dUm3x9zoxD
	 nyZ69uTJqYz969q60wE7NROPsTHpXy8nsjKCgAH6710PnYXsBHD1JfbhcIKqSwMADD
	 SoeFpJprNPl7mtz7UVGyn8YcPJW8ZMIAhyM/N+TzWuYMjqU5DCW6B7Waoj+v1B8KZ8
	 492N6thEVxDnygt6go3vPh0RzuDUMymxVXzARA3Dvw3S8qZVfyV/ny4mH+NnG8bcnK
	 5o56KhO7tkiHkaimsDIXymoL92Une2qGcX7gSy5JqqA/+Qtdsg6yluG06fVpc6V75R
	 VAr3EsoNeDt5g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4770EE21EEC;
	Wed, 17 May 2023 08:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v2] octeontx2-pf: mcs: Support VLAN in clear text
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168431102128.18881.6467481464275762483.git-patchwork-notify@kernel.org>
Date: Wed, 17 May 2023 08:10:21 +0000
References: <1684237231-14217-1-git-send-email-sbhatta@marvell.com>
In-Reply-To: <1684237231-14217-1-git-send-email-sbhatta@marvell.com>
To: Subbaraya Sundeep <sbhatta@marvell.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, gakula@marvell.com, naveenm@marvell.com,
 hkelam@marvell.com, lcherian@marvell.com, sgoutham@marvell.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 16 May 2023 17:10:31 +0530 you wrote:
> Detect whether macsec secy is running on top of VLAN
> which implies transmitting VLAN tag in clear text before
> macsec SecTag. In this case configure hardware to insert
> SecTag after VLAN tag.
> 
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] octeontx2-pf: mcs: Support VLAN in clear text
    https://git.kernel.org/netdev/net-next/c/030d71fd93b1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



