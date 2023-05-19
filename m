Return-Path: <netdev+bounces-3837-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ECE8970911E
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 10:00:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CC57281BE8
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 08:00:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E338C3D9C;
	Fri, 19 May 2023 08:00:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C4320F0
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 08:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DB058C433A0;
	Fri, 19 May 2023 08:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684483220;
	bh=7j28Wgv4KxUFWnjJf9HVtsdsEmY2QwncuWnjcX3Ksmw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=cHgkDNpM/b80Zz6Uh15NXUtyPo9HwYnzUlruTLIKCCDUC2/sYl5Z2lQQj/Rv5zVrg
	 cR9vMCEIUJqIhKE18XyTUxvrTJcJujUR2KudPcG+niaZlCnVpede8Njuwnl0Np6+yr
	 qKgDTpnThnB9w15nM3mloeOQ1fdSry+kpQT7+uBVDae3oxE78i8Tz/NBcMGs+gjJuy
	 CmXW/lKq38j8JkSqxRMab6GX+tInv6MjmBOZA/iel9141ozN5PTvpFLdOfFgn4mbdI
	 mfvqGpr7pscCe53NacSNEkSjlrqBa/TcOYmRdbVqDP/AbNPWSNQaNS43bj7H566ITO
	 7yUeJL3X6IAkw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B8387C73FE2;
	Fri, 19 May 2023 08:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] octeontx2-pf: Fix TSOv6 offload
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168448322074.32188.3680270753072564621.git-patchwork-notify@kernel.org>
Date: Fri, 19 May 2023 08:00:20 +0000
References: <20230518064042.3495575-1-rkannoth@marvell.com>
In-Reply-To: <20230518064042.3495575-1-rkannoth@marvell.com>
To: Ratheesh Kannoth <rkannoth@marvell.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 sgoutham@marvell.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, sbhatta@marvell.com, gakula@marvell.com,
 schalla@marvell.com, hkelam@marvell.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 May 2023 12:10:42 +0530 you wrote:
> From: Sunil Goutham <sgoutham@marvell.com>
> 
> HW adds segment size to the payload length
> in the IPv6 header. Fix payload length to
> just TCP header length instead of 'TCP header
> size + IPv6 header size'.
> 
> [...]

Here is the summary with links:
  - [net] octeontx2-pf: Fix TSOv6 offload
    https://git.kernel.org/netdev/net/c/de678ca38861

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



