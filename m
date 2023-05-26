Return-Path: <netdev+bounces-5610-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 523A471240B
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:50:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0F3C1C20FDA
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:50:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 564E7154A1;
	Fri, 26 May 2023 09:50:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1927211C88
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BDFA5C433D2;
	Fri, 26 May 2023 09:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685094619;
	bh=ERS7pDQv4iRQdqwsJL5Wy1eKkdcuQirXp7qS/ypW7uI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=qJuLVeVXYDECNoDcFFHJHcH2bOrgmbj55+lqLZK4HXXxg5y9gC4EYLpDC4RXQEf6m
	 nGO+hGAv3jEBGbRpmkb8D2kSses1wUh3ZI7tTwqdeLMUbJWtI6DjzmCR/B0Y3My70K
	 EncjO/nv2J1RPa7/x1ugd0YDbgJ3ZqFtN/FLZmNRrcSv0I00fY+xgJmWQtkmmn0Zhr
	 UCWCwby6UnWeE2RqYirVnaHcD0NqCoPF4zjiuFDY/KYHLyeC/ezQ6/TQ7t30eRcscD
	 8Fjp6wScTRKGrQufsSdDN29oSSvQFfcEcD+WMI5vMCf5T0AsmRji929OqCS9jXZlmc
	 bILNAZJS2tR7A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9BB04E4D00E;
	Fri, 26 May 2023 09:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net] amd-xgbe: fix the false linkup in xgbe_phy_status
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168509461963.3538.17778891707871616912.git-patchwork-notify@kernel.org>
Date: Fri, 26 May 2023 09:50:19 +0000
References: <20230525182612.868540-1-Raju.Rangoju@amd.com>
In-Reply-To: <20230525182612.868540-1-Raju.Rangoju@amd.com>
To: Raju Rangoju <Raju.Rangoju@amd.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, Thomas.Lendacky@amd.com,
 Shyam-sundar.S-k@amd.com, sudheesh.mavila@amd.com, simon.horman@corigine.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 25 May 2023 23:56:12 +0530 you wrote:
> In the event of a change in XGBE mode, the current auto-negotiation
> needs to be reset and the AN cycle needs to be re-triggerred. However,
> the current code ignores the return value of xgbe_set_mode(), leading to
> false information as the link is declared without checking the status
> register.
> 
> Fix this by propagating the mode switch status information to
> xgbe_phy_status().
> 
> [...]

Here is the summary with links:
  - [v3,net] amd-xgbe: fix the false linkup in xgbe_phy_status
    https://git.kernel.org/netdev/net/c/dc362e20cd6a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



