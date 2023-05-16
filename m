Return-Path: <netdev+bounces-2891-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AD5E7046E9
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 09:50:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A7CE1C20DA5
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 07:50:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 436B71DDED;
	Tue, 16 May 2023 07:50:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44B21D2D0
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6B627C433EF;
	Tue, 16 May 2023 07:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684223420;
	bh=0tUvwxp4wvDStg0wBxJUfUsoJbf18FgMP1AmKe0TL88=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=n0rBKdoSdIBeEQ4O/0IrX2+fEopLPWqnFuSSSRnOav9so3neIA2aynEj+LQrU/dLG
	 LQs0TgLmufYvgwPZcZZ8yaz6JI8YC2/MGtNgqFoQy7UTmH4/9elzgU4WX/NXvCyDzs
	 9IM0cCJyQlTyMjmq7tWs9Np8ZEZqNBSFphxbGEYTfyGe3E4WqIucQ+FAIknrVKbBwO
	 I1AAxwCCVAS5nTMCYdC05PBUP6zxzUSoDk3KPilzy/99rzPNc2REkNB9+EqXrCvhf6
	 o9v7Pw5hsd9swl31d3Qx8krkkO169z79rtLc9kgyBcy8YnhXbGKz5G8ltXdD1cF9a5
	 5PeAspHKyxG2A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 47E43E26D20;
	Tue, 16 May 2023 07:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: bcmgenet: Restore phy_stop() depending upon
 suspend/close
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168422342029.10688.31215089927308789.git-patchwork-notify@kernel.org>
Date: Tue, 16 May 2023 07:50:20 +0000
References: <20230515025608.2587012-1-f.fainelli@gmail.com>
In-Reply-To: <20230515025608.2587012-1-f.fainelli@gmail.com>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: netdev@vger.kernel.org, opendmb@gmail.com,
 bcm-kernel-feedback-list@broadcom.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 14 May 2023 19:56:07 -0700 you wrote:
> Removing the phy_stop() from bcmgenet_netif_stop() ended up causing
> warnings from the PHY library that phy_start() is called from the
> RUNNING state since we are no longer stopping the PHY state machine
> during bcmgenet_suspend().
> 
> Restore the call to phy_stop() but make it conditional on being called
> from the close or suspend path.
> 
> [...]

Here is the summary with links:
  - [net] net: bcmgenet: Restore phy_stop() depending upon suspend/close
    https://git.kernel.org/netdev/net/c/225c657945c4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



