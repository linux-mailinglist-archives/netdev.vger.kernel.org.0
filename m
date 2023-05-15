Return-Path: <netdev+bounces-2566-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D6CD70282A
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:20:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 821011C20AF4
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:20:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 637F7C13E;
	Mon, 15 May 2023 09:20:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3858831
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 09:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B4F2EC4339B;
	Mon, 15 May 2023 09:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684142419;
	bh=sfQaJbwpk5E55vR5d9mc83vnM3aL2DJUTde8XzvB+ss=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=QbeLfg8+1mSQu2hKeZM5dzjPZLj9XGPlLtlknWKRlRlJRwolRdG76nXevH9bMVMMb
	 F7orPn+bNpl7k66cIO8vjtlhbA3Pf0cnr09JshAfo77fFdPVu3yuZvFE8rEtmlzAPg
	 CqZ5aN73qFMLvlVMeNnbUALfbartgTbS+gt58ShvdVfd+V+NjWL4k88lMTfMgbQ8kF
	 zqb5zdZkOyG1vSG9YYPoaTf6yXh1R+2J2xR4+zwP6q8vcMgMPngMQp3VuCqzKV4TJG
	 5UbagJp097nGscTsAkGpKuTbGm3FcQ1Pc2wMcOi+5B/dL9LFKb4lzkTeArky1fkncY
	 7ZSRWj+4BNX4A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8D134E5421D;
	Mon, 15 May 2023 09:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mdio: i2c: fix rollball accessors
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168414241956.23347.3553515744683312213.git-patchwork-notify@kernel.org>
Date: Mon, 15 May 2023 09:20:19 +0000
References: <E1pxl4B-00324m-NP@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1pxl4B-00324m-NP@rmk-PC.armlinux.org.uk>
To: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, kabel@kernel.org,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 michael@walle.cc, netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Sat, 13 May 2023 09:57:27 +0100 you wrote:
> Commit 87e3bee0f247 ("net: mdio: i2c: Separate C22 and C45 transactions")
> separated the non-rollball bus accessors, but left the rollball
> accessors as is. As rollball accessors are clause 45, this results
> in the rollball protocol being completely non-functional. Fix this.
> 
> Fixes: 87e3bee0f247 ("net: mdio: i2c: Separate C22 and C45 transactions")
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> 
> [...]

Here is the summary with links:
  - [net] net: mdio: i2c: fix rollball accessors
    https://git.kernel.org/netdev/net/c/b48a18644046

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



