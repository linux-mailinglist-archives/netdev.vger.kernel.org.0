Return-Path: <netdev+bounces-10086-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F3B3172C1DD
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 13:01:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FB2F1C20AFB
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:01:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C21E3134D6;
	Mon, 12 Jun 2023 11:00:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A71134DE
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 11:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 62C7BC433A1;
	Mon, 12 Jun 2023 11:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686567624;
	bh=MIT6zbNJVH41vY152ACdNrJRC7t+kdcHdJfJZ8JBh6M=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=FaNS+CyXpY/68VfWahxR4NUOxpGQzBv1O9R+8eYWACZWL2ibiEpcBb8r+J+WweNxY
	 eJnc+QNUMZh+KOECv0qKP4qnF39lwvv04/0hy3GSF7rhTT9ShtBqIeET27yRw7VlMX
	 p1gP88mK7vVJbXlXCL5LGytzrplNJknhzrGfzUv758B6o8OFGuDORQS+G/3k8jemos
	 d2Iz1kktQ7og+EpH3qHyomjg/UG2/TtM8ZKzOnJb2bTAFHHZqSjhLZi8MopbnS/zLE
	 xnJZuhchfK1YYAOI1x/QDEzlfKSQHYl4m2RjJg9W8sudd/Yqmsgsr3RAvfeHzd8f4P
	 5Qv6nhwf71iag==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3A45AE4F126;
	Mon, 12 Jun 2023 11:00:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: mlxsw: i2c: Switch back to use struct i2c_driver's
 .probe()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168656762423.2644.8303770072090906182.git-patchwork-notify@kernel.org>
Date: Mon, 12 Jun 2023 11:00:24 +0000
References: <20230612072222.839292-1-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20230612072222.839292-1-u.kleine-koenig@pengutronix.de>
To: =?utf-8?q?Uwe_Kleine-K=C3=B6nig_=3Cu=2Ekleine-koenig=40pengutronix=2Ede=3E?=@codeaurora.org
Cc: idosch@nvidia.com, petrm@nvidia.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, kernel@pengutronix.de

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 12 Jun 2023 09:22:22 +0200 you wrote:
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
  - net: mlxsw: i2c: Switch back to use struct i2c_driver's .probe()
    https://git.kernel.org/netdev/net-next/c/3a2cb45ca0cc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



