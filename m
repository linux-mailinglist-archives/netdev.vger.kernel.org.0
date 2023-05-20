Return-Path: <netdev+bounces-4061-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5942070A593
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 07:10:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CDC3B1C20A60
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 05:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B29B658;
	Sat, 20 May 2023 05:10:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21B67F2
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 05:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4F623C433D2;
	Sat, 20 May 2023 05:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684559420;
	bh=pe11/h611uMiEGIRHVEtgd9ZrK1W/dQtD15KpW2bbuE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=V0R2g2IVvqbf9NPo6iIUSFiTqF6YjwI8J48i4gMbJyLi+ble5M7R6+MYe6rjGqDZk
	 xTECgODKXDEvd0lVz9lwxEd6/KsClWxxp0M1VT/5yWv0opDHsqQ0T8u/Hhs0a/v9rK
	 d1jwMHcIwQveFLH+cwFbV4XeFVqTEZK8oMLjaAHZ618eGkSRW2tcKTLGLfc4CDrTHy
	 YO1Y6Rq5tWYCN4x9U7gKaiuXXVNyk0V3jrDQ1/g9GkeISpHmxEirCK4i0hlMMvO0Zd
	 N5bPsm9SYNlIn3eB7kTDqCPXXriQd61NRgDVhvu7gCRxXgbpYMyEx7D5Np9vOPbG+u
	 DAE9E4rSlq41Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 30B21E5421C;
	Sat, 20 May 2023 05:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3][pull request] Intel Wired LAN Driver Updates
 2023-05-18 (igc, igb, e1000e)
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168455942019.18146.13890177240758141809.git-patchwork-notify@kernel.org>
Date: Sat, 20 May 2023 05:10:20 +0000
References: <20230518170942.418109-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230518170942.418109-1-anthony.l.nguyen@intel.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu, 18 May 2023 10:09:39 -0700 you wrote:
> This series contains updates to igc, igb, and e1000e drivers.
> 
> Kurt Kanzenbach adds calls to txq_trans_cond_update() for XDP transmit
> on igc.
> 
> Tom Rix makes definition of igb_pm_ops conditional on CONFIG_PM for igb.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] igc: Avoid transmit queue timeout for XDP
    https://git.kernel.org/netdev/net-next/c/95b681485563
  - [net-next,2/3] igb: Define igb_pm_ops conditionally on CONFIG_PM
    https://git.kernel.org/netdev/net-next/c/7271522b729b
  - [net-next,3/3] e1000e: Add @adapter description to kdoc
    https://git.kernel.org/netdev/net-next/c/c4dc8dc32bd1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



