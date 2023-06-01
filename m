Return-Path: <netdev+bounces-7107-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87CC771A005
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:30:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 420932817A4
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 14:30:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5E8423411;
	Thu,  1 Jun 2023 14:30:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D66B22D43
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 14:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 90331C433EF;
	Thu,  1 Jun 2023 14:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685629819;
	bh=2eT6v1/C9jazgiPlmc7EA3TKFRAj8z2AYljVkDk7Xds=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=N+Ctla4de7wScrzh+1XaCSrzFpax6DikzdHp7zgitOiXL+/pC3aDU4R0qTS178IAl
	 BvdGmSUxeOcje3vO8nKzUEhLAIxCjF55NwsprsDVdeviCTdhRm/1wGXhBa92tYpapN
	 6qesW+UnZ6+z0lw1mYvbIndqpG43o0Wzox9gUrXOOKUJfuK4iUlofOUDiCJ9d1gjtk
	 KcSs51FQHfJwb22FPeJKiIs11NZCMaDA9ZpGrSNnt8sfIY1cGjGnrPfFlVzVa56Usb
	 6m2ipZxj30q/Xw+TLQl/7TRnT2SSapN1waVRNph2dBUHBE8Q4saQF5NRxElQoxiOtT
	 PDi95CNMK7ChA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 797A0E52C02;
	Thu,  1 Jun 2023 14:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Increase wait after reset
 deactivation
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168562981949.12126.5921188118385782118.git-patchwork-notify@kernel.org>
Date: Thu, 01 Jun 2023 14:30:19 +0000
References: <20230530145223.1223993-1-andreas.svensson@axis.com>
In-Reply-To: <20230530145223.1223993-1-andreas.svensson@axis.com>
To: Andreas Svensson <andreas.svensson@axis.com>
Cc: andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 kernel@axis.com, baruch@tkos.co.il, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 30 May 2023 16:52:23 +0200 you wrote:
> A switch held in reset by default needs to wait longer until we can
> reliably detect it.
> 
> An issue was observed when testing on the Marvell 88E6393X (Link Street).
> The driver failed to detect the switch on some upstarts. Increasing the
> wait time after reset deactivation solves this issue.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: mv88e6xxx: Increase wait after reset deactivation
    https://git.kernel.org/netdev/net/c/3c27f3d53d58

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



