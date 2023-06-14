Return-Path: <netdev+bounces-10583-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 635B072F340
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 05:51:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0DBBB281297
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 03:51:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0078363;
	Wed, 14 Jun 2023 03:50:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F487F2
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 03:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 78559C43395;
	Wed, 14 Jun 2023 03:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686714622;
	bh=juHEcyfuutZZBuP3+RBVEa86wImJsw1lpiUaZOpGz+w=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Y7fEgSwBrfyiXnNcnrDrfr41nLFKv2bPDqdEqwryR1+c604hDQbLZtpi7678cDsGl
	 Ce2XOHn1QRJB0LW6TBTN5t1IbpxowQKQueC9eBkL0W4NHYYUvdgoyRFfk1ASUqAemx
	 LEGPvkyGnC34W+TOqT267hY4ANlJPxRS2JWWoMWHMsNuInXakMv274qQ9yCEZhUIIe
	 OuLs+4umg4R2hyVTStkIkYhqD1ZduEc6pzBt6XzjWLiupVcf/WTWS0ncuQbe0V+0bu
	 qVjBw9wVggpg0Q74Bp8fUUYlbknh5oY9ObjlJ+a5UkwY9B1Ajj7mZTnS68a/VRiR5d
	 tMh8C0UiJS+1A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6340DC3274D;
	Wed, 14 Jun 2023 03:50:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] mctp i2c: Switch back to use struct i2c_driver's
 .probe()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168671462239.18215.6473070135392128233.git-patchwork-notify@kernel.org>
Date: Wed, 14 Jun 2023 03:50:22 +0000
References: <20230612071641.836976-1-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20230612071641.836976-1-u.kleine-koenig@pengutronix.de>
To: =?utf-8?q?Uwe_Kleine-K=C3=B6nig_=3Cu=2Ekleine-koenig=40pengutronix=2Ede=3E?=@codeaurora.org
Cc: jk@codeconstruct.com.au, matt@codeconstruct.com.au, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, kernel@pengutronix.de

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 12 Jun 2023 09:16:41 +0200 you wrote:
> After commit b8a1a4cd5a98 ("i2c: Provide a temporary .probe_new()
> call-back type"), all drivers being converted to .probe_new() and then
> commit 03c835f498b5 ("i2c: Switch .probe() to not take an id parameter")
> convert back to (the new) .probe() to be able to eventually drop
> .probe_new() from struct i2c_driver.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - [net-next] mctp i2c: Switch back to use struct i2c_driver's .probe()
    https://git.kernel.org/netdev/net-next/c/e5d4a21b3a94

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



